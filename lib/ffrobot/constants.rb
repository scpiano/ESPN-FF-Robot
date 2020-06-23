module FFRobot
    module Constants
        ESPN_FF_URI = 'https://fantasy.espn.com/apis/v3/games/'
        API_KEY_URL = 'https://registerdisney.go.com/jgc/v5/client/ESPN-FANTASYLM-PROD/api-key?langPref=en-US'
        LOGIN_URL = 'https://ha.registerdisney.go.com/jgc/v5/client/ESPN-FANTASYLM-PROD/guest/login?langPref=en-US'
        STANDARD_LINEUP = [0,2,2,4,4,6,16,17,23]
        
        POSITION_MAP = {
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
        NFL_TEAM_ABBREV = {
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
    end
end