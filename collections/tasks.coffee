global = exports ? this

@Tasks = new Meteor.Collection("tasks")

Meteor.methods

  commentTask: (taskId, commentInfo)->
    check(commentInfo, {
      text: global.stringPresentMatcher
    })

    task= Tasks.findOne(taskId)
    teamId = task.teamId

    return global.commentIt(teamId, taskId, commentInfo.text)

  #newTask: (tasklistId)->
  #  user = global.authenticatedUser()
  #  tasklist = Tasklists.findOne(tasklistId)

  #  if user && tasklist
  #    taskId = Tasks.insert
  #      projectId: tasklist.projectId
  #      tasklistId: tasklistId
  #      timestamp: new Date().getTime()
  #      creatorId: user._id

  #    global.logTaskActivity('newTask', taskId)
  #    return taskId

  #createTask: (taskAttrs)->

  #  user = global.authenticatedUser()

  #  task = _.extend(_.pick(taskAttrs, 'projectId', 'tasklistId', 'text'), {
  #    creatorId: user._id,
  #    timestamp: new Date().getTime()
  #  })

  #  taskId = Tasks.insert(task)

  #  global.logTaskActivity('createTask', taskId)
  #  return taskId

  #updateTask: (taskId, taskAttrs)->
  #  user = global.authenticatedUser()

  #  whitelist = ['tasklistId','done','text','dueAt','assigneeId','description']
  #  searchCondition = _.chain(whitelist).map(
  #    (o)-> return [o,1]
  #  ).object().value()

  #  oldValue = Tasks.findOne(taskId, searchCondition)
  #  newValue = _.pick(taskAttrs, whitelist)

  #  actionObject = global.buildChangeObject(oldValue, newValue)

  #  if(actionObject.before != actionObject.after)
  #    Tasks.update({_id: taskId}, {$set: newValue})
  #    global.logTaskActivity('changeTask', taskId, user, actionObject)


  #addTaskTag: (taskId, tag) ->
  #  user = global.authenticatedUser()

  #  if tag
  #    Tasks.update({_id: taskId}, {$push: {tags: tag}})
  #    global.logTaskActivity('addTaskTag', taskId, user, tag)

  #removeTaskTag: (taskId, tag) ->
  #  user = global.authenticatedUser()

  #  if tag
  #    Tasks.update({_id: taskId}, {$pull: {tags: tag}})
  #    global.logTaskActivity('removeTaskTag', taskId, user, tag)


  #commentTask: (taskId, commentBody) ->
  #  user = global.authenticatedUser()
  #  task = Tasks.findOne taskId

  #  commentId = global.commentIt(task.projectId, taskId, commentBody)
  #  commentObject = _.clone(Comments.findOne(commentId))

  #  global.logTaskActivity("commentTask", taskId, user,commentObject)
#Uploads = new CollectionFS("uploads")