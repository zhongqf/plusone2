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
  notFoundTemplate: 'notFound',
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

  #Common Object
  @route 'discussion',
    path: '/discussion/:id'
    template: 'discussion'
    data: ->
      Discussions.findOne(this.params.id)

  @route 'task',
    path: '/task/:id'
    template: 'task'
    data: ->
      Tasks.findOne(this.params.id)

  #Me
  @route 'me',
    path: '/me'
    before: ->
      @redirect('/me/inbox')

  @route 'me_inbox',
    path: 'me/inbox'
    template: 'userInbox'
    yieldTemplates:
      'sidebarUser': {to: 'sidebar'}
    data: ->
      user: Meteor.user()

  @route 'me_profile',
    path: 'me/profile'
    template: 'userEditProfile'
    yieldTemplates:
      'sidebarUser': {to: 'sidebar'}
    data: ->
     user: Meteor.user()

  @route 'me_joined_teams',
    path: 'me/teams'
    template: "userJoinedTeams"
    yieldTemplates:
      'sidebarUser': {to: 'sidebar'}
    data: ->
      user: Meteor.user()

  @route 'me_notifications',
    path: 'me/notifications'
    template: 'userNotifications'
    yieldTemplates:
      'sidebarUser': {to: 'sidebar'}
    data: ->
      user: Meteor.user()

  @route 'me_items',
    path: 'me/items'
    template: 'userItems'
    yieldTemplates:
      'sidebarUser': {to: 'sidebar'}
    data: ->
      user: Meteor.user()

  @route 'me_activities',
    path: 'me/activities'
    template: 'userActivities'
    yieldTemplates:
      'sidebarUser': {to: 'sidebar'}
    data: ->
      user: Meteor.user()

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


  #User
  @route 'user_home',
    path: '/user/:username'
    before: ->
      user = Meteor.users.findOne({username: this.params.username})

      if isCurrentUser(user)
        @redirect("/me")
      else
        @redirect("/user/#{user.username}/activities")

  @route 'user_activities',
    path: '/user/:username/activities'
    template: 'userActivities'
    yieldTemplates:
      'sidebarUser': { to: 'sidebar' }
    data: ->
      user: Meteor.users.findOne({username: this.params.username})

  @route 'user_items',
    path: '/user/:username/items'
    template: 'userItems'
    yieldTemplates:
      'sidebarUser': { to: 'sidebar' }
    data: ->
      user: Meteor.users.findOne({username: this.params.username})

  @route 'user_teams',
    path: '/user/:username/teams'
    template: 'userJoinedTeams'
    yieldTemplates:
      'sidebarUser': { to: 'sidebar' }
    data: ->
      user: Meteor.users.findOne({username: this.params.username})
