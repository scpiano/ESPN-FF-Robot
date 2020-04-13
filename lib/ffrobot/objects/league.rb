module FFRobot
    module Objects
        module League
            ESPN_FF_URI = 'https://fantasy.espn.com/apis/v3/games/'
            LEAGUE_ENDPOINT = "ffl/seasons/#{@year}/segments/0/leagues/#{@league_id}" 

            class League
                def initialize
                end
                def get_league
                end
            end
        end
    end
end