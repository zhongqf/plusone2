Template.sidebarExplorer.navLinks =->
  links = []
  links.push text: "Employees",         key: "employees",         url: "/explorer/employees"
  links.push text: "All Public Teams",  key: "all_teams",         url: "/explorer/teams"
  return links
