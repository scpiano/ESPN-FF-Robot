module FFRobot
    module Objects
        module Player
            class Player
                attr_accessor :player_id, :bye_week, :name, :position_code, :nfl_team_id, :keeper, :injury_status, :season_projection, :season_actual, :week_projection, :week_actual
                POSITION_MAP = {1 => 'QB',2 => 'RB',3 => 'WR',4 => 'TE',5 => 'K',16 => 'D/ST'}

                def initialize(player, week)
                    @player_id = player['playerId']
                    @bye_week = nil
                    @name = player['player']['fullName']
                    @position_code = POSITION_MAP[player['player']['defaultPositionId']]
                    @nfl_team_id = player['player']['proTeamId']
                    @keeper = player['keeperValue'] == 1
                    @injury_status = player['player']['injuryStatus']
                    @season_projection = nil
                    @season_actual = nil
                    @week_projection = nil
                    @week_actual = nil

                    player['player']['stats'].each do |stats|
                        if stats['statSplitTypeId'] == 0
                            if stats['statSourceId'] == 1 && stats['scoringPeriodId'] == 0 
                                @season_projection = stats['appliedTotal']
                            elsif stats['statSourceId'] == 0 && stats['scoringPeriodId'] == 0 
                                @season_actual = stats['appliedTotal']
                            elsif stats['statSourceId'] == 1 && stats['scoringPeriodId'] == week 
                                @week_projection = stats['appliedTotal']
                            elsif stats['statSourceId'] == 0 && stats['scoringPeriodId'] == week 
                                @week_actual = stats['appliedTotal']
                            end
                        end
                    end

                end

            end
        end
    end
end