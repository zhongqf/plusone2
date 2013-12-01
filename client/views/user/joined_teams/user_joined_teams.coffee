Template.userJoinedTeams.teams = ->
  Teams.find({memberIds: Meteor.userId()})