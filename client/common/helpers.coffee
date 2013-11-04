global = exports ? this

global.userDisplayName = (user)->
  user = if (typeof user is "string") then  Meteor.users.findOne({_id: user}) else user

  if user
    return (user.profile && user.profile.name) || user.username || (user.emails && user.emails[0] && user.emails[0].address) || "Noname User"
  return "Invalid User"

global.shortDateofTimestamp = (timestamp)->
  return moment.unix(timestamp/1000).calendar()


Handlebars.registerHelper "userDisplayName", (user)->
  return global.userDisplayName(user)

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
