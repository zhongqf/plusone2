Deps.autorun ->
  Meteor.subscribe 'tasks', Session.get('currentProjectId')
  Meteor.subscribe 'tasklists', Session.get('currentProjectId')
  Meteor.subscribe 'members', Session.get('currentProjectId')
  Meteor.subscribe 'comments', Session.get('currentTaskId')

Meteor.subscribe 'projects'
Meteor.subscribe 'allUsers'
