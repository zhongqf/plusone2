

#Task detail
Template.task_detail.available_users = ->
  return Meteor.users.find()

Template.task_detail.assigned_user = ->
  task = Tasks.findOne({_id: Session.get("currentTaskId")});
  return Meteor.users.findOne(task.assigneeId)

Template.task_detail.task = ->
  return Tasks.findOne Session.get("currentTaskId")

Template.task_detail.editingText = ->
  task = Tasks.findOne(Session.get("currentTaskId"));
  sed = Session.get("editing_text");
  return  sed or (task and task.text);


Template.task_detail.taskTags = ->
  task = Tasks.findOne( Session.get("currentTaskId"));

  if task.tags
    return task.tags.join(',')
  else
    return [] 

Template.task_detail.taskActivities = ->
  #task = Tasks.findOne({_id: Session.get("currentTaskId")});
  #histories = _.map task.histories,
  #  (el)-> _.extend el,
  #    type: "history"
  #    isComment: false
  #comments = _.map task.comments, (el)-> _.extend(el, {type: "comment", isComment: true})
  #result = _.union(histories, comments)
  #return _.sortBy result, (el)-> el.timestamp

  comments = Comments.find({objectId: Session.get('currentTaskId')}).fetch()
  comments = _.map comments, (c)-> _.extend(c, {type: 'comment', isComment: true})
  return comments

Template.task_detail.newCommentEditingMode = ->
  return Session.get("focused_on_new_comment")

Template.task_detail.taskFiles = ->
  #Uploads.find({metadata: {task_id: Session.get("currentTaskId")}})

Template.task_detail.taskHasFiles = ->
  #Uploads.find({metadata: {task_id: Session.get("currentTaskId")}}).count() > 0

Template.task_detail.events

  #'click .po-task-file button.close': ()->
  #  if (confirm('Are you sure you want to delete the file: \n"'+this.filename+'"?'))
  #    Uploads.remove(this._id);


  'focus .po-task-title-content textarea': (event, templ)->
    Session.set("editing_text", event.currentTarget.value)

  'blur .po-task-title-content textarea':  (event)->
    Session.set("editing_text", null)
    task = Tasks.findOne Session.get("currentTaskId")

    if task.text != event.currentTarget.value
      Meteor.call "updateTask", task._id,  text: event.currentTarget.value

  'keyup .po-task-title-content textarea': (event)->
    Session.set("editing_text", event.currentTarget.value)

  'blur .po-task-description-content textarea': (event) ->
    task = Tasks.findOne Session.get("currentTaskId")

    if task.description != event.currentTarget.value
      Meteor.call "updateTask", task._id,
        description: event.currentTarget.value

  #'click button.delete_task': (event, templ)->
  #  Tasks.remove({_id: Session.get("currentTaskId")})
  
  'click button.po-task-add-comment':   (event, templ)->
    obj = templ.find(".po-task-newcomment-content textarea")
    Meteor.call "commentTask", Session.get("currentTaskId"), obj.value
    obj.value = ""

  'focus .po-task-newcomment-content textarea': (event, templ)->
    Session.set("focused_on_new_comment", true)
  
  'blur .po-task-newcomment-content textarea': (event, templ)->
    if event.currentTarget.value.length <= 0
      Session.set("focused_on_new_comment", false)

  'change .po-task-title input[type="checkbox"]': (event, templ) ->
    task = Tasks.findOne({_id: Session.get("currentTaskId")});

    Meteor.call "updateTask", task._id,
      done: !task.done

  'click #task-assignee-changer a': (event, templ) ->
    user_id = event.currentTarget.getAttribute("data-po-key")
    task = Tasks.findOne Session.get("currentTaskId")

    if task.assigneeId != user_id
      Meteor.call "updateTask", Session.get("currentTaskId"),
        assigneeId: user_id

  'click #task-assignee button': (event, templ) ->
    task = Tasks.findOne Session.get("currentTaskId")
    if task.assigneeId
      Meteor.call "updateTask", Session.get("currentTaskId"),
        assigneeId: ""

Template.task_detail.rendered = ->
  $('textarea.auto-resize').autosize();
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
    result = _.map tags, (tag)-> {name: tag}


  $("#task-tags").selectize
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
        Meteor.call "updateTask", Session.get("currentTaskId"),
          $push:
            tags: value
    onItemRemove: (value)->
      if value and value.length
        Meteor.call "updateTask", Session.get("currentTaskId"),
          $pull:
            tags: value

  $('#task-due-changer').datepicker()
    .on 'changeDate', (ev)->
      task = Tasks.findOne Session.get("currentTaskId")
      Meteor.call "updateTask", task._id,
        dueAt: new Date(ev.date).getTime()

      $('#task-due-changer').datepicker('hide');

 