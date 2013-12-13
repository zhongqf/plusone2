#Users
Meteor.publish "allUsers", ->
  return Meteor.users.find {},
    fields:
      username: 1
      emails: 1
      profile: 1

#Teams
Meteor.publish "teams", ->
  conditions = {public: true}
  if this.userId
    conditions = {$or: [{memberIds: this.userId}, conditions]}
  return Teams.find(conditions)

#Team Objects
Meteor.publish "teamTasks", (teamId)->
  return Tasks.find({teamId: teamId})

Meteor.publish "teamTasklists", (teamId)->
  return Tasklists.find({teamId: teamId})

Meteor.publish "teamDiscussions", (teamId)->
  return Discussions.find({teamId: teamId})

Meteor.publish "teamComments", (teamId)->
  return Comments.find({teamId: teamId})

Meteor.publish "teamActivities", (teamId)->
  return Activities.find({teamId: teamId})


Meteor.publish "userDiscussions", ->
  discussions = Discussions.find({userId: this.userId})
  ids = _.map discussions.fetch(), (d)-> d._id

  return [
    discussions,
    Comments.find({objectId: {$in: ids}})
  ]

Meteor.publish "userTasks", ->
  tasks = Tasks.find({userId: this.userId})
  ids = _.map tasks.fetch(), (t)-> t._id

  return [
    tasks,
    Comments.find({objectId: {$in: ids}})
  ]

#User Objects