module FFRobot
    module Objects
        module Player
            class Player
                attr_accessor :name, :position_code, :nfl_team_id, :keeper, :injury_status, :ppr_season_avg, :std_season_avg, :ppr_week_projection, :std_week_projection
                position_map = {1: 'QB',2: 'RB',3: 'WR',4: 'TE',5: 'K',16: 'D/ST'}

                def initialize(player)
                    @player_id = player['playerId']
                    @name = player['playerPoolEntry']['player']['fullName']
                    @position_code = position_map[player['lineupSlotId']]
                    @nfl_team_id = player['playerPoolEntry']['player']['proTeamId']
                    @keeper = player['playerPoolEntry']['keeperValue'] == 1
                    @injury_status = player['playerPoolEntry']['player']['injuryStatus']
                    @ppr_season_projection = player['playerPoolEntry']['player']['stats']
                    @ppr_week_projection = player['playerPoolEntry']['player']['stats']
                    @std_season_projection = player['playerPoolEntry']['player']['stats']
                    @std_week_projection = player['playerPoolEntry']['player']['stats']
                end

            end
        end
    end
end