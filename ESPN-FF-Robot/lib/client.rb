module FFRobot
    class Client
      require 'httparty'
      require 'optparse'
  
    #   include Authentication
      include HTTParty
      base_uri 'https://fantasy.espn.com/'
  
    #   include Objects::Lineup
    #   include Objects::Players
  
      attr_accessor :league_id, :team_id, :username, :password, :swid, :espn_s2
  
      def initialize 
        options = {}

        OptionParser.new do |opts|
            opts.banner = "Usage: ruby authentication.rb [options]"
            opts.on("-l", "--leagueid [LEAGUEID]", String, "Fantasy league ID") do |lid|
                options[:league_id] = lid
            end
            opts.on("-t", "--teamid [TEAMID]", String, "Your fantasy team's ID within the same league") do |tid|
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
            opts.on("-s", "--swid", String, "Software ID tag for your browser's ESPN site cookie") do |swid|
                options[:swid] = swid
            end
            opts.on("-e", "--espns2", String, "Personal ESPN site cookie") do |espns2|
                options[:espn_s2] = espns2
            end
            opts.on("-h", "--help", "Prints out usage options") do 
                puts opts
                exit
            end
        end.parse!

        @league_id = options[:league_id]
        @team_id = options[:team_id]
        @username = options[:username]
        @password = options[:password]

      end
    end

    Client.new
  end
  