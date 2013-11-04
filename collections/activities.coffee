global = exports ? this
@Activities = new Meteor.Collection("activities")

global.logTaskActivity = (action, taskId, user, actionObject)->

  task = Tasks.findOne(taskId)

  unless action && task
    throw new Meteor.Error(500, "Internal Error.")

  user =  if user && ("_id" of user) then user._id else user
  user ?= task.creatorId

  lastActivity = Activities.find({objectId: taskId}, {sort: {timestamp: -1}, limit: 1}).fetch()[0]

  if action in ["changeTask", "addTaskTag", "removeTaskTag"] and lastActivity and (user == lastActivity.userId)

    if (lastActivity.action == action) && (action in ["addTaskTag","removeTaskTag"])
      lastTag = lastActivity.actionObject
      lastTag = if _.isArray(lastTag) then lastTag else [lastTag]
      lastTag.push actionObject

      return Activities.update
        _id: lastActivity._id,
          $set:
            actionObject: lastTag

    if lastActivity and (lastActivity.action == action == "changeTask") and
        (_.keys(lastActivity.actionObject.after)[0] == _.keys(actionObject.after)[0])

      key = _.keys(actionObject.after)[0]

      if key not in ["done", "assigneeId"]
        return Activities.update
          _id: lastActivity._id,
            $set:
              actionObject: actionObject

      if key == "done" && not actionObject.after.done
        return Activities.remove
          _id: lastActivity._id


  return Activities.insert
    userId: user,
    objectId: task._id,
    objectType: "Task",
    projectId: task.projectId,
    action: action,
    timestamp: new Date().getTime(),
    actionObject: actionObject



