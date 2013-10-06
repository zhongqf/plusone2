@Tasks = new Meteor.Collection("tasks")

Meteor.methods
  createTask: (taskAttrs)->

    user = authenticatedUser()

    task = _.extend(_.pick(taskAttrs, 'projectId', 'tasklistId', 'text'), {
      creatorId: user._id,
      timestamp: new Date().getTime()
    })

    taskId = Tasks.insert(task)

    logTaskActivity('createTask', taskId)
    return taskId

  updateTask: (taskId, taskAttrs)->
    user = authenticatedUser()

    whitelist = ['tasklistId','done','text','dueAt','assigneeId','tags','description']
    searchCondition = _.chain(whitelist).map(
      (o)-> return [o,1]
    ).object().value()

    oldValue = Tasks.findOne(taskId, searchCondition)
    newValue = _.pick(taskAttrs, whitelist)

    actionObject = buildChangeObject(oldValue, newValue)

    if(actionObject.before != actionObject.after)
      Tasks.update({_id: taskId}, {$set: newValue})
      logTaskActivity('changeTask', taskId, user, actionObject)


  commentTask: (taskId, commentBody) ->
    user = authenticatedUser()

    commentId = commentIt(taskId, commentBody)
    commentObject = _.clone(Comments.findOne(commentId))

    logTaskActivity("commentTask", taskId, user,commentObject)

#Uploads = new CollectionFS("uploads")