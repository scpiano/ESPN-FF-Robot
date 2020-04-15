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
                    @league_week = 0
                    @nfl_week = 0
                    @season_id = client.year
                    
                    if client.espn_s2 && client.swid
                        @cookies = {
                            'espn_s2': client.espn_s2,
                            'SWID': client.swid
                        }
                    elsif client.username && client.password
                        @cookies = client.authenticate
                    end

                    get_league
                end

                def get_league
                    league_endpoint = "ffl/seasons/#{@season_id}/segments/0/leagues/#{@league_id}" 
                    league_info = HTTParty.get(full_uri(league_endpoint), :cookies => @cookies)

                    @league_name = league_info['settings']['name']
                    @league_week = league_info['status']['currentMatchupPeriod']
                    @nfl_week = league_info['status']['latestScoringPeriod']

                    league_info['members'].each do |member|
                        @members << {member['displayName'] => member['id']}
                    end

                    league_info['teams'].each do |team|
                        @teams << {team['id'] => team['owners'][0]}
                    end
                end

                def full_uri(endpoint) #move to helper module later
                    return ESPN_FF_URI + endpoint
                end
            end
        end
    end
end