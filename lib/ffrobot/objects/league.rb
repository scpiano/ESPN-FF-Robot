module FFRobot
    module Objects
        module League
            ESPN_FF_URI = 'https://fantasy.espn.com/apis/v3/games/'

            class League
                attr_accessor :teams, :current_user, :current_user_owner_id
                
                def initialize(client)
                    @current_user = client.username
                    @current_user_owner_id = ''
                    @league_id = client.league_id
                    @league_name = ''
                    @members = {} #displayname and owner id
                    @teams = {} #owner id and team object # currently just current user team
                    @league_week = 0
                    @nfl_week = 0
                    @season_id = client.year

                    @uri = full_uri("ffl/seasons/#{@season_id}/segments/0/leagues/#{@league_id}")
                    
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
                    league_info = HTTParty.get(@uri, :cookies => @cookies)
                    teams = {}

                    @league_name = league_info['settings']['name']
                    @league_week = league_info['status']['currentMatchupPeriod']
                    @nfl_week = league_info['status']['latestScoringPeriod']
\
                    league_info['members'].each do |member|
                        @members[member['displayName']] = member['id']
                    end

                    @current_user_owner_id = @members[@current_user]

                    league_info['teams'].each do |team|
                        teams[team['owners'][0]] = team['id']
                    end

                    get_teams(teams)
                end
                
                def get_teams(teams)
                    params = {'view': 'mRoster'}
                    team_info = HTTParty.get(@uri, :cookies => @cookies, :default_params => params)

                    team_info['teams'].each do |team| 
                        if team['id'] == teams[@members[@current_user]] # just for current user right now
                            current_roster = team['roster']['entries']
                            @teams[@members[@current_user]] = Objects::Team::Team.new(current_roster, @league_week, team['id'])
                            # @teams.each do |owner, team|
                            #     team.roster.each do |player|
                            #         puts player.name, player.season_projection, player.season_actual
                            #     end
                            # end
                            break
                        else 
                            next
                        end
                    end
                end

                def full_uri(endpoint) #TODO: move to helper module later
                    return ESPN_FF_URI + endpoint
                end
            end
        end
    end
end