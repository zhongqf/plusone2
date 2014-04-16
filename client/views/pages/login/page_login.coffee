Template.pageLogin.users = ->
  return Meteor.users.find()

Template.pageLogin.events =
  "click a.pcs-login-with-user": (event)->
    event.preventDefault()
    target = $(event.currentTarget);
    email = target.children("span").text().trim()

    Meteor.loginWithPassword(email, "123456")
    #redirectUrl = Session.get("loginRedirectUrl") || "/"
    #Router.go redirectUrl
