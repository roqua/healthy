var tmp = new XML("<patient></patient>");
tmp["status"] = status;
tmp["channel"] = Packages.com.mirth.connect.server.controllers.ChannelController.getInstance().getDeployedChannelById(channelId).getName();;

if (status == "FAILURE" || status == "NACK") {
    tmp["error"] = remoteResponse.getMessage();
} else {
    // tmp["ack"] = remoteResponse.getMessage();
    tmp["source"] = msg['MSH']['MSH.4']['MSH.4.1'].toString();

    ///////////////////////////////////////////////////////////////////////////////
    var identities = msg['PID']['PID.3'];
    var idx = 0;
    for each (identity in identities) {
        //    if (clean(identity["PID.3.1"].toString()) != "") {
        var newIdentity = new XML("<identities/>");
        newIdentity["ident"] = identity["PID.3.1"].toString();
        newIdentity["authority"] = identity["PID.3.5"].toString();

        tmp["identities"][idx] = newIdentity;
        idx++;
        //    }
    }

    ///////////////////////////////////////////////////////////////////////////////
    var names = msg['PID']['PID.5']
    var legal_name;
    var display_name;
    var nick_name;

    for each (name in names) {
        if (name['PID.5.7'].toString() == "L") {
            legal_name = name;
        }

        if (name['PID.5.7'].toString() == "D") {
            display_name = name;
        }

        if (name['PID.5.7'].toString() == "N") {
            nick_name = name;
        }
    }

    if (legal_name) {
        if (tmp['source'] == "UMCG") { // UCP
            tmp['firstname']    = clean(legal_name['PID.5.2'].toString());                // J
            tmp['initials']     = clean(legal_name['PID.5.3'].toString());                // A
            tmp['lastname']     = clean(legal_name['PID.5.1']['PID.5.1.3'].toString());   // Fictief
        } else {                // DE REST
            // firstname zit niet in legal name maar in nickname. die pikken we er later uit
            // tmp['firstname']    = '';

            // eerste initiaal zit in 5.2, overige initialen zitten in 5.3 indien aanwezig
            first_initial = clean(legal_name['PID.5.2'].toString()); // J
            rest_initials = clean(legal_name['PID.5.3'].toString()); // A X
            if (rest_initials == '') {
                tmp['initials']   = first_initial;
            } else {
                tmp['initials']   = first_initial + ' ' + rest_initials;
            }

            // lastname zit in 5.1.3, maar "van der" zit misschien in 5.1.2
            lastname        = clean(legal_name['PID.5.1']['PID.5.1.3'].toString()); // Fictief
            lastname_prefix = clean(legal_name['PID.5.1']['PID.5.1.2'].toString()); // van der
            if (lastname_prefix != "") {
                tmp['lastname'] = lastname_prefix + " " + lastname;
            } else {
                tmp['lastname'] = lastname;
            }
        }
    }

    if (display_name) {
        tmp['display_name'] = clean(display_name['PID.5.1']['PID.5.1.1'].toString());
    }

    if (nick_name) {
        tmp['firstname'] = clean(nick_name['PID.5.2'].toString());
    }

    for each (phone in msg['PID']['PID.13']) {
        if (phone['PID.13.2'] && phone['PID.13.2'].toString() == "NET") {
            tmp['email'] = clean(phone['PID.13.1'].toString());
            if (tmp['email'] && tmp['email'] == "") {
                tmp['email'] = clean(phone['PID.13.4'].toString());
            }
        }
    }

    for each (address in msg['PID']['PID.11']) {
        if (address['PID.11.7'] && address['PID.11.7'].toString() == "H") {
            tmp['address_type'] = clean(address['PID.11.7'].toString());
            tmp['street']  = clean(address['PID.11.1']['PID.11.1.1'].toString());
            tmp['city']    = clean(address['PID.11.3'].toString());
            tmp['zipcode'] = clean(address['PID.11.5'].toString());
            tmp['country'] = clean(address['PID.11.6'].toString());
        }
    }

    for each (address in msg['PID']['PID.11']) {
        if (address['PID.11.7'] && address['PID.11.7'].toString() == "M") {
            tmp['address_type'] = clean(address['PID.11.7'].toString());
            tmp['street']  = clean(address['PID.11.1']['PID.11.1.1'].toString());
            tmp['city']    = clean(address['PID.11.3'].toString());
            tmp['zipcode'] = clean(address['PID.11.5'].toString());
            tmp['country'] = clean(address['PID.11.6'].toString());
        }
    }

    tmp['birthdate'] = msg['PID']['PID.7']['PID.7.1'].toString();
    tmp['gender'] = msg['PID']['PID.8']['PID.8.1'].toString();
}
