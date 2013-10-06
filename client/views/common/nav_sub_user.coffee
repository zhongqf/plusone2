Template.nav_sub_user.events
  'click .pojs-logout': (event)->
    event.preventDefault()
    Meteor.logout()
