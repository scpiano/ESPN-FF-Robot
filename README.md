# ESPN-FF-Robot
I forgot to set my fantasy lineup one too many times - so I made this! Automatically sets lineups (along with many other things hopefully) in fantasy football on ESPN.
## Process
A lot of this was only possible by looking at the great work others have done on Github on documenting the ESPN fantasy API. 

Aside from a lot of the simpler calls that are done in those repositories, I utilized Fiddler and Charles in order to get the requests needed in order to actually set the lineups.

The logic I use behind actually setting the lineups is pretty simple - I use the projections that ESPN uses as a base, then an amalgamation of both those projections and industry-wide fantasy projections in order to set the final lineups per week (the other projections outside of ESPN I use in my local branch, rather not share the logic on the web).
## Usage
Simply `git clone` the repository, cd into the `lib` folder and run like this (without a config file):

    ruby espn-ff-robot.rb -l <league_id> -t <team_id> -u <username> -p <password> -y <year> -s <swid> -e <espn_s2> -c <command> --logfile <path_to_logfile>

To run with a config file (example is located within this repo), run like this:

    ruby espn-ff-robot.rb -c <command> --config <path_to_config_file>

I've also included a sample Dockerfile to run the bot with. I use a similar file to run the bot locally on my machine, with it running every 30 minutes or so according to a cron. The commands I use to get it set up are as such:

    docker build -t espn-ff-robot:latest .
    docker run -v /var/log:/var/log -it -d espn-ff-robot

## Options
The options you can run the robot with:
- **REQUIRED** l/leagueid - Your fantasy league's ID, required unless using config file.
- **OPTIONAL** t/teamid - Your team id in the league.
- **REQUIRED** u/username - Your username for ESPN, required unless using config file.
- **REQUIRED** p/password - The password associated with your username, required unless using config file.
- **OPTIONAL** y/year - Year for league's season you are interested in, defaults to the current year.
- **OPTIONAL** s/swid - The software identification tag associated with your username if you already have it. A new one will be retrieved if this is not given.
- **OPTIONAL** e/espn_s2 - The ESPN S2 token associated with your account. A new one will be retrieved if this is not given.
- **REQUIRED** c/command - Command to run the robot with - valid commands are listed in the next section.
- **REQUIRED** --config - Path to config file, required unless using other CLI options.
- **OPTIONAL** --logfile - Path to log file, defaults to `../log/espn-ff-robot.log`.

## Commands
The available commands you can run the robot with:
- set_lineup
    - Will automatically set starting lineup for you, replacing starting players if they are injured with a higher scoring bench player, or just replacing starting players with a bench player if the bench player is projected to score more for the week.