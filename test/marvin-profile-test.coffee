Helper = require 'hubot-test-helper'
helper = new Helper('../src/marvin-profile.coffee')

expect = require('chai').expect

describe 'marvin-profile', ->
  beforeEach ->
    @room = helper.createRoom(httpd: false)

  it 'set twitter handle', ->
    @room.user.say('bob','.me set twitter bobshadey').then =>
      expect(@room.messages).to.eql [
        [ "bob",".me set twitter bobshadey" ]
        [ "hubot", "Setting your twitter to bobshadey" ]
      ]

