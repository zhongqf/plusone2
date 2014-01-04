Template.partialTasklist.tasks = ->
  Tasks.find({tasklistId: this._id}, {sort: {createdAt: 1}})

Template.partialTasklist.addingMode = ->
  return Session.equals("addingTaskMode-#{this._id}", true)

Template.partialTasklist.created = ->
  Session.set("addingTaskMode-#{this._id}", false)

Template.partialTasklist.events
  'click .pjs-add-task': (event,templ)->
    event.preventDefault()
    Session.set("addingTaskMode-#{this._id}", true)

  'click .pjs-cancel-add-task': (event)->
    event.preventDefault()
    Session.set("addingTaskMode-#{this._id}", false)

  'submit form': (event, templ)->
    event.preventDefault()
    content_object = templ.find(".pjs-new-task-content")
    task_info = {title: content_object.value}
    Meteor.call "addTask", this._id, task_info, (error)->
      unless error
        content_object.value = ""
        content_object.focus()

