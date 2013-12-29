global = exports ? this

@Discussions = new Meteor.Collection("discussions")

Meteor.methods

  createDiscussion: (teamId, discussionInfo)->
    check(discussionInfo, {
      title: global.stringPresentMatcher
      text: Match.Optional(String)
    })
    user = global.authenticatedUser()
    team = Teams.findOne(teamId)

    if user && team
      discussionId = Discussions.insert
        teamId: team._id
        title: discussionInfo.title
        text: discussionInfo.text
        userId: user._id
        createdAt: new Date().getTime()
        updatedAt: new Date().getTime()
        commentsCount: 0

      return discussionId

