global = exports ? this

global.userDisplayName = (userId, defaultName = "Unknown User")->
  userId = userId._id if userId._id?
  user = Meteor.users.findOne({_id: userId})
  return user?.profile?.name ? user?.username ? user?.emails?[0]?.address ? defaultName

global.shortDateofTimestamp = (timestamp)->
  return moment.unix(timestamp/1000).calendar()

global.currentTeam = ->
  teamId = Session.get "currentTeamId"
  return Teams.findOne({_id: teamId}) if teamId






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


Handlebars.registerHelper "currentTask", ->
  return Tasks.findOne
    _id: Session.get("currentTaskId")
