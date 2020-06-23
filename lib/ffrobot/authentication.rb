module FFRobot
    module Authentication
        def authenticate(logger)
            @headers = {'Content-Type' => 'application/json'}
            @payload = {'loginValue' => @username, 'password' => @password}

            api_key_auth()
            resp = HTTParty.post(FFRobot::Constants::LOGIN_URL, :headers => @headers, :body => @payload.to_json)

            if resp.code != 200
                logger.info("Authentication unsuccessful.\nPlease check username and password\nPlease retry authentication or continue without username/password for public league access only")
                return
            end
            if resp['error'] != nil
                logger.info("Authentication unsuccessful.\nError encountered:#{resp['error'].to_s}\nPlease retry authentication or continue without username/password for public league access only.")
                return
            else
                espn_s2 = resp['data']['s2']
                swid = resp['data']['profile']['swid']
                
                logger.info("Authentication successful.\nespn_s2: #{espn_s2}\nswid: #{swid}")
                return espn_s2, swid
            end
        end

        def api_key_auth(logger)
            resp = HTTParty.post(FFRobot::Constants::API_KEY_URL, :headers => @headers)
            if resp && resp.headers['api-key']
                @api_key = resp.headers['api-key']
            else
                logger.info("Authentication unsuccessful.\nUnable to receive API key.\nPlease retry authentication or continue without username/password for public league access only")
                return
            end
            @headers['authorization'] = 'APIKEY '.concat(@api_key)
        end

        def authenticated?
            @api_key != nil
            @espn_s2 != nil
            @swid != nil
        end

        def reauthenticate
            @api_key = nil
            @espn_s2 = nil
            @swid = nil
            authenticate()
        end
    end
end