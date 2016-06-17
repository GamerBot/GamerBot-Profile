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
# Author:
#   Shawn Sorichetti <ssoriche@gmail.com>

module.exports = (robot) ->
  attributes = {
    "realname", "twitter", "email", "battlenet"
  }

  getProfile = (nick) ->
    profile = ""

    for attribute in Object.keys(attributes)
      if robot.brain.get "profile.#{nick}.#{attribute}"
        profile += "#{attribute} - "
        profile += robot.brain.get "profile.#{nick}.#{attribute}"
        profile += "\n"

    return profile

  robot.on "profile.register", (attribute) ->
    attributes[attribute] = attribute

  robot.hear /^[\.!]me set (\w+)\s+(.*)$/i, (msg) ->
    nick = msg.message.user.name.toLowerCase()
    [ __, attribute, value ] = msg.match

    if attributes[attribute]
      robot.brain.set "profile.#{nick}.#{attribute}", value
      msg.send "Setting your #{attribute} to #{value}"
    else
      msg.send "Invalid profile setting #{attribute}. Valid settings: " + Object.keys(attributes).join(", ")
    msg.finish()

  robot.hear /^[\.!]me unset (\w+)$/i, (msg) ->
    nick = msg.message.user.name.toLowerCase()
    [ __, attribute ] = msg.match

    if attributes[attribute]
      robot.brain.remove "profile.#{nick}.#{attribute}"
      msg.send "Removed your setting for #{attribute}."
    else
      msg.send "Invalid profile setting #{attribute}. Valid settings: " + Object.keys(attributes).join(", ")
    msg.finish()

  robot.hear /^[\.!]me get (\w+)$/i, (msg) ->
    nick = msg.message.user.name.toLowerCase()
    [ __, attribute ] = msg.match

    if attributes[attribute]
      if robot.brain.get "profile.#{nick}.#{attribute}"
        msg.send robot.brain.get "profile.#{nick}.#{attribute}"
    else
      msg.send "Invalid profile setting #{attribute}. Valid settings: " + Object.keys(attributes).join(", ")
    msg.finish()

  robot.hear /^[\.!]me profile$/i, (msg) ->
    nick = msg.message.user.name.toLowerCase()

    profile = getProfile nick

    if profile != ""
      msg.send "```" + profile + "```"
    msg.finish()

  robot.hear /^[\.!]me$/i, (msg) ->
    nick = msg.message.user.name.toLowerCase()

    profile = getProfile nick

    if profile != ""
      msg.send "```" + profile + "```"
    msg.finish()
