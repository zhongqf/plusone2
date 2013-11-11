global = exports ? this

#Task detail
Template.task_detail.task = ->
  return Tasks.findOne Session.get("currentTaskId")

Template.task_detail.available_users = ->
  return Meteor.users.find()

Template.task_detail.assigned_user = ->
  task = Tasks.findOne({_id: Session.get("currentTaskId")});
  return Meteor.users.findOne(task.assigneeId)

Template.task_detail.editingTaskText = ->
  task = Tasks.findOne(Session.get("currentTaskId"));
  sed = Session.get("editingTaskText");
  return  sed or (task and task.text);

Template.task_detail.taskTags = ->
  task = Tasks.findOne( Session.get("currentTaskId"));

  if task.tags
    return task.tags.join(',')
  else
    return []

Template.task_detail.taskActivities = ->
  comments = Comments.find({objectId: Session.get('currentTaskId')}).fetch()
  comments = _.map comments, (c)-> _.extend(c, {type: 'comment', isComment: true})
  activities = Activities.find({objectId: Session.get('currentTaskId'), action: {$nin: ['commentTask']}}).fetch()
  activities= _.map activities, (c)-> _.extend(c, {type: 'activity', isComment: false})

  result = _.union(comments, activities)
  return _.sortBy result, (el)-> el.timestamp

Template.task_detail.newCommentEditingMode = ->
  return Session.get("focused_on_new_comment")

Template.task_detail.taskFiles = ->
  #Uploads.find({metadata: {task_id: Session.get("currentTaskId")}})

Template.task_detail.hasFiles = ->
  #Uploads.find({metadata: {task_id: Session.get("currentTaskId")}}).count() > 0

Template.task_detail.hasActivities = ->
  objectId = Session.get('currentTaskId')
  commentCount = Comments.find({objectId: objectId}).count()
  activityCount = Activities.find({objectId: objectId, action: {$nin: ['commentTask']}}).count()
  return ( commentCount > 0 or activityCount > 0)

Template.task_detail.taskActivityText = (activity)->
  switch activity.action
    when "changeTask"
      if ("assigneeId" of activity.actionObject.after)
        #assignee = Meteor.users.findOne(activity.actionObject.after.assigneeId)
        return "assigned to " + global.userDisplayName(activity.actionObject.after.assigneeId)
      if ("dueAt" of activity.actionObject.after)
        return "changed due to " + global.shortDateofTimestamp(activity.actionObject.after.dueAt)
      if ("text" of activity.actionObject.after)
        return "changed the name to \"#{activity.actionObject.after.text}\""
      if ("done" of activity.actionObject.after)
        if activity.actionObject.after.done
          return "completed this task"
        else
          return "reopened this task"
      if ("description" of activity.actionObject.after)
        if ("description" of activity.actionObject.before)
          return "changed description"
        else
          return "added description"
    when "addTaskTag"
      return "added tag \"#{activity.actionObject}\""
    when "removeTaskTag"
      return "removed tag \"#{activity.actionObject}\""
    when "createTask"
      return "created this task"
    else return activity.action


Template.task_detail.events

  'click .pojs-remove-assignee': (event, templ) ->
    event.preventDefault()
    task = Tasks.findOne Session.get("currentTaskId")
    if task.assigneeId
      Meteor.call "updateTask", Session.get("currentTaskId"),
        assigneeId: ""

  'click .pojs-change-assignee': (event, templ) ->
    event.preventDefault()
    user_id = event.currentTarget.getAttribute("data-po-key")
    task = Tasks.findOne Session.get("currentTaskId")

    if task.assigneeId != user_id
      Meteor.call "updateTask", Session.get("currentTaskId"),
        assigneeId: user_id

  'click .pojs-remove-due': (event, templ)->
    event.preventDefault()
    task = Tasks.findOne Session.get("currentTaskId")
    if task.dueAt
      Meteor.call "updateTask", Session.get("currentTaskId"),
        dueAt: ""

  'change .pojs-toggle-done': (event, templ) ->
    event.preventDefault()
    task = Tasks.findOne({_id: Session.get("currentTaskId")});

    Meteor.call "updateTask", task._id,
      done: !task.done


  'focus .pojs-edit-text': (event, templ)->
    event.preventDefault()
    Session.set("editingTaskText", event.currentTarget.value)

  'blur .pojs-edit-text':  (event)->
    event.preventDefault()
    Session.set("editingTaskText", null)
    task = Tasks.findOne Session.get("currentTaskId")

    if task.text != event.currentTarget.value
      Meteor.call "updateTask", task._id,  text: event.currentTarget.value

  'keyup .pojs-edit-text': (event)->
    event.preventDefault()
    Session.set("editingTaskText", event.currentTarget.value)

  'blur .pojs-edit-description': (event) ->
    event.preventDefault()
    task = Tasks.findOne Session.get("currentTaskId")

    if task.description != event.currentTarget.value
      Meteor.call "updateTask", task._id,
        description: event.currentTarget.value

  #'click .po-task-file button.close': ()->
  #  if (confirm('Are you sure you want to delete the file: \n"'+this.filename+'"?'))
  #    Uploads.remove(this._id);

  #'click button.delete_task': (event, templ)->
  #  Tasks.remove({_id: Session.get("currentTaskId")})

  'submit .pojs-new-comment-form' : (event, templ)->
    event.preventDefault()
    obj = templ.find(".pojs-new-comment-content")
    Meteor.call "commentTask", Session.get("currentTaskId"), obj.value
    obj.value = ""

  'focus .pojs-new-comment-content': (event, templ)->
    event.preventDefault()
    Session.set("focused_on_new_comment", true)

  'blur .pojs-new-comment-content': (event, templ)->
    event.preventDefault()
    if event.currentTarget.value.length <= 0
      Session.set("focused_on_new_comment", false)


Template.task_detail.created = ->
  Session.set("focused_on_new_comment", false)

Template.task_detail.rendered = ->

  $('textarea.auto-resize').autosize();
  $('textarea.auto-resize').trigger('autosize.resize')
  $('[data-toggle=tooltip]').tooltip({delay:{show:300}});

  #dropfile('dropzone', Uploads, {task_id: Session.get("currentTaskId")} );

  $(".po-task-body")
    .on "dragenter", (event)->
      event.preventDefault()
      $(".po-task-file-dropzone").removeClass('hide');

  $(".po-task-file-dropzone")
    .on "dragleave", (event)->
      event.preventDefault()
      $(".po-task-file-dropzone").addClass('hide');
    .on "drop", (event)->
      event.preventDefault()
      $(".po-task-file-dropzone").addClass('hide');


  getAllTags = ->
    allTask = Tasks.find({}).fetch()
    process = (tags, task)-> _.union(tags, task.tags)
    tags = _.reduce(allTask, process, [])
    return _.map tags, (tag)-> {name: tag}


  $(".pojs-set-tags").selectize
    plugins: ['remove_button']
    valueField: 'name'
    labelField: 'name'
    searchField: 'name'
    options: getAllTags()
    create: true

    load: (query, callback)->
      if not query.length
        return callback()
      callback(getAllTags())

    onItemAdd: (value, $item)->
      if value and value.length
        Meteor.call "addTaskTag", Session.get("currentTaskId"), value

    onItemRemove: (value)->
      if value and value.length
        Meteor.call "removeTaskTag", Session.get("currentTaskId"), value

  $('.pojs-select-due').datepicker()
    .on 'changeDate', (ev)->
      task = Tasks.findOne Session.get("currentTaskId")
      Meteor.call "updateTask", task._id,
        dueAt: new Date(ev.date).getTime()

      $('.pojs-select-due').datepicker('hide');


