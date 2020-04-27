module FFRobot
    module Objects
        module Team
            class Team
                attr_accessor :players, :roster

                def initialize(roster)
                    @roster = []
                    @team_id
                    @team_name

                    get_players roster
                end

                def get_players(roster)
                    roster.each do |player|
                        @roster << Objects::Player::Player.new(player)
                    end
                end
                
            end
        end
    end
end