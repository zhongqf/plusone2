global = exports ? this

Template.task.comments = ->
  Comments.find({objectId: this._id}, {sort: {createdAt: 1}})

Template.task.checkedAttribute = ->
  return if this.done then "checked" else ""

Template.task.assignInfo = ->
  assignInfo = []

  if this.assigneeId
    assignInfo.push global.userDisplayName(this.assigneeId)
  if this.dueAt
    assignInfo.push global.shortDateOfTimestamp(this.dueAt)

  return assignInfo.join(" · ")

Template.task.events
  'submit .pjs-comment-form': (event, templ)->
    event.preventDefault()
    text = templ.find("#commentContent").value
    Meteor.call "commentTask", this._id, {text: text}, (error, result)->
      if error
        alert(error)
      else
        templ.find("#commentContent").value = ""
