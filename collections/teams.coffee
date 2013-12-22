global = exports ? this

@Teams = new Meteor.Collection("teams")

Meteor.methods
  quitTeam: (teamId)->
    user = global.authenticatedUser()
    Teams.update
      _id: teamId,
        $pull:
          memberIds: user._id

  joinTeam: (teamId)->
    user = global.authenticatedUser()
    Teams.update
      _id: teamId,
        $push:
          memberIds: user._id
