module FFRobot
    module Authentication
        API_KEY_URL = 'https://registerdisney.go.com/jgc/v5/client/ESPN-FANTASYLM-PROD/api-key?langPref=en-US'
        LOGIN_URL = 'https://ha.registerdisney.go.com/jgc/v5/client/ESPN-FANTASYLM-PROD/guest/login?langPref=en-US'

        def authenticate
            @headers = {'Content-Type' => 'application/json'}
            @payload = {'loginValue' => @username, 'password' => @password}
            api_key_auth
            resp = HTTParty.post(LOGIN_URL, :headers => @headers, :body => @payload.to_json)
            # puts "headers: #{@headers}, \npayload: #{@payload}, \nuri: #{resp.request.last_uri.to_s}, \n#{resp.request.options.to_s}"
            if resp.code != 200
                puts "Authentication unsuccessful.\nPlease check username and password\nPlease retry authentication or continue without username/password for public league access only"
                # puts resp['error']
                return
            end
            if resp['error'] != nil
                puts "Authentication unsuccessful.\nError encountered:#{resp['error'].to_s}\nPlease retry authentication or continue without username/password for public league access only."
                return
            else
                espn_s2 = resp['data']['s2']
                swid = resp['data']['profile']['swid']
                
                puts "Authentication successful.\nespn_s2: #{espn_s2}\nswid: #{swid}"
                return espn_s2, swid
            end
        end

        def api_key_auth
            resp = HTTParty.post(API_KEY_URL, :headers => @headers)
            if resp && resp.headers['api-key']
                @api_key = resp.headers['api-key']
            else
                puts "Authentication unsuccessful.\nUnable to receive API key.\nPlease retry authentication or continue without username/password for public league access only"
                return
            end
            @headers['authorization'] = 'APIKEY '.concat(@api_key)
            # puts "api_key: #{@api_key}"
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
            authenticate
        end
    end
end