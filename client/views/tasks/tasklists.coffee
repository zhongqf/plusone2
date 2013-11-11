
#Task list
Template.tasklists.tasklists =  ->
  return Tasklists.find({projectId: Session.get('currentProjectId')},{sort: {timestamp: -1}})

Template.tasklists.events
  'blur .po_tasklist_name':  (event, templ)->
    Tasklists.update
      _id: this._id,
        $set:
          name: event.currentTarget.value

Template.tasklists.created = ->
  Session.set("addingTasklist", null)

Template.tasklists.rendered = ->
  $(".po-new-task").focus()

