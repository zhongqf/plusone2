Template.login.users = ->
	return Meteor.users.find()

Template.login_user.displayEmail = ->
  return this.emails[0].address

Template.login_user.events =
  "click a": (event, templ)->

    event.preventDefault()

    email = templ.find("span").innerText
    Meteor.loginWithPassword(email, "123456")

