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
  display = if user
    (user.profile && user.profile.name) or
    (user.emails[0].address) or
    user.username
  else
    "system"
  
  return new Handlebars.SafeString("<b>" + display + "</b>")
                

Template.task_lists.task_lists =  ->
  return Tasklists.find({})


Template.task_lists.tasks = (list)->
  return Tasks.find({list_id: list._id})


Template.task_lists.events
  'blur .task_list_name':  (event, templ)->
    Tasklists.update
      _id: this._id, 
        $set:
          name: event.currentTarget.value

  'blur .task_list_description':  (event, templ)->
    Tasklists.update
      _id: this._id, 
        $set:
          description: event.currentTarget.value

  'click .new_task_list':  (event, templ)->
    Tasklists.insert
      name: ""

  'click button.new_task': (event,templ)->
    Tasks.insert({list_id: this._id, text: ""})


Template.task.task_text = ->
  if Session.get("current_task_id") == this._id
    return Session.get("editing_text") or this.text
  else
    return this.text


Template.task.task_class = ->
  return if (Session.get("current_task_id") == this._id) then "active" else ""

Template.task.events
  'focus input': (event, templ)->
    Session.set("editing_text", event.currentTarget.value);
    Session.set("current_task_id", this._id);

  'blur input':  (event, templ)->
    Session.set("editing_text", null);    
    Tasks.update
      _id: this._id,
        $set:
          text: event.currentTarget.value

  'keyup input' : (event, templ)->
    Session.set("editing_text", event.currentTarget.value);
    if  event.which == 13
      Tasks.insert({list_id: this.list_id, text: ""})
    if event.which == 8
      if event.currentTarget.value == ""
        Tasks.remove({_id: this._id})


  'change input[type="checkbox"]':  (event, templ)->
    Tasks.update
      _id: this._id,
        $set: 
          done: not this.done



Template.task_detail.task = ->
  return Tasks.findOne
    _id: Session.get("current_task_id")


Template.task_detail.task_text = ->
  task = Tasks.findOne({_id: Session.get("current_task_id")});
  sed = Session.get("editing_text");
  return  sed or (task and task.text);


Template.task_detail.task_due = ->
  task = Tasks.findOne({_id: Session.get("current_task_id")});
  due = moment(task.due);
  return if task.due and due.isValid() then due.calendar() else "Not set"

Template.task_detail.task_history_and_comments = ->
  task = Tasks.findOne({_id: Session.get("current_task_id")});
  histories = _.map task.histories, (el)-> _.extend(el, {type: "history"})
  comments = _.map task.comments, (el)-> _.extend(el, {type: "comemnt"})
  result = _.union(histories, comments)
  return _.sortBy result, (el)-> el.timestamp


Template.task_detail.rendered = ->
  $(".datepicker").datepicker
    onSelect:  (date)->
      task = Tasks.findOne({_id: Session.get("current_task_id")})
      date = new Date(date).getTime()
      Tasks.update({_id: task._id}, {$set: {due: date}})


Template.task_detail.events
  'focus input.title': (event, templ)->
    Session.set("editing_text", event.currentTarget.value)

  'blur input.title':  (event)->
    Session.set("editing_text", null)   
    Tasks.update({_id: Session.get("current_task_id")}, {$set: {text: event.currentTarget.value}})

  'keyup input.title': (event)->
    Session.set("editing_text", event.currentTarget.value)

  'blur textarea.description': (event) ->
    Tasks.update({_id: Session.get("current_task_id")}, {$set: {description: event.currentTarget.value}});

  'click button.delete_task': (event, templ)->
    Tasks.remove({_id: Session.get("current_task_id")})

  'click button.add_comment':   (event, templ)->
    Tasks.update
      _id: Session.get("current_task_id"), 
        $push: 
          comments:
            user_id: Meteor.userId()
            text: templ.find(".newcomment").value
            timestamp: new Date().getTime()

    templ.find(".newcomment").value = "";

  'change input[type="checkbox"]': (event, templ) ->
    task = Tasks.findOne({_id: Session.get("current_task_id")});
    Tasks.update({_id: task._id}, {$set: {done: !task.done}});
