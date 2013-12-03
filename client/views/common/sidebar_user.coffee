Template.sidebarUser.events
  'click .pojs-logout': (event)->
    event.preventDefault()
    Meteor.logout()

Template.sidebarUser.navLinks =->
  links = []
  links.push text: "Inbox",         key: "inbox",         url: "/me/inbox"
  links.push text: "Notifications", key: "notifications", url: "/me/notifications"
  links.push text: "Activities",    key: "activities",    url: "/me/activities"
  links.push text: "My Items",      key: "items",         url: "/me/items"
  links.push text: "Joined Teams",  key: "teams",         url: "/me/teams"
  return links
