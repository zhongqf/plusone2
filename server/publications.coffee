Meteor.publish "tasks", (projectId)->
  return Tasks.find({projectId: projectId})


Meteor.publish "tasklists", (projectId)->
  return Tasklists.find({projectId: projectId})


Meteor.publish "projects", ->
  conditions = {public: true}

  if this.userId
    memberships = Members.find({userId: this.userId}).fetch()
    visible_projects = _.map memberships, (m)->
      return m.projectId
    conditions = {$or: [{_id: {$in : visible_projects}}, conditions]}

  return Projects.find(conditions)


Meteor.publish "members", (projectId)->
  return Members.find({projectId: projectId})


Meteor.publish "comments", (objectId)->
  return Comments.find({objectId: objectId})

Meteor.publish "allUsers", ->
  return Meteor.users.find {},
    fields:
      username: 1
      emails: 1
      profile: 1

Meteor.publish "taskActivity", (taskId)->
  return Activities.find({objectId: taskId});
