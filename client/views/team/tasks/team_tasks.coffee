Template.teamTasks.tasklists = ->
  Tasklists.find({teamId: Session.get("currentTeamId")}, {sort: {createdAt: -1}})

Template.teamTasks.addingMode = ->
  return Session.equals("addingTasklistMode", true)

Template.teamTasks.events
  'click .pjs-new-tasklist': (event,templ)->
    event.preventDefault()
    Session.set("addingTasklistMode", true)

  'click .pjs-cancel-add-tasklist': (event,templ)->
    event.preventDefault()
    Session.set("addingTasklistMode", false)

  'submit form': (event, templ)->
    event.preventDefault()
    content_object = templ.find(".pjs-new-tasklist-content")
    teamId = Session.get("currentTeamId")
    tasklist_info = {name: content_object.value}
    Meteor.call "addTasklist", teamId, tasklist_info, (error, result)->
      unless error
        content_object.value = ""
        content_object.focus()
        Session.set("addingTasklistMode", false)
        Session.set("addingTaskMode-#{result}", true)
