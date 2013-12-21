Template.userEditProfile.events
  'click .pjs-update-profile': (event, templ)->
    first = templ.find("#userFirstname").value
    last = templ.find("#userLastname").value
    email = templ.find("#userEmail").value
    profile = {first_name: first, last_name: last, email: email}
    Meteor.call "updateProfile", profile
