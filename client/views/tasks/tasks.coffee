Meteor.startup ->
  moment.lang 'en',
    calendar:
      lastDay : 'MMM D'
      sameDay : '[Today]'
      nextDay : '[Tomorrow]'
      lastWeek : 'MMM D'
      nextWeek : 'MMM D'
      sameElse : 'MMM D'


Handlebars.registerHelper "userDisplayName", (user)->
  user = 
    if (typeof user is "string")
      Meteor.users.findOne({_id: user})
    else
      user

  if user
    return (user.profile && user.profile.name) || user.username || (user.emails && user.emails[0] && user.emails[0].address) || "Noname User"
  return "Invalid User"


Handlebars.registerHelper "shortDateOfTimestamp", (timestamp)->
  moment.unix(timestamp/1000).calendar()

Handlebars.registerHelper "fullDateOfTimestamp", (timestamp)->
  moment.unix(timestamp/1000).format('llll')

Handlebars.registerHelper "safeStandardTimestamp", (timestamp)->
  time = timestamp or new Date().getTime()
  return moment.unix(time/1000).format('YYYY-MM-DD')


nextObject = (current, selector) ->
  returnnext = false
  returnobj = null
  $(selector).each ->
    if returnnext
      returnobj = $(this)
      return false
    if $(this)[0] == current[0]
      returnnext = true
  return returnobj;

prevObject = (current, selector) ->
  prevobj = null
  $(selector).each ->
    if $(this)[0] == current[0]
      return false
    prevobj = $(this)
  return prevobj;


Handlebars.registerHelper "currentTask", ->
  return Tasks.findOne
    _id: Session.get("current_task_id")

#Task global
Template.tasks.preserve
  'input, textarea':  (node)-> 
    datapo = []
    if node.dataset
        datapo.push node.dataset.poType if node.dataset.poType
        datapo.push node.dataset.poKey if node.dataset.poKey
        datapo.push node.dataset.poProperty if node.dataset.poProperty
      return datapo.join("-")
    return node.id


Template.tasks.rendered = ->
  $('.checkbox-custom > input[type=checkbox]').each ()->
    $this = $(this);
    return if $this.data('checkbox')
    $this.checkbox($this.data())

  $('.tobe_focus').each ()->
    $this = $(this)

    lastestType = Session.get("lastestObjectType")
    lastestID = Session.get("lastestObjectID")
    thisType = $this.attr("data-po-type")
    thisID = $this.attr("data-po-key")

    if lastestID == thisID && lastestType == thisType
      $this.attr("autofocus", "autofocus")
      Session.set("lastestObjectType", null)
      Session.set("lastestObjectID", null)

  $('.tobe_focus').on "keydown", (event)->
    $this = $(this)
    if (event.which == 40)
      $next = nextObject($this, ".tobe_focus")
      event.preventDefault()
      $next[0].selectionStart = $next[0].selectionEnd = $next.val().length
      $next.focus()
      return false

    if (event.which == 38)
      $prev = prevObject($this, ".tobe_focus")
      event.preventDefault()
      $prev[0].selectionStart = $prev[0].selectionEnd = $prev.val().length
      $prev.focus()
      return false

      
     
