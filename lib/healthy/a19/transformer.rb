module Healthy
  module A19
    class Transformer
      attr_reader :message

      def initialize(message)
        @message = message
        puts message.inspect
      end

      def to_patient
        patient = {}
        %i(status channel source identities birthdate gender
           firstname initials lastname display_name nick_name email
           address_type street city zipcode country).each do |key|
          begin
            patient[key] = send(key)
          rescue NameError
            patient[key] = :todo
          end
        end
        patient
      end

      def source
        message.fetch('MSH').fetch('MSH.4').fetch('MSH.4.1')
      end

      def identities
        message.fetch('PID').fetch('PID.3').map do |identity|
          next if identity.fetch('PID.3.1') == "\"\""
          {ident: identity.fetch('PID.3.1'), authority: identity.fetch('PID.3.5')}
        end.compact
      end

      def firstname
        return unless names[:nick]
        names[:nick].fetch('PID.5.2')
      end

      def display_name
        return unless names[:display]
        names[:display].fetch('PID.5.1')
      end

#           if (nick_name) {
#               tmp['firstname'] = clean(nick_name['PID.5.2'].toString());
#           }

      def birthdate
        message.fetch('PID').fetch('PID.7').fetch('PID.7.1')
      end

      def email
        message.fetch('PID').fetch('PID.13').find do |record|
          record.fetch('PID.13.2') == 'NET'
        end.fetch('PID.13.1')
      end

      def gender
        message.fetch('PID').fetch('PID.8').fetch('PID.8.1')
      end

      private

      def names
        names = {}
        message.fetch('PID').fetch('PID.5').each do |record|
          case record.fetch('PID.5.7')
          when 'L'
            names[:legal] = record
          when 'D'
            names[:display] = record
          when 'N'
            names[:nick] = record
          else
            # ignore record
          end
        end
        names
      end

      def addresses
        addressses = {}
        message.fetch('PID').fetch('PID.5').each do |record|
          case record.fetch('PID.5.7')
          when 'L'
            addressses[:legal] = record
          when 'D'
            addressses[:display] = record
          when 'N'
            addressses[:nick] = record
          else
            # ignore record
          end
        end
        addressses
      end

    end
  end
end

#       var tmp = new XML("<patient></patient>");
#       tmp["status"] = status;
#       tmp["channel"] = Packages.com.mirth.connect.server.controllers.ChannelController.getInstance().getDeployedChannelById(channelId).getName();;

#       if (status == "FAILURE" || status == "NACK") {
#           tmp["error"] = remoteResponse.getMessage();
#       } else {
#           // tmp["ack"] = remoteResponse.getMessage();
#           tmp["source"] = msg['MSH']['MSH.4']['MSH.4.1'].toString();


#           ///////////////////////////////////////////////////////////////////////////////
#           var names = msg['PID']['PID.5']
#           var legal_name;
#           var display_name;
#           var nick_name;

#           for each (name in names) {
#               if (name['PID.5.7'].toString() == "L") {
#                   legal_name = name;
#               }

#               if (name['PID.5.7'].toString() == "D") {
#                   display_name = name;
#               }

#               if (name['PID.5.7'].toString() == "N") {
#                   nick_name = name;
#               }
#           }

#           if (legal_name) {
#               if (tmp['source'] == "UMCG") { // UCP
#                   tmp['firstname']    = clean(legal_name['PID.5.2'].toString());                // J
#                   tmp['initials']     = clean(legal_name['PID.5.3'].toString());                // A
#                   tmp['lastname']     = clean(legal_name['PID.5.1']['PID.5.1.3'].toString());   // Fictief
#               } else {                // DE REST
#                   // firstname zit niet in legal name maar in nickname. die pikken we er later uit
#                   // tmp['firstname']    = '';

#                   // eerste initiaal zit in 5.2, overige initialen zitten in 5.3 indien aanwezig
#                   first_initial = clean(legal_name['PID.5.2'].toString()); // J
#                   rest_initials = clean(legal_name['PID.5.3'].toString()); // A X
#                   if (rest_initials == '') {
#                       tmp['initials']   = first_initial;
#                   } else {
#                       tmp['initials']   = first_initial + ' ' + rest_initials;
#                   }

#                   // lastname zit in 5.1.3, maar "van der" zit misschien in 5.1.2
#                   lastname        = clean(legal_name['PID.5.1']['PID.5.1.3'].toString()); // Fictief
#                   lastname_prefix = clean(legal_name['PID.5.1']['PID.5.1.2'].toString()); // van der
#                   if (lastname_prefix != "") {
#                       tmp['lastname'] = lastname_prefix + " " + lastname;
#                   } else {
#                       tmp['lastname'] = lastname;
#                   }
#               }
#           }

#           for each (phone in msg['PID']['PID.13']) {
#               if (phone['PID.13.2'] && phone['PID.13.2'].toString() == "NET") {
#                   tmp['email'] = clean(phone['PID.13.1'].toString());
#                   if (tmp['email'] && tmp['email'] == "") {
#                       tmp['email'] = clean(phone['PID.13.4'].toString());
#                   }
#               }
#           }

#           for each (address in msg['PID']['PID.11']) {
#               if (address['PID.11.7'] && address['PID.11.7'].toString() == "H") {
#                   tmp['address_type'] = clean(address['PID.11.7'].toString());
#                   tmp['street']  = clean(address['PID.11.1']['PID.11.1.1'].toString());
#                   tmp['city']    = clean(address['PID.11.3'].toString());
#                   tmp['zipcode'] = clean(address['PID.11.5'].toString());
#                   tmp['country'] = clean(address['PID.11.6'].toString());
#               }
#           }

#           for each (address in msg['PID']['PID.11']) {
#               if (address['PID.11.7'] && address['PID.11.7'].toString() == "M") {
#                   tmp['address_type'] = clean(address['PID.11.7'].toString());
#                   tmp['street']  = clean(address['PID.11.1']['PID.11.1.1'].toString());
#                   tmp['city']    = clean(address['PID.11.3'].toString());
#                   tmp['zipcode'] = clean(address['PID.11.5'].toString());
#                   tmp['country'] = clean(address['PID.11.6'].toString());
#               }
#           }

#       }

#       //logger.debug("Our response: " + tmp.toXMLString());
#       responseMap.put("A19", ResponseFactory.getSuccessResponse(tmp.toXMLString()));
#   }
# }
