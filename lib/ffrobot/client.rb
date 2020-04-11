module FFRobot
    class Client
      include Authentication
      include HTTParty
    #   base_uri 'https://fantasy.espn.com/apis/v3/games/'
  
    #   include Objects::League
    #   include Objects::Lineup
    #   include Objects::Player
    #   include Objects::Team
  
      attr_accessor :league_id, :team_id, :username, :password, :swid, :espn_s2
  
      def initialize 
        options = {}

        OptionParser.new do |opts|
            opts.banner = "Usage: ruby authentication.rb [options]"
            opts.on("-l", "--leagueid [LEAGUEID]", String, "Fantasy league ID") do |lid|
                options[:league_id] = lid
            end
            opts.on("-t", "--teamid", String, "Your fantasy team's ID within the same league") do |tid|
                options[:team_id] = tid
            end
            opts.on("-u", "--username [USER]", String, "ESPN username") do |user|
                options[:username] = user
            end
            opts.on("-p", "--password [PASSWORD]", String, "ESPN password") do |pass|
                options[:password] = pass
            end
            opts.on("-y", "--year", String, "Year in which a season was played") do |year|
                options[:year] = year
            end
            # opts.on("-c", "--command [COMMAND]", String, "Command to run FFRobot with") do |cmd|
            #     options[:command] = cmd
            # end
            opts.on("-h", "--help", "Prints out usage options") do 
                puts opts
                exit
            end
        end.parse!

        @league_id = options[:league_id]
        @team_id = options[:team_id] || nil
        @username = options[:username]
        @password = options[:password]
        @year = options[:year] || Time.new.year
        @command = options[:command]

      end

      def exec_command
        if @command == 'set_lineup'
            set_lineup
        else
            puts "Invalid command.\nPlease try again with a valid command."
        end
      end
    end

    client = Client.new
    client.authenticate
    # client.exec_command
end
  