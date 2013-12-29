Template.newTeamDiscussion.events
  'submit .pjs-start-discussion-form': (event,templ)->
    event.preventDefault()

    teamId = Session.get("currentTeamId")
    team = Teams.findOne(teamId)

    title = templ.find("#discussionTitle").value
    text = templ.find("#discussionText").value
    discussionInfo = {title: title, text: text}
    Meteor.call "createDiscussion", teamId, discussionInfo, (error, result)->
      if error
        alert(error)
      else
        Router.go("/team/#{team.slug}/discussions");
