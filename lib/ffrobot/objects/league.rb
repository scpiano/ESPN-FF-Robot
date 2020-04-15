module FFRobot
    module Objects
        module League
            ESPN_FF_URI = 'https://fantasy.espn.com/apis/v3/games/'

            class League
                def initialize(client)#league_id, team_id=nil, username=nil, password=nil, year=nil, swid=nil, espn_s2=nil)
                    @league_id = client.league_id
                    @league_name = ''
                    @members = [] #id and displayname
                    @teams = [] #owner id and team object
                    @nfl_week = 0
                    @league_week = 0
                    @season_id = client.year
                    
                    if client.espn_s2 && client.swid
                        @cookies = {
                            'espn_s2': espn_s2,
                            'SWID': swid
                        }
                    elsif client.username && client.password
                        @cookies = client.authenticate
                    end

                    get_league
                end

                def get_league
                    league_endpoint = "ffl/seasons/#{@season_id}/segments/0/leagues/#{@league_id}" 

                    p @cookies
                    resp = HTTParty.post(full_uri(league_endpoint))
                    p resp
                end

                def full_uri(endpoint)
                    return ESPN_FF_URI + endpoint
                end
            end
        end
    end
end