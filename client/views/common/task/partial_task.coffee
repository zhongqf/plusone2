global = exports ? this

Template.partialTask.checkedAttribute = ->
  return if this.done then "checked" else ""

Template.partialTask.assignInfo = ->
  assignInfo = []

  if this.assigneeId
    assignInfo.push global.userDisplayName(this.assigneeId)
  if this.dueAt
    assignInfo.push global.shortDateOfTimestamp(this.dueAt)

  return assignInfo.join(" · ")

Template.partialTask.rendered = ->
  id = this.data._id
  options =
    template: $("#pjs-task-calendar-template").html()
    startWithMonth: moment().format("YYYY-MM-DD")
  if this.data.dueAt
    due = moment.unix(this.data.dueAt/1000).format("YYYY-MM-DD")
    options.events = [
      date: due
      title: "Due"
    ]
    options.startWithMonth = due

  selector = "[data-pjs-task-id='#{id}']"
  $(selector).clndr options

Template.partialTask.events
  "change input[type='checkbox']": (event, templ)->
    done = event.currentTarget.checked
    taskInfo = {done: done}
    Meteor.call "updateTask", this._id, taskInfo


Template.partialTaskAssigneeDialog.unassignedSelected = ->
  task = Tasks.findOne({_id: this._id})
  return '' unless task
  return if task.assigneeId then '' else 'selected'


Template.partialTaskAssigneeDialog.members = ->
  team = Teams.findOne(Session.get("currentTeamId"))
  task = Tasks.findOne({_id: this._id})
  return [] unless team or task

  members = Meteor.users.find({_id: {$in: team.memberIds}}).fetch()
  _.map members, (s)->
    s.selected = if (task.assigneeId == s._id) then 'selected' else ''

  return members
