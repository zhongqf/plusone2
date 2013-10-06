Template.nav_sub_projects.projects = ->
  return Projects.find({}, {sort:{timestamp:-1}})

Template.nav_sub_projects.currentProject = ->
  return Projects.findOne(Session.get('currentProjectId'))

Template.nav_sub_projects.members = ->
  return Members.find()

Template.nav_sub_projects.events =
  'click .pojs-project-changer a': (event, templ)->
    event.preventDefault()
    projectId = event.currentTarget.getAttribute("data-po-key")
    Session.set('currentProjectId', projectId) if projectId
