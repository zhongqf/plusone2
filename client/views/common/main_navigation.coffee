Template.main_navigation.projects = ->
  Projects.find({}, {sort:{timestamp:-1}})

Template.main_navigation.events
  'click #logout': (event, templ)->
    Meteor.logout()
    