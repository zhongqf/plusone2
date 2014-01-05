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

Template.partialTask.events
  "change input[type='checkbox']": (event, templ)->
    done = event.currentTarget.checked
    taskInfo = {done: done}
    Meteor.call "updateTask", this._id, taskInfo

