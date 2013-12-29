global = exports ? this

@Comments = new Meteor.Collection("comments")

#global.commentIt = (projectId, objectId, text)->
#
#  user = global.authenticatedUser()
#
#  commentId = Comments.insert
#    projectId: projectId,
#    objectId: objectId,
#    userId: user._id,
#    text: text,
#    timestamp: new Date().getTime()
#
#  return commentId
#

global.commentIt = (teamId, objectId, text)->

  user = global.authenticatedUser()
  commentId = Comments.insert
    teamId: teamId
    objectId: objectId
    userId: user._id
    text: text
    createdAt: new Date().getTime()

  return commentId
