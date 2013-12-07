Template.partialTasklist.tasks = ->
  Tasks.find({tasklistId: this._id}, {sort: {createdAt: 1}})