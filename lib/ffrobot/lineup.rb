module FFRobot
    module Lineup
        def set_lineup(team)
            current_lineup, bench = get_current_lineup(team)
            roster_changes = get_roster_changes(current_lineup, bench) # player_being_swapped_out:player_being_swapped_in


        end

        def get_roster_changes(current_lineup, bench)
            roster_changes = {}

            current_lineup.each do |starting_player|
                bench.each do |bench_player|
                    if starting_player.position_code == bench_player.position_code
                        if starting_player.injury_status != 'ACTIVE' || starting_player.on_bye
                            roster_changes[starting_player] = bench_player if roster_changes[starting_player].nil? || (bench_player.season_projection > roster_changes[starting_player].season_projection) # TODO: swap season_projection to week_projection
                        elsif bench_player.season_projection > starting_player.season_projection
                            roster_changes[starting_player] = bench_player if roster_changes[starting_player].nil? || (bench_player.season_projection > roster_changes[starting_player].season_projection) # TODO: swap season_projection to week_projection
                        end
                    end
                end
            end

            puts 'roster changes'
            roster_changes.each do |player, benchp|
                puts "out: #{player.name} in: #{benchp.name}"
            end

            return roster_changes
        end 

        def get_current_lineup(team)
            current_lineup = [] # array of players currently starting in fantasy lineup. Includes hash with player_name:player_instance.
            available_bench = [] # players not currently starting and who aren't injured/on bye

            team.roster.each do |player|
                if player.current_lineup_slot != 20
                    current_lineup << player
                elsif !player.on_bye && player.injury_status == 'ACTIVE'
                    available_bench << player
                end
            end
            
            puts "bench: #{available_bench}"
            return current_lineup, available_bench
        end
    end
end