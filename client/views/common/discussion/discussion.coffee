Template.discussion.comments = ->
  Comments.find({objectId: this._id}, {sort: {createdAt: 1}})