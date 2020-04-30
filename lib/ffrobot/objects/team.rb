module FFRobot
    module Objects
        module Team
            class Team
                attr_accessor :roster, :current_week, :team_id

                def initialize(roster, week, id)
                    @roster = []
                    @current_week = week
                    @team_id = id

                    get_players roster, @current_week
                end

                def get_players(roster, week)
                    roster.each do |player|
                        @roster << Objects::Player::Player.new(player['playerPoolEntry'], week)
                    end
                end
                
            end
        end
    end
end