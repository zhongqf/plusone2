Template.layoutBasic.events =
  "click a.pcs-logout": (event)->
    event.preventDefault()
    Meteor.logout()
