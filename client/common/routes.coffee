class @BasicController extends RouteController
  layoutTemplate: "layoutBasic"

  onBeforeAction: (pause)->
    if Meteor.loggingIn()
      pause()
    else
      if Meteor.user()
        @setLayout("layoutBasic")
      else
        @setLayout("layoutNone")
        @render("pageLogin")
        @renderRegions()
        pause()

Router.map ->
  @route 'mockup',
    controller: 'BasicController'
    path: '/mockup/:a/:b?/:c?/:d?/:e?/:f?'
    action: ->
      paramsArray = _.chain(this.params).values().compact().value().join("_")
      template = "mockup_" + paramsArray
      @render(template)

  @route 'login',
    path: '/login'
    layoutTemplate: null
    template: 'pageLogin'

