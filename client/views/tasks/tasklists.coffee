
#Task list
Template.tasklists.hasOrphanTasks = ->
  return Tasks.find({tasklistId: null}).count() > 0

Template.tasklists.orphanTasks = ->
  return Tasks.find({tasklistId: null}, {sort: {timestamp: -1}})

Template.tasklists.tasklists =  ->
  return Tasklists.find({},{sort: {timestamp: -1}})

Template.tasklists.tasksOf = (list)->
  return Tasks.find({tasklistId: list._id}, {sort: {timestamp: -1}})

Template.tasklists.events 
  'blur .po_tasklist_name':  (event, templ)->
    Tasklists.update
      _id: this._id, 
        $set:
          name: event.currentTarget.value

  'click #new_tasklist': (event, templ)->
    tl = Tasklists.insert
      name: ""
      timestamp: new Date().getTime()
    setFocusObject(tl,"Tasklist")

  'click #new_task': (event, templ)->
    t = Tasks.insert
      text: ""
      timestamp: new Date().getTime()
    setFocusObject(t,"Task")
