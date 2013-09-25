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
