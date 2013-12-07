Template.sidebarUser.events
  'click .pojs-logout': (event)->
    event.preventDefault()
    Meteor.logout()

Template.sidebarUser.navLinks =->
  user = this.user
  prefix = if isCurrentUser(user) then "/me" else "/user/#{user.username}"
  links = []
  links.push(text: "Inbox",         key: "inbox",         url: "#{prefix}/inbox") if isCurrentUser(user)
  links.push(text: "Notifications", key: "notifications", url: "#{prefix}/notifications") if isCurrentUser(user)
  links.push(text: "Activities",    key: "activities",    url: "#{prefix}/activities")
  links.push(text: "My Items",      key: "items",         url: "#{prefix}/items")
  links.push(text: "Joined Teams",  key: "teams",         url: "#{prefix}/teams")
  return links
