# Description
#   Store profile type information for a user
#
#   General purpose script to add Profile management for nicks
#
# Commands:
#   .me set realname Shawn Sorichetti - create a realname entry for the nick
#
#   .me profile - show entire profile
#   .me - show entire profile
#
#   .me profile realname - show only realname from  profile
#
#   .me platforms - list gaming platforms
#   .me platform add ps4 as psnid - add PS4 with PSN ID
#   .me platform remove ps4 - remove PS4 platform
#
# Author:
#   Shawn Sorichetti <ssoriche@gmail.com>

Profile = require './Profile.coffee'

module.exports = (robot) ->

  robot.on "profile.register", (attribute) =>
    profile = new Profile robot
    profile.add_attribute(attribute)

  robot.hear /^[\.!]me set (\w+)\s+(.*)$/i, (msg) =>
    nick = msg.message.user.name.toLowerCase()
    [ __, attribute, value ] = msg.match
    profile = new Profile robot

    if profile.set_attribute(nick, attribute, value)
      msg.send "Setting your #{attribute} to #{value}"
    else
      msg.send "Invalid profile setting #{attribute}. Valid settings: " + Object.keys(profile.attributes).join(", ")

  robot.hear /^[\.!]me unset (\w+)$/i, (msg) =>
    nick = msg.message.user.name.toLowerCase()
    [ __, attribute ] = msg.match
    profile = new Profile robot

    if profile.unset_attribute(nick, attribute)
      msg.send "Removed your setting for #{attribute}."
    else
      msg.send "Invalid profile setting #{attribute}. Valid settings: " + Object.keys(profile.attributes).join(", ")

  robot.hear /^[\.!]me get (\w+)$/i, (msg) =>
    nick = msg.message.user.name.toLowerCase()
    [ __, attribute ] = msg.match
    profile = new Profile robot

    if attribute && profile.valid_attribute(attribute)
      msg.send profile.get_attribute(nick, attribute)
    else
      msg.send "Invalid profile setting #{attribute}. Valid settings: " + Object.keys(profile.attributes).join(", ")
    msg.finish()

  robot.hear /^[\.!]me profile$/i, (msg) =>
    nick = msg.message.user.name.toLowerCase()
    profile = new Profile robot

    profile_value = profile.getProfile nick

    if profile_value != ""
      msg.send "```" + profile_value + "```"
    msg.finish()

  robot.hear /^[\.!]me plat(?:forms?)?\s+(add|re?m(?:ove)?)\s+(\w+)(?:\s+as)?(?:\s+(\w+))?$/i, (msg) =>
    nick = msg.message.user.name.toLowerCase()
    [ __, cmd, platform, id ] = msg.match
    profile = new Profile robot

    platform = platform.toUpperCase()

    if cmd == 'add'
      if profile.add_platform(nick, platform, id)
        msg.send "#{platform} added to your platforms"
    else if cmd = /re?m(?:ove)?/i
      if profile.rm_platform(nick, platform)
        msg.send "#{platform} removed from your platforms"

  robot.hear /^[\.!]me plat(?:forms?)?$/i, (msg) ->
    nick = msg.message.user.name.toLowerCase()
    profile = new Profile robot
    platform_list = profile.get_platforms(nick)
    platforms = ""

    for platform in Object.keys(platform_list)
      if platform_list[platform] == platform
        platforms+= "#{platform}\n"
      else
        platforms += "#{platform} ... #{platform_list[platform]}\n"

    if platforms.length > 0
      msg.send "```Platforms:\n#{platforms}```"
    else
      msg.send "No added platforms"

  robot.hear /^[\.!]me$/i, (msg) ->
    nick = msg.message.user.name.toLowerCase()
    profile = new Profile robot

    profile_value = profile.getProfile nick

    if profile != ""
      msg.send "```" + profile + "```"
    msg.finish()

