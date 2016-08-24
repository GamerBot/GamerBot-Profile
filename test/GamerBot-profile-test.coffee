Helper = require 'hubot-test-helper'
helper = new Helper('../src/GamerBot-profile.coffee')

expect = require('chai').expect
Profile = require('../src/Profile.coffee')

describe 'GamerBot-profile', ->
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

  it 'sets platforms', ->
    @room.user.say('bob','.me plat add XBONE').then =>
      expect(@room.messages).to.eql [
        [ "bob",".me plat add XBONE" ]
        [ "hubot", "XBONE added to your platforms" ]
      ]
    @room.user.say('bob','.me platforms').then =>
      expect(@room.messages).to.eql [
        [ "bob",".me plat add XBONE" ]
        [ "bob",".me platforms" ]
        [ "hubot", "XBONE added to your platforms" ]
        [ "hubot", "```Platforms:\nXBONE\n```" ]
      ]

  it 'sets platforms w/ID', ->
    @room.user.say('bob','.me plat add XBONE as bobxbox').then =>
      expect(@room.messages).to.eql [
        [ "bob",".me plat add XBONE as bobxbox" ]
        [ "hubot", "XBONE added to your platforms" ]
      ]
    @room.user.say('bob','.me platforms').then =>
      expect(@room.messages).to.eql [
        [ "bob",".me plat add XBONE as bobxbox" ]
        [ "bob",".me platforms" ]
        [ "hubot", "XBONE added to your platforms" ]
        [ "hubot", "```Platforms:\nXBONE ... bobxbox\n```" ]
      ]

  it 'has no platforms', ->
    @room.user.say('bob','.me plat').then =>
      expect(@room.messages).to.eql [
        [ "bob",".me plat" ]
        [ "hubot", "No added platforms" ]
      ]

  it 'removes platforms', ->
    @room.user.say('bob','.me plat add XBONE as bobxbox').then =>
      expect(@room.messages).to.eql [
        [ "bob",".me plat add XBONE as bobxbox" ]
        [ "hubot", "XBONE added to your platforms" ]
      ]
    @room.user.say('bob','.me platforms rm XBONE').then =>
      expect(@room.messages).to.eql [
        [ "bob",".me plat add XBONE as bobxbox" ]
        [ "bob",".me platforms rm XBONE" ]
        [ "hubot", "XBONE added to your platforms" ]
        [ "hubot", "XBONE removed from your platforms" ]
      ]
  it 'checks platforms', ->
    @room.user.say('bob','.me plat add XBONE').then =>
      expect(@room.messages).to.eql [
        [ "bob",".me plat add XBONE" ]
        [ "hubot", "XBONE added to your platforms" ]
      ]
      profile = new Profile @room.robot
      expect(profile.check_platform('bob','xbone')).to.be.ok
      expect(profile.check_platform('bob','psn')).to.not.be.ok
