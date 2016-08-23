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

class Profile
  save_attributes: ->
    @robot.brain.set "profile.attributes", @attributes

  load_attributes: ->
    @save_attributes() unless (@robot.brain.get "profile.attributes")

    attributes=@robot.brain.get "profile.attributes"
    for attribute in Object.keys(attributes)
      @attributes[attribute]=attribute

  add_attribute: (attribute) ->
    @load_attributes()
    @attributes[attribute]=attribute
    @robot.brain.set "profile.attributes", @attributes
    @save_attributes()

  getProfile: (nick) ->
    profile = ""

    for attribute in Object.keys(@attributes)
      if robot.brain.get "profile.#{nick}.#{attribute}"
        profile += "#{attribute} - "
        profile += robot.brain.get "profile.#{nick}.#{attribute}"
        profile += "\n"

    return profile

  constructor: (@robot) ->
    @attributes = {
      "realname", "twitter", "email", "battlenet"
    }

    @load_attributes()

    @robot.on "profile.register", (attribute) =>
      @attributes[attribute] = attribute
      @save_attributes()

    @robot.hear /^[\.!]me set (\w+)\s+(.*)$/i, (msg) =>
      nick = msg.message.user.name.toLowerCase()
      [ __, attribute, value ] = msg.match

      if @attributes[attribute]
        @robot.brain.set "profile.#{nick}.#{attribute}", value
        msg.send "Setting your #{attribute} to #{value}"
      else
        msg.send "Invalid profile setting #{attribute}. Valid settings: " + Object.keys(attributes).join(", ")
      msg.finish()

    @robot.hear /^[\.!]me unset (\w+)$/i, (msg) =>
      nick = msg.message.user.name.toLowerCase()
      [ __, attribute ] = msg.match

      if attributes[attribute]
        @robot.brain.remove "profile.#{nick}.#{attribute}"
        msg.send "Removed your setting for #{attribute}."
      else
        msg.send "Invalid profile setting #{attribute}. Valid settings: " + Object.keys(@attributes).join(", ")
      msg.finish()

    @robot.hear /^[\.!]me get (\w+)$/i, (msg) =>
      nick = msg.message.user.name.toLowerCase()
      [ __, attribute ] = msg.match

      if @attributes[attribute]
        if @robot.brain.get "profile.#{nick}.#{attribute}"
          msg.send @robot.brain.get "profile.#{nick}.#{attribute}"
      else
        msg.send "Invalid profile setting #{attribute}. Valid settings: " + Object.keys(@attributes).join(", ")
      msg.finish()

    @robot.hear /^[\.!]me profile$/i, (msg) =>
      nick = msg.message.user.name.toLowerCase()

      profile = getProfile nick

      if profile != ""
        msg.send "```" + profile + "```"
      msg.finish()

    @robot.hear /^[\.!]me plat(?:forms?)?\s+(add|re?m(?:ove)?)\s+(\w+)(?:\s+as)?(?:\s+(\w+))?$/i, (msg) =>
      nick = msg.message.user.name.toLowerCase()
      [ __, cmd, platform, id ] = msg.match

      platforms = @robot.brain.get "profile.#{nick}.platforms"
      platform = platform.toUpperCase()

      if !platforms
        platforms = {}

      if cmd == 'add'
        platforms[platform] = if id then id else platform
        @robot.brain.set "profile.#{nick}.platforms", platforms
        msg.send "#{platform} added to your platforms"
      else if cmd = /re?m(?:ove)?/i
        delete platforms[platform]
        @robot.brain.set "profile.#{nick}.platforms", platforms
        msg.send "#{platform} removed from your platforms"

    @robot.hear /^[\.!]me plat(?:forms?)?$/i, (msg) ->
      nick = msg.message.user.name.toLowerCase()
      platform_list = @robot.brain.get "profile.#{nick}.platforms"
      platform_list = if platform_list then platform_list else {}
      platforms = ""

      for platform in Object.keys(platform_list)
        if platform_list[platform] == platform
          platforms += "#{platform}\n"
        else
          platforms += "#{platform} ... #{platform_list[platform]}\n"

      if platforms.length > 0
        msg.send "```Platforms:\n#{platforms}```"
      else
        msg.send "No added platforms"

    @robot.hear /^[\.!]me$/i, (msg) ->
      nick = msg.message.user.name.toLowerCase()

      profile = getProfile nick

      if profile != ""
        msg.send "```" + profile + "```"
      msg.finish()

module.exports = (robot) ->
  profile = new Profile robot
