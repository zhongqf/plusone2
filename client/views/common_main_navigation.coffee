Template.common_main_navigation.projects = ->
  Projects.find({}, {sort:{timestamp:-1}})
