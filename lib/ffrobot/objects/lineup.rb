module FFRobot
    module Objects
        module Lineup
            class Lineup
                attr_accessor :league

                def initialize(league)
                    @league = league
                    @current_lineup = current_lineup
                end

                def current_lineup
                end

                def set_lineup
                end
            end
        end
    end
end