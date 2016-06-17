Helper = require 'hubot-test-helper'
helper = new Helper('../src/marvin-profile.coffee')

expect = require('chai').expect

describe 'marvin-profile', ->
  beforeEach ->
    @room = helper.createRoom(httpd: false)

  it 'registers a new profile item', ->
    @room.robot.emit 'profile.register', 'test'
    @room.user.say('bob','.me get notexist').then =>
      expect(@room.messages).to.eql [
        [ "bob",".me get notexist" ]
        [ "hubot",
          "Invalid profile setting notexist. Valid settings: realname, twitter, email, battlenet, test"
        ]
      ]
    @room.user.say('bob','.me set test done').then =>
      expect(@room.messages).to.eql [
        [ "bob",".me get notexist" ]
        [ "bob",".me set test done" ]
        [ "hubot", "Setting your test to done" ]
        [ "hubot",
          "Invalid profile setting notexist. Valid settings: realname, twitter, email, battlenet, test"
        ]
      ]

  it 'set twitter handle', ->
    @room.user.say('bob','.me set twitter bobshadey').then =>
      expect(@room.messages).to.eql [
        [ "bob",".me set twitter bobshadey" ]
        [ "hubot", "Setting your twitter to bobshadey" ]
      ]

