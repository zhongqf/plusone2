Template.sidebarUser.events
  'click .pojs-logout': (event)->
    event.preventDefault()
    Meteor.logout()

Template.sidebarUser.navLinks =->
  links = []
  links.push text: "Update",        key: "update",        url: "/me"
  links.push text: "Notifications", key: "notifications", url: "/me/notifications"
  links.push text: "My Items",      key: "items",         url: "/me/items"
  links.push text: "Joined Teams",  key: "teams",         url: "/me/teams"
  return links
