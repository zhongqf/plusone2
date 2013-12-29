Template.discussion.comments = ->
  Comments.find({objectId: this._id}, {sort: {createdAt: 1}})

Template.discussion.events
  'submit .pjs-comment-form': (event, templ)->
    event.preventDefault()
    text = templ.find("#commentContent").value
    Meteor.call "commentDiscussion", this._id, {text: text}, (error, result)->
      if error
        alert(error)
      else
        templ.find("#commentContent").value = ""
