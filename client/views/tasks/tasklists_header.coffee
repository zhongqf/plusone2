Template.tasklists_header.events 
  'click #new_tasklist': (event, templ)->
    tl = Tasklists.insert
      name: ""
      timestamp: new Date().getTime()
    Session.set("lastestObjectID", tl)
    Session.set("lastestObjectType", "Tasklist")

  'click #new_task': (event, templ)->
    t = Meteor.call "createTask",
      projectId: Session.get("currentProjectId")
      text: ""

    Session.set("lastestObjectID", t)
    Session.set("lastestObjectType", "Task")

