# Description
#   Profile class for managing profile details
#
# Author:
#   Shawn Sorichetti <ssoriche@gmail.com>

class Profile

  constructor: (@robot) ->
    @attributes = {
      "realname", "twitter", "email", "battlenet"
    }
    @load_attributes()

  save_attributes: ->
    @robot.brain.set "profile.attributes", @attributes

  load_attributes: ->
    @save_attributes() unless (@robot.brain.get "profile.attributes")

    attributes=@robot.brain.get "profile.attributes" ? {}
    for attribute in Object.keys(attributes)
      @attributes[attribute]=attribute

  add_attribute: (attribute) ->
    @load_attributes()
    @attributes[attribute]=attribute
    @robot.brain.set "profile.attributes", @attributes
    @save_attributes()

  valid_attribute: (attribute) ->
    return if @attributes[attribute] then true else false

  getProfile: (nick) ->
    profile = ""

    for attribute in Object.keys(@attributes)
      if robot.brain.get "profile.#{nick}.#{attribute}"
        profile += "#{attribute} - "
        profile += robot.brain.get "profile.#{nick}.#{attribute}"
        profile += "\n"

    return profile

  check_platform: (nick, platform) ->
    nick = nick.toLowerCase()
    platforms = @robot.brain.get "profile.#{nick}.platforms"
    platform = platform.toUpperCase()

    if platforms[platform] then true else false

  add_attribute: (attribute) ->
    @attributes[attribute] = attribute
    @save_attributes()

  set_attribute: (nick, attribute, value) ->
    if @attributes[attribute]
      @robot.brain.set "profile.#{nick}.#{attribute}", value
      return true
    else
      return false

  unset_attribute: (nick, attribute) ->
    if @attributes[attribute]
      @robot.brain.remove "profile.#{nick}.#{attribute}"
      return true
    else
      return false

  get_attribute: (nick, attribute) ->
    if @attributes[attribute]
      return @robot.brain.get "profile.#{nick}.#{attribute}"
    else
      return false

  add_platform: (nick, platform, id) ->
    platforms = @robot.brain.get "profile.#{nick}.platforms"
    platform = platform.toUpperCase()

    platforms = platforms ? {}

    platforms[platform] = if id then id else platform
    @robot.brain.set "profile.#{nick}.platforms", platforms
    return true

  rm_platform: (nick, platform) ->
    platforms = @robot.brain.get "profile.#{nick}.platforms"
    platform = platform.toUpperCase()

    platforms = platforms ? {}
    delete platforms[platform]
    @robot.brain.set "profile.#{nick}.platforms", platforms
    return true

  get_platforms: (nick) ->
    platform_list = @robot.brain.get "profile.#{nick}.platforms"
    platform_list = if platform_list then platform_list else {}

    return platform_list

module.exports = Profile
