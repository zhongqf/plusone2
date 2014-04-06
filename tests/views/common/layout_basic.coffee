Template.layoutBasicTopbar.activeTeams = ->
  return [] unless Meteor.user()
  return Teams.find({memberIds: Meteor.userId()}, {limit: 5})

Template.layoutBasicTopbar.events
  'click .pjs-logout': (event)->
    event.preventDefault()
    Meteor.logout()