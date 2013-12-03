requireLogin = ->
  if Meteor.loggingIn()
    @render("loading")
    @stop()
  else unless Meteor.user()
    @redirect("/login")

alreadyLoginForward = ->
  if Meteor.user()
    setDefaultTeam()
    @redirect("/me")

#setDefaultProject = ->
#  avaiable_projects = Projects.find().fetch()
#  if avaiable_projects.length > 0
#    Session.set('currentProjectId', avaiable_projects[0]._id )

setDefaultTeam = ->
  team = Teams.findOne({memberIds: Meteor.userId()})
  Session.set("currentTeamId", team._id) if team

Router.configure
  layoutTemplate: 'layoutBasic',
  autoRender: false

Router.before requireLogin,
  except: ['login']

Router.before setDefaultTeam,
  except: ['login']

Router.map ->
  @route 'root',
    path: '/'
    before: ->
      @redirect('/me')

  @route 'login',
    path: '/login'
    template: 'login'
    layoutTemplate: 'layoutNone'
    after: alreadyLoginForward

  #User
  @route 'me',
    path: '/me'
    before: ->
      @redirect('/me/inbox')

  @route 'user_inbox',
    path: 'me/inbox'
    template: 'userInbox'
    yieldTemplates:
      'sidebarUser': {to: 'sidebar'}

  @route 'user_joined_teams',
    path: 'me/teams'
    template: "userJoinedTeams"
    yieldTemplates:
      'sidebarUser': {to: 'sidebar'}

  @route 'user_notifications',
    path: 'me/notifications'
    template: 'userNotifications'
    yieldTemplates:
      'sidebarUser': {to: 'sidebar'}

  @route 'user_items',
    path: 'me/items'
    template: 'userItems'
    yieldTemplates:
      'sidebarUser': {to: 'sidebar'}

  @route 'user_activities',
    path: 'me/activities'
    template: 'userActivities'
    yieldTemplates:
      'sidebarUser': {to: 'sidebar'}

  #Teams
  @route 'team_home',
    path: 'team/:slug'
    before: ->
      team = Teams.findOne({slug: this.params.slug})
      @redirect("/team/#{team.slug}/activities")

  @route 'team_activities',
    path: 'team/:slug/activities'
    template: 'teamActivities'
    yieldTemplates:
      'sidebarTeam': {to: 'sidebar'}
    before: ->
      team = Teams.findOne({slug: this.params.slug})
      Session.set("currentTeamId", team._id) if team

  @route 'team_discussions',
    path: '/team/:slug/discussions'
    template: 'teamDiscussions'
    yieldTemplates:
      'sidebarTeam': {to: 'sidebar'}
    before: ->
      team = Teams.findOne({slug: this.params.slug})
      Session.set("currentTeamId", team._id) if team

  @route 'team_documents',
    path: '/team/:slug/documents'
    template: 'teamDocuments'
    yieldTemplates:
      'sidebarTeam': {to: 'sidebar'}
    before: ->
      team = Teams.findOne({slug: this.params.slug})
      Session.set("currentTeamId", team._id) if team

  @route 'team_events',
    path: '/team/:slug/events'
    template: 'teamEvents'
    yieldTemplates:
      'sidebarTeam': {to: 'sidebar'}
    before: ->
      team = Teams.findOne({slug: this.params.slug})
      Session.set("currentTeamId", team._id) if team

  @route 'team_tasks',
    path: '/team/:slug/tasks'
    template: 'teamTasks'
    yieldTemplates:
      'sidebarTeam': {to: 'sidebar'}
    before: ->
      team = Teams.findOne({slug: this.params.slug})
      Session.set("currentTeamId", team._id) if team

  @route 'team_files',
    path: '/team/:slug/files'
    template: 'teamFiles'
    yieldTemplates:
      'sidebarTeam': {to: 'sidebar'}
    before: ->
      team = Teams.findOne({slug: this.params.slug})
      Session.set("currentTeamId", team._id) if team




  #Explorer
  @route 'explorer_home',
    path: '/explorer'
    before: ->
      @redirect('/explorer/teams')

  @route 'explorer_all_teams',
    path: '/explorer/teams'
    template: 'explorerTeams'
    yieldTemplates:
      'sidebarExplorer':  { to: 'sidebar' }

  @route 'explorer_employees',
    path: '/explorer/employees'
    template: 'explorerEmployees'
    yieldTemplates:
      'sidebarExplorer': { to: 'sidebar' }