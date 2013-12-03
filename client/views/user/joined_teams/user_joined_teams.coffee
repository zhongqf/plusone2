Template.userJoinedTeams.teams = ->
  user = this.user ? Meteor.user()
  Teams.find({memberIds: user._id})
