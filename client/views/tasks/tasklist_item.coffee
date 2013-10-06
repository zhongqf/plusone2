#Task item
Template.tasklist_item.taskIsActive = ->
  return Session.get("currentTaskId") == this._id

Template.tasklist_item.editingText = ->
  if Session.get("currentTaskId") == this._id
    return Session.get("editing_text") or this.text
  else
    return this.text

Template.tasklist_item.events
  'focus input[type=text]': (event, templ)->
    Session.set("editing_text", event.currentTarget.value);
    Session.set("currentTaskId", this._id);

  'blur input[type=text]':  (event, templ)->
    Session.set("editing_text", null);

    Meteor.call "updateTask", this._id,
      text: event.currentTarget.value

  'keyup input[type=text]' : (event, templ)->
    Session.set("editing_text", event.currentTarget.value);
    if  event.which == 13
      t = Meteor.call "createTask",
        projectId: Session.get("currentProjectId")
        tasklistId: this.tasklistId
        text: ""
      setFocusObject(t,"Task")

  'keydown input[type=text]' : (event, templ)->
    Session.set("editing_text", event.currentTarget.value);
    if event.which == 8
      if event.currentTarget.value == ""
        Tasks.remove({_id: this._id})

  'change input[type=checkbox]':  (event, templ)->
    Meteor.call "updateTask", this._id,
      done: not this.done

