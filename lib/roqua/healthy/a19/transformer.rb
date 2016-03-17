require 'roqua/healthy/a19/name_parser'
require 'roqua/healthy/a19/cdis_name_parser'
require 'roqua/healthy/a19/impulse_name_parser'
require 'roqua/healthy/a19/address_parser'

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
            email:        email,
            address_type: address.address_type,
            street:       address.street,
            city:         address.city,
            zipcode:      address.zipcode,
            country:      address.country,
            birthdate:    birthdate,
            gender:       gender,
            phone_cell:   phone_cell
          }
        end

        def status
          'SUCCESS'
        end

        def source
          message.fetch('MSH').fetch('MSH.4').fetch('MSH.4.1')
        end

        def identities
          message.fetch('PID').fetch('PID.3').map do |identity|
            next if identity.fetch('PID.3.1').blank?
            authority = identity.fetch('PID.3.5')
            # medoq sends all its (possibly identifying) metadata in 1 json encoded identity
            # non medoq hl7 clients could fake being medoq, so do not add any trusted behavior
            # to medoq identities
            if authority == 'MEDOQ'
              {ident: JSON.parse(identity.fetch('PID.3.1')), authority: authority}
            else
              {ident: identity.fetch('PID.3.1'), authority: authority}
            end
          end.compact
        end

        def birthdate
          birthdate_details = message.fetch('PID').fetch('PID.7')
          birthdate_details.fetch('PID.7.1') if birthdate_details
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

        def phone_cell
          phone_cell_record = message.fetch('PID').fetch('PID.13').find do |record|
            record.fetch('PID.13.2', :unknown_type_of_phone_record) == 'ORN'
          end

          phone_cell_record ||= message.fetch('PID').fetch('PID.13').find do |record|
            record.fetch('PID.13.1', '') =~ /\A06/
          end

          return nil unless phone_cell_record

          phone_cell_record.fetch('PID.13.1', "")
        end

        def gender
          message.fetch('PID').fetch('PID.8').fetch('PID.8.1')
        end

        private

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
