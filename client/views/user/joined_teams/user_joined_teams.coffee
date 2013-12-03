Template.userJoinedTeams.teams = ->
  user = this.user ? Meteor.user()
  condition = {}

  if isCurrentUser(user)
    condition = {memberIds: user._id}
  else
    condition = {$and: [{memberIds: user._id}, {public: true}]}

  Teams.find(condition)
