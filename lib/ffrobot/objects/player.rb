module FFRobot
    module Objects
        module Player
            class Player
                attr_accessor :player_id, :on_bye, :name, :position_abbrev, :position_code, :current_lineup_slot, :eligible_slots, :nfl_team_id, :nfl_team, :keeper, :injury_status, :season_projection, :season_actual, :week_projection, :week_actual
                
                def initialize(player, week, season_id)
                    @player_id = player['playerId']
                    @on_bye = FFRobot::Constants::NFL_TEAM_ABBREV[player['playerPoolEntry']['player']['proTeamId'].to_s] == 'Bye'
                    @name = player['playerPoolEntry']['player']['fullName']
                    @position_abbrev = FFRobot::Constants::POSITION_MAP[player['playerPoolEntry']['player']['defaultPositionId'].to_s]
                    @position_code = player['playerPoolEntry']['player']['defaultPositionId']
                    @current_lineup_slot = player['lineupSlotId']
                    @eligible_slots = player['playerPoolEntry']['player']['eligibleSlots']
                    @nfl_team_id = player['playerPoolEntry']['player']['proTeamId']
                    @nfl_team = FFRobot::Constants::NFL_TEAM_ABBREV[player['playerPoolEntry']['player']['proTeamId'].to_s]
                    @keeper = player['playerPoolEntry']['keeperValue'] == 1
                    @injury_status = player['playerPoolEntry']['player']['injuryStatus']
                    @season_projection = nil
                    @season_actual = nil
                    @week_projection = nil
                    @week_actual = nil

                    player['playerPoolEntry']['player']['stats'].each do |stats|
                        if [0,1].include? stats['statSplitTypeId'] and stats['seasonId'] == season_id
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