Template.sidebarTeam.navLinks =->
  links = []

  return links unless currentTeam

  slug = currentTeam().slug
  links.push text: "Update",        key: "update",        url: "/team/#{slug}"
  links.push text: "Discussions",   key: "discussions",   url: "/team/#{slug}/discussions"
  links.push text: "Tasks",         key: "tasks",         url: "/team/#{slug}/tasks"
  links.push text: "Files",         key: "files",         url: "/team/#{slug}/files"
  links.push text: "Documents",     key: "documents",     url: "/team/#{slug}/documents"
  links.push text: "Events",        key: "events",        url: "/team/#{slug}/events"
  return links
