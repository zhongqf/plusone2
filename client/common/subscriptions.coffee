Deps.autorun ->
  Meteor.subscribe 'tasks', Session.get('currentProjectId')
  Meteor.subscribe 'tasklists', Session.get('currentProjectId')
  Meteor.subscribe 'members', Session.get('currentProjectId')
  Meteor.subscribe 'comments', Session.get('currentProjectId')
  Meteor.subscribe 'taskActivity', Session.get('currentTaskId')
  Meteor.subscribe 'discussions', Session.get('currentProjectId')

Meteor.subscribe 'projects'
Meteor.subscribe 'allUsers'
