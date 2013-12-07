Template.teamTasks.tasklists = ->
  Tasklists.find({teamId: Session.get("currentTeamId")}, {sort: {createdAt: 1}})