Template.teamDiscussions.discussions = ->
  Discussions.find({teamId: Session.get("currentTeamId")}, {sort: {updatedAt: -1}})