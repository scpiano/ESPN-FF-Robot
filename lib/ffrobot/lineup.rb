module FFRobot
    module Lineup
        ESPN_FF_URI = 'https://fantasy.espn.com/apis/v3/games/'

        def set_lineup(team, league, swid, espn_s2)
            current_lineup, bench = get_current_lineup(team)
            roster_changes = get_roster_changes(current_lineup, bench) # player_being_swapped_out:player_being_swapped_in

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

                resp = HTTParty.post(uri, :cookies => cookies, :body => payload.to_json, :headers => headers)
            end
        end

        def get_roster_changes(current_lineup, bench)
            roster_changes = {}

            current_lineup.each do |starting_player|
                bench.each do |bench_player|
                    if starting_player.position_code == bench_player.position_code
                        if !['ACTIVE', 'QUESTIONABLE'].include?(starting_player.injury_status) || starting_player.on_bye
                            roster_changes[starting_player] = bench_player if roster_changes[starting_player].nil? || (bench_player.week_projection > roster_changes[starting_player].week_projection) # TODO: swap season_projection to week_projection
                        elsif bench_player.week_projection > starting_player.week_projection
                            roster_changes[starting_player] = bench_player if roster_changes[starting_player].nil? || (bench_player.week_projection > roster_changes[starting_player].week_projection) # TODO: swap season_projection to week_projection
                        end
                    end
                end
            end

            puts 'Roster Changes' if !roster_changes.empty?
            roster_changes.each do |starter, benchp|
                puts "out: #{starter.name} in: #{benchp.name}"
            end

            return roster_changes
        end 

        def get_current_lineup(team)
            current_lineup = [] # array of players currently starting in fantasy lineup. Includes hash with player_name:player_instance.
            available_bench = [] # players not currently starting and who aren't injured/on bye

            team.roster.each do |player|
                if player.current_lineup_slot != 20
                    current_lineup << player
                elsif !player.on_bye && ['ACTIVE', 'QUESTIONABLE'].include?(player.injury_status)
                    available_bench << player
                end
            end
            
            return current_lineup, available_bench
        end
    end
end