module FFRobot
    module Objects
        module Player
            class Player
                attr_accessor :player_id, :on_bye, :name, :position_abbrev, :position_code, :current_lineup_slot, :eligible_slots, :nfl_team_id, :nfl_team, :keeper, :injury_status, :season_projection, :season_actual, :week_projection, :week_actual
                POSITION_MAP = { # TODO: move to constants file
                    "0" => 'QB',
                    "1" => 'TQB',
                    "2" => 'RB',
                    "3" => 'RB/WR',
                    "4" => 'WR',
                    "5" => 'WR/TE',
                    "6" => 'TE',
                    "7" => 'OP',
                    "8" => 'DT',
                    "9" => 'DE',
                    "10" => 'LB',
                    "11" => 'DL',
                    "12" => 'CB',
                    "13" => 'S',
                    "14" => 'DB',
                    "15" => 'DP',
                    "16" => 'D/ST',
                    "17" => 'K',
                    "18" => 'P',
                    "19" => 'HC',
                    "20" => 'BE',
                    "21" => 'IR',
                    "22" => '',
                    "23" => 'RB/WR/TE',
                    "24" => 'ER',
                    "25" => 'Rookie'
                }
                NFL_TEAM_ABBREV = { # TODO: move to constants file
                    "-1" => 'Bye',
                    "1" => 'ATL',
                    "2" => 'BUF',
                    "3" => 'CHI',
                    "4" => 'CIN',
                    "5" => 'CLE',
                    "6" => 'DAL',
                    "7" => 'DEN',
                    "8" => 'DET',
                    "9" => 'GB',
                    "10" => 'TEN',
                    "11" => 'IND',
                    "12" => 'KC',
                    "13" => 'OAK',
                    "14" => 'LAR',
                    "15" => 'MIA',
                    "16" => 'MIN',
                    "17" => 'NE',
                    "18" => 'NO',
                    "19" => 'NYG',
                    "20" => 'NYJ',
                    "21" => 'PHI',
                    "22" => 'ARI',
                    "23" => 'PIT',
                    "24" => 'LAC',
                    "25" => 'SF',
                    "26" => 'SEA',
                    "27" => 'TB',
                    "28" => 'WSH',
                    "29" => 'CAR',
                    "30" => 'JAX',
                    "33" => 'BAL',
                    "34" => 'HOU'
                  }

                def initialize(player, week, season_id)
                    @player_id = player['playerId']
                    @on_bye = NFL_TEAM_ABBREV[player['playerPoolEntry']['player']['proTeamId'].to_s] == 'Bye'
                    @name = player['playerPoolEntry']['player']['fullName']
                    @position_abbrev = POSITION_MAP[player['playerPoolEntry']['player']['defaultPositionId'].to_s]
                    @position_code = player['playerPoolEntry']['player']['defaultPositionId']
                    @current_lineup_slot = player['lineupSlotId']
                    @eligible_slots = player['playerPoolEntry']['player']['eligibleSlots']
                    @nfl_team_id = player['playerPoolEntry']['player']['proTeamId']
                    @nfl_team = NFL_TEAM_ABBREV[player['playerPoolEntry']['player']['proTeamId'].to_s]
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