# frozen_string_literal: true
require 'roqua/healthy/a19/name_parser'
require 'roqua/healthy/a19/cdis_name_parser'
require 'roqua/healthy/a19/impulse_name_parser'
require 'roqua/healthy/a19/address_parser'
require 'active_support/core_ext/hash'

module Roqua
  module Healthy
    module A19
      class Transformer
        attr_reader :message

        def initialize(message)
          @message = message
          @message['PID']['PID.3']  = [@message.fetch('PID').fetch('PID.3')].flatten.compact
          @message['PID']['PID.5']  = [@message.fetch('PID').fetch('PID.5')].flatten.compact
          @message['PID']['PID.11'] = [@message.fetch('PID').fetch('PID.11')].flatten.compact
          @message['PID']['PID.13'] = [@message.fetch('PID').fetch('PID.13')].flatten.compact
          @message = MessageCleaner.new(@message).message
        end

        def to_patient
          {
            status:       status,
            source:       source,
            identities:   identities,
            firstname:    name.firstname,
            initials:     name.initials,
            lastname:     name.lastname,
            display_name: name.display_name,
            nickname:     name.nickname,
            email:        email,
            address_type: address.address_type,
            street:       address.street,
            city:         address.city,
            zipcode:      address.zipcode,
            country:      address.country,
            birthdate:    birthdate,
            gender:       gender,
            phone_cell:   phone_cell,
            medoq_data:   medoq_data
          }
        end

        def status
          'SUCCESS'
        end

        def source
          message.fetch('MSH').fetch('MSH.4').fetch('MSH.4.1')
        end

        def identities
          @identities ||= message.fetch('PID').fetch('PID.3').map do |identity|
            next if identity.fetch('PID.3.1').blank?
            authority = identity.fetch('PID.3.5')
            # medoq sends all its (possibly identifying) metadata in 1 json encoded identity
            # non medoq hl7 clients could fake being medoq, so do not add any trusted behavior
            # to medoq identities beyond what a regular hl7 field would enable
            if authority == 'MEDOQ'
              parsed_medoq_data = JSON.parse(identity.fetch('PID.3.1')).with_indifferent_access
              {ident: parsed_medoq_data[:epd_id],
               research_number: parsed_medoq_data[:research_number],
               metadata: parsed_medoq_data[:metadata],
               authority: authority}
            else
              {ident: identity.fetch('PID.3.1'), authority: authority}
            end
          end.compact
        end

        def medoq_data
          identities.find do |identity|
            identity[:authority] == 'MEDOQ'
          end || {}
        end

        def birthdate
          birthdate_details = message.fetch('PID').fetch('PID.7')
          birthdate_details&.fetch('PID.7.1')
        end

        def email
          email_record = message.fetch('PID').fetch('PID.13').find do |record|
            record.fetch('PID.13.2', :unknown_type_of_phone_record) == 'NET'
          end
          return nil unless email_record

          email_address = email_record.fetch('PID.13.1', "")
          email_address = email_record.fetch('PID.13.4', "") if email_address.blank?
          email_address
        end

        # this is a heuristic to pick likely dutch cell phone numbers
        # out of the hl7 messages we receive
        def phone_cell
          pid13 = message.fetch('PID').fetch('PID.13')

          # prefer PRN (Primary Residence Number) that contains a cell phone number
          phone_cell_record = pid13.find do |record|
            phone_cell_number?(record.fetch('PID.13.1', '') || '') &&
              record.fetch('PID.13.2', :unknown_type_of_phone_record) == 'PRN'
          end

          # otherwise choose the first occuring cell phone number
          phone_cell_record ||= pid13.find do |record|
            phone_cell_number?(record.fetch('PID.13.1', '') || '')
          end

          # any number for which phone_cell_number? returns false is ignored

          strip_non_phone_number_characters(phone_cell_record.fetch('PID.13.1')) if phone_cell_record.present?
        end

        def gender
          message.dig('PID', 'PID.8', 'PID.8.1')
        end

        private

        # we only strip characters that we can be sure to not matter
        # letters are not stripped since they may be part of a comment, which usually means the
        # phone number is not useable for the purpose of a client's cell phone number
        def strip_non_phone_number_characters(number)
          number.gsub(/[-\s\.]/, '')
        end

        def phone_cell_number?(number)
          strip_non_phone_number_characters(number) =~ /\A(\+31|0|0031)6\d{8}\z/
        end

        def name
          case source
          when "UMCG"
            CdisNameParser.new(message)
          when "IMPULSE"
            ImpulseNameParser.new(message)
          else
            NameParser.new(message)
          end
        end

        def address
          AddressParser.new(message)
        end
      end
    end
  end
end
