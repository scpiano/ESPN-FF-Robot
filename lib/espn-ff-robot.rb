require 'fileutils'
require 'httparty'
require 'json'
require 'logger'
require 'optparse'
require 'time'

require './ffrobot/authentication'
require './ffrobot/constants'
require './ffrobot/error'
require './ffrobot/helpers'
require './ffrobot/lineup'

require './ffrobot/objects/league'
require './ffrobot/objects/player'
require './ffrobot/objects/team'

require './ffrobot/client'