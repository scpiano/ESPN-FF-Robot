module FFRobot
    module Objects
        module Team
            class Team
                attr_accessor :roster, :current_week, :team_id

                def initialize(roster, week, id, season_id)
                    @roster = []
                    @current_week = week
                    @team_id = id

                    get_players roster, @current_week, season_id
                end

                def get_players(roster, week, season_id)
                    roster.each do |player|
                        @roster << Objects::Player::Player.new(player, week, season_id)
                    end
                end
                
            end
        end
    end
end