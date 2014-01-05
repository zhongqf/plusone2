@Tasklists = new Meteor.Collection("tasklists")

Meteor.methods

  addTasklist: (teamId, tasklistInfo)->
    user = global.authenticatedUser()
    team = Teams.findOne(teamId)

    if user && team
      tasklistInfo = _.extend(_.pick(tasklistInfo, 'name'), {
        teamId : team._id
        userId: user._id
        createdAt: new Date().getTime()
        updatedAt: new Date().getTime()
      })

      tasklistId = Tasklists.insert tasklistInfo
      return tasklistId
