Template.layout.dynamicNavSub = (navKey)->
  key = "nav_sub_" + navKey;
  return Template[key]()