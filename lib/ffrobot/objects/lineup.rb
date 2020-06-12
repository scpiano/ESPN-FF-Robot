module FFRobot
    module Objects
        module Lineup
            def set_lineup(team)
                current_lineup = get_current_lineup(team)
            end

            def get_current_lineup(team)
                lineup = [] # array of players currently starting. Includes hash with player_name, lineup_slot and week_projection
            end
        end
    end
end