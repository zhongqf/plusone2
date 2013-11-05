requireLogin = ->
  if Meteor.loggingIn()
    @render("loading")
    @stop()
  else unless Meteor.user()
    @redirect("/login")

alreadyLoginForward = ->
  if Meteor.user()
    setDefaultProject()
    @redirect("/tasks")

setDefaultProject = ->
  avaiable_projects = Projects.find().fetch()
  if avaiable_projects.length > 0
    Session.set('currentProjectId', avaiable_projects[0]._id )

Router.configure
  layoutTemplate: 'layout',
  autoRender: false

Router.before requireLogin,
  except: ['login']

Router.before setDefaultProject,
  except: ['login']

Router.map ->
  @route 'root',
    path: '/'
    before: ->
      @redirect('/tasks')

  @route 'login',
    path: '/login'
    template: 'login'
    layoutTemplate: 'layout_none'
    after: alreadyLoginForward

  @route 'tasks',
    path: '/tasks'
    template: 'tasks'
    yieldTemplates:
      'nav_sub_projects': {to: 'nav'}

  @route 'me',
    path: '/me'
    template: 'tasks'
    yieldTemplates:
      'nav_sub_user': {to: 'nav'}

  @route 'discussion',
    path: '/discussion'
    template: 'discussions'
    yieldTemplates:
      'nav_sub_projects': {to: 'nav'}

