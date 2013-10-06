@Activities = new Meteor.Collection("activities")

logTaskActivity = (action, taskId, user, actionObject)->

  task = Tasks.findOne(taskId)

  unless action && task
    throw new Meteor.Error(500, "Internal Error.");

  user = user ? user : task.creatorId

  Activities.insert
    userId: user,
    objectId: task._id,
    objectType: "Task",
    projectId: task.projectId,
    action: action,
    timestamp: new Date().getTime(),
    actionObject: actionObject
