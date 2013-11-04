Template.discussion_detail.discussion = ->
  return Discussions.findOne Session.get('currentDiscussionId')


