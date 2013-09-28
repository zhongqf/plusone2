Template.main_navigation.projects = ->
  return Projects.find({}, {sort:{timestamp:-1}})

Template.main_navigation.currentProject = ->
  return Projects.findOne(Session.get('currentProjectId'))

Template.main_navigation.events
  'click #logout': (event, templ)->
    event.preventDefault()
    Meteor.logout()

  'click #project-changer a': (event, templ)->
    event.preventDefault()
    projectId = event.currentTarget.getAttribute("data-po-key")
    Session.set('currentProjectId', projectId) if projectId
