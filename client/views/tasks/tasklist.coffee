
Template.tasklist.tasks = ->
  return Tasks.find({tasklistId: this._id}, {sort: {timestamp: -1}})
