module FFRobot
    class Client
        include FileUtils
        include HTTParty
        include JSON
        include Logger

        include Authentication
        include Constants
        include Helpers
        include Lineup
        
  
      attr_accessor :league_id, :team_id, :username, :password, :year, :swid, :espn_s2, :logger
  
      def initialize 
        options = {}

        OptionParser.new do |opts|
            opts.banner = "Usage: ruby espn-ff-robot.rb [options]"
            opts.on("-l", "--leagueid LEAGUEID", String, "Fantasy league ID") do |lid|
                options[:league_id] = lid
            end
            opts.on("-t", "--teamid TEAMID", Integer, "Your fantasy team's ID within the same league") do |tid|
                options[:team_id] = tid #TODO: will limit the teams in the league to only this team 
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
            opts.on("--config CONFIG", String, "Optional config file (use in place of other options, aside from command)") do |cnf|
                options[:config] = cnf
            end
            opts.on("-c", "--command COMMAND", String, "REQUIRED - Command to run FFRobot with") do |cmd|
                options[:command] = cmd
            end
            opts.on("--logfile LOGFILE", String, "Where to store logs") do |log|
                options[:logfile] = log
            end
            opts.on("-h", "--help", "Prints out usage options") do 
                puts opts
                exit
            end
        end.parse!
        
        raise OptionParser::MissingArgument if options[:command].nil? || [ options[:league_id], options[:config] ].all? { |x| x.nil? }

        conf = !options[:config].nil? ? JSON.parse(File.read(options[:config])) : {}

        @command = options[:command]
        @league_id = options[:league_id] || conf['league_id']
        @team_id = options[:team_id] || conf['team_id']
        @username = options[:username] || conf['username']
        @password = options[:password] || conf['password']
        @year = options[:year] || conf['year'] || Time.new.year
        @swid = options[:swid] || conf['swid']
        @espn_s2 = options[:espn_s2] || conf['espn_s2']
        logfile = options[:logfile] || conf['logfile'] || "../log/espn-ff-robot.log"

        FileUtils.mkdir_p(File.dirname(logfile))
        @logger = ::Logger.new(logfile, shift_age = 7, shift_size=1048576)
        # @logger = ::Logger.new(STDOUT)

        @logger.info("Powering up robot...")
      end

      def exec_command 
        if @command == 'set_lineup'
            league = Objects::League::League.new(self)
            set_lineup(league.teams[league.current_user_owner_id], league, @swid, @espn_s2, @logger)
        else
            @logger.info("Invalid command.\nPlease try again with one of the valid commands listed in the README.")
            raise OptionParser::InvalidOption 
        end
      end
    end

    client = Client.new

    if (client.swid.nil? || client.espn_s2.nil?) && (client.username && client.password)
        client.espn_s2, client.swid = client.authenticate(@logger)
    else 
        client.logger.info("Missing/invalid username and/or password. Please try again.")
        raise OptionParser::MissingArgument 
    end
    
    client.exec_command
end
  