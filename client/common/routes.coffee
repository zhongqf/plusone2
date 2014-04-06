Router.map ->
  @route 'mockup',
    path: '/mockup/:a/:b?/:c?/:d?/:e?/:f?'
    layoutTemplate: 'layoutMockup'
    action: ->
      paramsArray = _.chain(this.params).values().compact().value().join("_")
      template = "mockup_" + paramsArray
      this.render(template)

