Meteor.startup ->
  moment.lang 'en',
    calendar:
      lastDay : 'MMM D'
      sameDay : '[Today]'
      nextDay : '[Tomorrow]'
      lastWeek : 'MMM D'
      nextWeek : 'MMM D'
      sameElse : 'MMM D'


Handlebars.registerHelper "userLink", (user_id)->
  user =  Meteor.users.findOne({_id: user_id})
  display =  if user
    (user.profile && user.profile.name) || user.username || (user.emails && user.emails[0] && user.emails[0].address) || "unknown user"
  else "system"  
  return new Handlebars.SafeString("<a href='#' class='po-task-activity-user'><strong>" + display + "</strong></a>")

Handlebars.registerHelper "shortDateOfTimestamp", (timestamp)->
  moment.unix(timestamp/1000).calendar()

Handlebars.registerHelper "fullDateOfTimestamp", (timestamp)->
  moment.unix(timestamp/1000).format('llll')

Handlebars.registerHelper "safeStandardTimestamp", (timestamp)->
  time = timestamp or new Date().getTime()
  return moment.unix(time/1000).format('YYYY-MM-DD')

setFocusObject = (obj, klass)->
  if obj && klass
    Session.set("lastestObjectID", obj)
    Session.set("lastestObjectType", klass)

nextObject = (current, selector) ->
  returnnext = false
  returnobj = null
  $(selector).each ->
    if returnnext
      returnobj = $(this)
      return false
    if $(this)[0] == current[0]
      returnnext = true
  return returnobj;

prevObject = (current, selector) ->
  prevobj = null
  $(selector).each ->
    if $(this)[0] == current[0]
      return false
    prevobj = $(this)
  return prevobj;


Handlebars.registerHelper "currentTask", ->
  return Tasks.findOne
    _id: Session.get("current_task_id")

#Task global
Template.tasks.preserve
  'input, textarea':  (node)-> 
    datapo = []
    if node.dataset
        datapo.push node.dataset.poType if node.dataset.poType
        datapo.push node.dataset.poKey if node.dataset.poKey
        datapo.push node.dataset.poProperty if node.dataset.poProperty
      return datapo.join("-")
    return node.id


Template.tasks.rendered = ->
  $('.checkbox-custom > input[type=checkbox]').each ()->
    $this = $(this);
    return if $this.data('checkbox')
    $this.checkbox($this.data())

  $('.tobe_focus').each ()->
    $this = $(this)

    lastestType = Session.get("lastestObjectType")
    lastestID = Session.get("lastestObjectID")
    thisType = $this.attr("data-po-type")
    thisID = $this.attr("data-po-key")

    if lastestID == thisID && lastestType == thisType
      $this.attr("autofocus", "autofocus")
      Session.set("lastestObjectType", null)
      Session.set("lastestObjectID", null)

  $('.tobe_focus').on "keydown", (event)->
    $this = $(this)
    if (event.which == 40)
      $next = nextObject($this, ".tobe_focus")
      event.preventDefault()
      $next[0].selectionStart = $next[0].selectionEnd = $next.val().length
      $next.focus()
      return false

    if (event.which == 38)
      $prev = prevObject($this, ".tobe_focus")
      event.preventDefault()
      $prev[0].selectionStart = $prev[0].selectionEnd = $prev.val().length
      $prev.focus()
      return false

      

#Task list
Template.task_lists.hasOrphanTasks = ->
  return Tasks.find({list_id: null}).count() > 0

Template.task_lists.orphanTasks = ->
  return Tasks.find({list_id: null}, {sort: {timestamp: -1}})

Template.task_lists.tasklists =  ->
  return Tasklists.find({},{sort: {timestamp: -1}})

Template.task_lists.tasksOf = (list)->
  return Tasks.find({list_id: list._id}, {sort: {timestamp: -1}})

Template.task_lists.events 
  'blur .po_task_list_name':  (event, templ)->
    Tasklists.update
      _id: this._id, 
        $set:
          name: event.currentTarget.value

  'click #new_task_list': (event, templ)->
    tl = Tasklists.insert
      name: ""
      timestamp: new Date().getTime()
    setFocusObject(tl,"Tasklist")

  'click #new_task': (event, templ)->
    t = Tasks.insert
      text: ""
      timestamp: new Date().getTime()
    setFocusObject(t,"Task")


#Task item
Template.task_item.taskIsActive = ->
  return Session.get("current_task_id") == this._id

Template.task_item.editingText = ->
  if Session.get("current_task_id") == this._id
    return Session.get("editing_text") or this.text
  else
    return this.text

Template.task_item.events
  'focus input[type=text]': (event, templ)->
    Session.set("editing_text", event.currentTarget.value);
    Session.set("current_task_id", this._id);

  'blur input[type=text]':  (event, templ)->
    Session.set("editing_text", null);    
    Tasks.update
      _id: this._id,
        $set:
          text: event.currentTarget.value

  'keyup input[type=text]' : (event, templ)->
    Session.set("editing_text", event.currentTarget.value);
    if  event.which == 13
      t = Tasks.insert({list_id: this.list_id, text: ""})
      setFocusObject(t,"Task")

  'keydown input[type=text]' : (event, templ)->
    Session.set("editing_text", event.currentTarget.value);
    if event.which == 8
      if event.currentTarget.value == ""
        Tasks.remove({_id: this._id})

  'change input[type=checkbox]':  (event, templ)->
    Tasks.update
      _id: this._id,
        $set: 
          done: not this.done


#Task detail
Template.task_detail.task = ->
  return Tasks.findOne
    _id: Session.get("current_task_id")

Template.task_detail.editingText = ->
  task = Tasks.findOne({_id: Session.get("current_task_id")});
  sed = Session.get("editing_text");
  return  sed or (task and task.text);


Template.task_detail.taskTags = ->
  task = Tasks.findOne({_id: Session.get("current_task_id")});

  if task.tags
    return task.tags.join(',')
  else
    return [] 

Template.task_detail.taskActivities = ->
  task = Tasks.findOne({_id: Session.get("current_task_id")});
  histories = _.map task.histories, 
    (el)-> _.extend el, 
      type: "history"
      isComment: false
  comments = _.map task.comments, (el)-> _.extend(el, {type: "comment", isComment: true})
  result = _.union(histories, comments)
  return _.sortBy result, (el)-> el.timestamp

Template.task_detail.newCommentEditingMode = ->
  return Session.get("focused_on_new_comment")

Template.task_detail.taskFiles = ->
  #Uploads.find({metadata: {task_id: Session.get("current_task_id")}})

Template.task_detail.taskHasFiles = ->
  #Uploads.find({metadata: {task_id: Session.get("current_task_id")}}).count() > 0

Template.task_detail.events

  #'click .po-task-file button.close': ()->
  #  if (confirm('Are you sure you want to delete the file: \n"'+this.filename+'"?'))
  #    Uploads.remove(this._id);


  'focus .po-task-title-content textarea': (event, templ)->
    Session.set("editing_text", event.currentTarget.value)

  'blur .po-task-title-content textarea':  (event)->
    Session.set("editing_text", null)   
    Tasks.update({_id: Session.get("current_task_id")}, {$set: {text: event.currentTarget.value}})

  'keyup .po-task-title-content textarea': (event)->
    Session.set("editing_text", event.currentTarget.value)

  'blur .po-task-description-content textarea': (event) ->
    Tasks.update({_id: Session.get("current_task_id")}, {$set: {description: event.currentTarget.value}});

  #'click button.delete_task': (event, templ)->
  #  Tasks.remove({_id: Session.get("current_task_id")})
  
  'click button.po-task-add-comment':   (event, templ)->
    Tasks.update
      _id: Session.get("current_task_id"), 
        $push: 
          comments:
            user_id: Meteor.userId()
            text: templ.find(".po-task-newcomment-content textarea").value
            timestamp: new Date().getTime()
  
    templ.find(".po-task-newcomment-content textarea").value = "";

  'focus .po-task-newcomment-content textarea': (event, templ)->
    Session.set("focused_on_new_comment", true)
  
  'blur .po-task-newcomment-content textarea': (event, templ)->
    if event.currentTarget.value.length <= 0
      Session.set("focused_on_new_comment", false)

  'change .po-task-title input[type="checkbox"]': (event, templ) ->
    task = Tasks.findOne({_id: Session.get("current_task_id")});
    Tasks.update({_id: task._id}, {$set: {done: !task.done}});




Template.task_detail.rendered = ->
  $('textarea.auto-resize').autosize();
  $('[data-toggle=tooltip]').tooltip({delay:{show:300}});

  #dropfile('dropzone', Uploads, {task_id: Session.get("current_task_id")} );

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
        Tasks.update
          _id: Session.get("current_task_id"),
            $push:
              tags: value
    onItemRemove: (value)->
      if value and value.length
        Tasks.update
          _id: Session.get("current_task_id"),
            $pull:
              tags: value

  $('#task-due-changer').datepicker()
    .on 'changeDate', (ev)->
      task = Tasks.findOne({_id: Session.get("current_task_id")})
      date = new Date(ev.date).getTime()
      Tasks.update({_id: task._id}, {$set: {due: date}})
      $('#task-due-changer').datepicker('hide');

      
