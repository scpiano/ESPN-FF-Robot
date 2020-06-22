module FFRobot
    module Lineup
        ESPN_FF_URI = 'https://fantasy.espn.com/apis/v3/games/'
        STANDARD_LINEUP = [0,2,2,4,4,6,16,17,23]

        def set_lineup(team, league, swid, espn_s2)
            current_lineup, bench, unset_positions = get_current_lineup(team)
            roster_changes = get_roster_changes(current_lineup, bench, unset_positions) 

            make_roster_changes(roster_changes, league, team, swid, espn_s2)
        end

        def make_roster_changes(roster_changes, league, team, swid, espn_s2)
            uri = ESPN_FF_URI + "ffl/seasons/#{league.season_id}/segments/0/leagues/#{league.league_id}/transactions/"
            headers = {'Content-Type' => 'application/json'}
            cookies = {
                'espnAuth' => {"swid" => '{'+swid+'}'},
                'SWID' => '{'+swid+'}',
                'espn_s2' => espn_s2
            }
            
            roster_changes.each do |starter, benchp|
                if starter.is_a? Integer 
                    payload = {
                        "executionType": "EXECUTE",
                        "isLeagueManager": false,
                        "items": [
                            {
                                "playerId": benchp.values.first.player_id,
                                "type": "LINEUP",
                                "fromLineupSlotId": benchp.values.first.current_lineup_slot,
                                "toLineupSlotId": benchp.keys.first
                            }
                        ],
                        "memberId": "{#{swid}}",
                        "scoringPeriodId": team.current_week,
                        "teamId": team.team_id,
                        "type": "ROSTER"
                    }
                else
                    payload = {
                        "executionType": "EXECUTE",
                        "isLeagueManager": false,
                        "items": [
                            {
                                "playerId": starter.player_id,
                                "type": "LINEUP",
                                "fromLineupSlotId": starter.current_lineup_slot,
                                "toLineupSlotId": benchp.current_lineup_slot
                            },
                            {
                                "playerId": benchp.player_id,
                                "type": "LINEUP",
                                "fromLineupSlotId": benchp.current_lineup_slot,
                                "toLineupSlotId": starter.current_lineup_slot
                            }
                        ],
                        "memberId": "{#{swid}}",
                        "scoringPeriodId": team.current_week,
                        "teamId": team.team_id,
                        "type": "ROSTER"
                    }
                end

                resp = HTTParty.post(uri, :cookies => cookies, :body => payload.to_json, :headers => headers)
            end
        end

        def get_roster_changes(current_lineup, bench, unset_positions)
            roster_changes = {}

            current_lineup.each do |starting_player|
                bench.each do |bench_player|
                    if bench_player.eligible_slots.include?(starting_player.current_lineup_slot) && !roster_changes.values.include?(bench_player)
                        if (!['ACTIVE', 'QUESTIONABLE'].include?(starting_player.injury_status) || starting_player.on_bye) && ['ACTIVE', 'QUESTIONABLE'].include?(bench_player.injury_status) && !bench_player.on_bye
                            roster_changes[starting_player] = bench_player if roster_changes[starting_player].nil? || (bench_player.week_projection > roster_changes[starting_player].week_projection)
                        elsif bench_player.week_projection > starting_player.week_projection && ['ACTIVE', 'QUESTIONABLE'].include?(bench_player.injury_status) && !bench_player.on_bye
                            roster_changes[starting_player] = bench_player if roster_changes[starting_player].nil? || (bench_player.week_projection > roster_changes[starting_player].week_projection)
                        end
                    else
                        i = 0
                        unset_positions.each do |pos|
                            if bench_player.eligible_slots.include?(pos) && !roster_changes.values.include?(bench_player)
                                if ['ACTIVE', 'QUESTIONABLE'].include?(bench_player.injury_status) && !bench_player.on_bye
                                    roster_changes[pos+i] = {pos => bench_player} if roster_changes[pos+i].nil? || (bench_player.week_projection > roster_changes[pos+i].values.first.week_projection)
                                    i += 1
                                end
                            end
                        end
                    end
                end
            end

            if !roster_changes.empty? 
                puts 'Roster changes:'
                roster_changes.each do |starter, benchp|
                    puts "out: #{starter.is_a?(Integer) ? starter : starter.name} in: #{benchp.is_a?(Hash) ? benchp.values.first.name : benchp.name}"
                end
            else
                puts 'No roster changes made.'
            end

            return roster_changes
        end 

        def get_current_lineup(team)
            current_lineup = []
            available_bench = []

            team.roster.each do |player|
                if player.current_lineup_slot != 20
                    current_lineup << player
                elsif !player.on_bye && ['ACTIVE', 'QUESTIONABLE'].include?(player.injury_status)
                    available_bench << player
                end
            end
            
            set_positions = current_lineup.map { |player| player.current_lineup_slot }
            unset_positions = difference(STANDARD_LINEUP, set_positions)

            return current_lineup, available_bench, unset_positions
        end

        def difference(a, b) # TODO: move to helper module
            ha = a.group_by(&:itself).map{|k, v| [k, v.length]}.to_h
            hb = b.group_by(&:itself).map{|k, v| [k, v.length]}.to_h
            hc = ha.merge(hb){|_, va, vb| (va - vb).abs}.inject([]){|a, (k, v)| a + [k] * v}
            return hc
        end
    end
end