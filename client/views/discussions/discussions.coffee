Template.discussions.discussions = ->
  return Discussions.find({projectId: Session.get('currentProjectId')}, {sort: {timestamp: -1}})
