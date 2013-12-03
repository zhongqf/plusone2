global = exports ? this

global.userDisplayName = (user, defaultName = "Unknown User")->
  user = user._id if user._id?
  user = Meteor.users.findOne({_id: user})
  return user?.profile?.name ? user?.username ? user?.emails?[0]?.address ? defaultName

global.userEmail = (userId) ->
  userId = userId._id if userId._id?
  user = Meteor.users.findOne({_id: userId})
  return user?.emails?[0]?.address

global.shortDateofTimestamp = (timestamp)->
  return moment.unix(timestamp/1000).calendar()

global.currentTeam = ->
  teamId = Session.get "currentTeamId"
  return Teams.findOne({_id: teamId}) if teamId

global.isCurrentUser = (user)->
  user = user._id if user._id?
  return Meteor.users.findOne({_id: user})._id == Meteor.userId()

Handlebars.registerHelper "userEmail", (user)->
  return global.userEmail(user)

Handlebars.registerHelper "currentTeam", ->
  return global.currentTeam()

Handlebars.registerHelper "userDisplayName", (user)->
  return global.userDisplayName(user)

Handlebars.registerHelper "currentUserDisplayName", ->
  return global.userDisplayName(Meteor.userId())

Handlebars.registerHelper "shortDateOfTimestamp", (timestamp)->
  return global.shortDateofTimestamp(timestamp)

Handlebars.registerHelper "fullDateOfTimestamp", (timestamp)->
  moment.unix(timestamp/1000).format('llll')

Handlebars.registerHelper "safeStandardTimestamp", (timestamp)->
  time = timestamp or new Date().getTime()
  return moment.unix(time/1000).format('YYYY-MM-DD')

Handlebars.registerHelper "isCurrentUser", (user)->
  return global.isCurrentUser(user)


Handlebars.registerHelper "currentTask", ->
  return Tasks.findOne
    _id: Session.get("currentTaskId")
