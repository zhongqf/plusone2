#Task item
Template.task_item.taskIsActive = ->
  return Session.get("currentTaskId") == this._id

Template.task_item.editingText = ->
  if Session.get("currentTaskId") == this._id
    return Session.get("editing_text") or this.text
  else
    return this.text

Template.task_item.events
  'focus input[type=text]': (event, templ)->
    Session.set("editing_text", event.currentTarget.value);
    Session.set("currentTaskId", this._id);

  'blur input[type=text]':  (event, templ)->
    Session.set("editing_text", null);

    newText = event.currentTarget.value

    if (newText != this.text)
      Meteor.call "updateTask", this._id,
        text: newText

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
