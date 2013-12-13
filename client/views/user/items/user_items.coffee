Template.userItems.discussions = ->
  user = this.user ? Meteor.user()
  Discussions.find({userId: user._id})

Template.userItems.tasks = ->
  user = this.user ? Meteor.user()
  Tasks.find({userId: user._id})