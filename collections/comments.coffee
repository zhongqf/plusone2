@Comments = new Meteor.Collection("comments")


commentIt = (objectId, text)->

  user = authenticatedUser()

  commentId = Comments.insert
    objectId: objectId,
    userId: user._id,
    text: text,
    timestamp: new Date().getTime()

  return commentId
