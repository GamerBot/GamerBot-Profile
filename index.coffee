Profile = require './src/Profile'
fs = require 'fs'
path = require 'path'

module.exports = (robot, scripts) ->
  scriptsPath = path.resolve(__dirname, 'src')
  robot.loadFile(scriptsPath, 'GamerBot-Profile.coffee')
  return new Profile robot

