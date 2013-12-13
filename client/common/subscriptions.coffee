Deps.autorun ->
  Meteor.subscribe 'teamTasks', Session.get('currentTeamId')
  Meteor.subscribe 'teamTasklists', Session.get('currentTeamId')
  Meteor.subscribe 'teamComments', Session.get('currentTeamId')
  Meteor.subscribe 'teamActivities', Session.get('currentTeamId')
  Meteor.subscribe 'teamDiscussions', Session.get('currentTeamId')

Meteor.subscribe 'allUsers'
Meteor.subscribe 'teams'

Meteor.subscribe 'userDiscussions'
Meteor.subscribe 'userTasks'

