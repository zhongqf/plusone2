updateLastComment = (collection, comment)->
  object = collection.findOne(comment.objectId)
  return unless object

  collection.update({_id: comment.objectId}, {$inc: {commentsCount: 1 }})

  unless object.lastCommentedAt and object.lastCommentedAt > comment.createdAt
    collection.update
      _id: comment.objectId,
        $set:
          lastCommentedAt: comment.createdAt
          lastCommentId: comment._id
          lastCommentUserId: comment.userId

Comments.find().observe
  added: (comment)->
    updateLastComment(Tasks, comment)
    updateLastComment(Discussions, comment)

  removed: (comment)->
    console.log("todo")

