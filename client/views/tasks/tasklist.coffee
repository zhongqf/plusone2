
Template.tasklist.tasks = ->
  return Tasks.find({tasklistId: this._id}, {sort: {timestamp: 1}})












Template.new_task.showAddTaskBox = ->
  return Session.equals("addingTasklist", this._id)

Template.new_task.events
  'click .pojs-show-add-task-box': (event, templ)->
    event.preventDefault()
    tasklist_id = event.currentTarget.getAttribute("data-po-key")
    Session.set("addingTasklist", tasklist_id)
  
  'blur .po-new-task': (event,templ)->
    event.preventDefault()
    Session.set("addingTasklist", null)

  'keyup .po-new-task': (event,templ)->
    if event.which == 13
      tasklist_id = event.currentTarget.getAttribute("data-po-key")
      text = event.currentTarget.value

      Meteor.call "createTask",
        projectId: Session.get("currentProjectId")
        tasklistId: tasklist_id
        text: text

      event.currentTarget.value = ""
    if event.which == 27
      event.preventDefault()
      Session.set("addingTasklist", null)




