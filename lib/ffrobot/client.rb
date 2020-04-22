module FFRobot
    class Client
      include Authentication
      include HTTParty
  
      include Objects::League
    #   include Objects::Lineup
    #   include Objects::Player
    #   include Objects::Team
  
      attr_accessor :league_id, :team_id, :username, :password, :year, :swid, :espn_s2
  
      def initialize 
        options = {}

        OptionParser.new do |opts|
            opts.banner = "Usage: ruby espn-ff-robot.rb [options]"
            opts.on("-l", "--leagueid LEAGUEID", String, "REQUIRED - fantasy league ID") do |lid|
                options[:league_id] = lid
            end
            opts.on("-t", "--teamid TEAMID", Integer, "Your fantasy team's ID within the same league") do |tid|
                options[:team_id] = tid
            end
            opts.on("-u", "--username USERNAME", String, "ESPN username") do |user|
                options[:username] = user
            end
            opts.on("-p", "--password PASSWORD", String, "ESPN password") do |pass|
                options[:password] = pass
            end
            opts.on("-y", "--year YEAR", Integer, "Year in which a season was played") do |year|
                options[:year] = year
            end
            opts.on("-s", "--swid SWID", String, "ESPN API software identification ID") do |swid|
                options[:swid] = swid
            end
            opts.on("-e", "--espn_s2 ESPN_S2", String, "ESPN API S2 cookie") do |espn_s2|
                options[:espn_s2] = espn_s2
            end
            # opts.on("-c", "--command [COMMAND]", String, "Command to run FFRobot with") do |cmd|
            #     options[:command] = cmd
            # end
            opts.on("-h", "--help", "Prints out usage options") do 
                puts opts
                exit
            end
        end.parse!
        
        raise OptionParser::MissingArgument if options[:league_id].nil?

        @league_id = options[:league_id]
        @team_id = options[:team_id] || nil
        @username = options[:username] || nil
        @password = options[:password] || nil
        @year = options[:year] || Time.new.year
        @swid = options[:swid] || nil
        @espn_s2 = options[:espn_s2] || nil
        # @command = options[:command]

      end

      def self.exec_command(client, league)
        if @command == 'set_lineup'
            set_lineup
        else
            puts "Invalid command.\nPlease try again with a valid command."
        end
      end
    end

    client = Client.new
    # client.authenticate
    league = Objects::League::League.new(client)
    # client.exec_command
end
  