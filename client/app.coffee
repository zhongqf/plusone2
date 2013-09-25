Meteor.Router.add
  '/': 'tasks'
  '/login': 'login'
  '/tasks': 'tasks'
  '/tasks/design': 'tasks_design'


Meteor.Router.filters
  requireLogin: (page)->
    if Meteor.loggingIn()
      return 'loading'
    else if Meteor.user()
      if page == 'login'
        Meteor.Router.to("/tasks")
        return "tasks"
      return page
    else
      #Meteor.Router.to("/login")
      return 'login'

Meteor.Router.filter 'requireLogin'
