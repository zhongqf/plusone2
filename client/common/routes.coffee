#tasks = (id)->
#  avaiable_projects = Projects.find().fetch()
#
#  if avaiable_projects.length > 0
#    Session.set('currentProjectId', avaiable_projects[0]._id )
#
#  return 'tasks'
#
#Meteor.Router.add
#  '/': tasks
#  '/login': 'login'
#  '/tasks': tasks
#  '/tasks/design': 'tasks_design'
#
#
#Meteor.Router.filters
#  requireLogin: (page)->
#    if Meteor.loggingIn()
#      return 'loading'
#    else if Meteor.user()
#      return page
#    else
#      return 'login'
#
#  alreadyLoginForward: (page)->
#    if Meteor.user() and page == 'login'
#      Meteor.Router.to("/tasks")
#      return "tasks"
#    else
#      return page
#
#
#
#Meteor.Router.filter 'requireLogin'
#Meteor.Router.filter 'alreadyLoginForward'

requireLogin = ->
  if Meteor.loggingIn()
    this.template("loading")
    this.stop()
  else unless Meteor.user()
    this.redirect("/login")
    this.stop()

alreadyLoginForward = ->
  if Meteor.user()
    setDefaultProject()
    this.redirect("/tasks")

setDefaultProject = ->
  avaiable_projects = Projects.find().fetch()
  if avaiable_projects.length > 0
    Session.set('currentProjectId', avaiable_projects[0]._id )

Meteor.pages
  '/':
    to: 'tasks', before: [requireLogin, alreadyLoginForward]
  '/login':
    to:  'login', before: alreadyLoginForward, layout: "layout_none"
  '/tasks':
    to: 'tasks', before: [requireLogin, setDefaultProject]




