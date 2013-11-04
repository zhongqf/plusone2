
Template.tasklist.tasks = ->
  return Tasks.find({tasklistId: this._id}, {sort: {timestamp: -1}})

Template.tasklist.events
  'click .pojs-add-task': (event, templ)->
    event.preventDefault()
    tasklist_id = event.currentTarget.getAttribute("data-po-key")
    Meteor.call "newTask", tasklist_id
