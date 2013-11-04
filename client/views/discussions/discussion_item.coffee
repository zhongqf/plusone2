Template.discussion_item.lastComments = ->
  return Comments.find({_id: {$in: this.lastCommentIds}}, {sort: {timestamp: 1 }})

Template.discussion_item.allCommentsCount = ->
  return Comments.find({objectId: this._id}).count()

Template.discussion_item.displayAllCommentsLink = ->
  return Comments.find({objectId: this._id}).count() > 3

Template.discussion_item.hasComments = ->
  return Comments.find({objectId: this._id}).count() > 0

Template.discussion_item.isActive =->
  return (Session.get('currentDiscussionId') == this._id)

Template.discussion_item.events
  'click .panel': (event, templ)->
    Session.set('currentDiscussionId', event.currentTarget.getAttribute("id") )
