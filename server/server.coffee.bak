

#/// Publish complete set of lists to all clients.
#/Meteor.publish('tasklists', function () {
#/  return Tasklists.find();
#/});
#/
#/
#/// Publish all items for requested list_id.
#/Meteor.publish('tasks', function () {
#/  return Tasks.find({});
#/});


#/ if the database is empty on server start, create some sample data.

#Meteor.startup ->
#
#  Meteor.publish null, ->
#    Meteor.users.find {},
#      fields:
#        username: 1
#        emails: 1
#        profile: 1
#
  #Tasks.find().observeChanges
  #  "changed":  (id, fields)->
  #    if 'done' of fields
  #      if fields['done']
  #        Tasks.update
  #          _id: id,
  #            $push:
  #              histories:
  #                user_id: Meteor.userId || Meteor.users.findOne({})._id
  #                text: "completed this task"
  #                timestamp: new Date().getTime()
  #      else
  #        Tasks.update
  #          _id: id,
  #            $pull:
  #              histories:
  #                text: "completed this task"
  #    if 'assigned_user_id' of fields
  #      console.log fields
  #      if fields['assigned_user_id']
  #        assigned_user = Meteor.users.findOne({_id: fields['assigned_user_id']})
  #        Tasks.update
  #          _id: id,
  #            $set:
  #              old_assigned_user_id: fields['assigned_user_id']
  #            $push:
  #              histories:
  #                user_id: Meteor.userId || Meteor.users.findOne({})._id
  #                text: "assigned to " + assigned_user.username
  #                timestamp: new Date().getTime()
  #      else
  #        old_assigned_user_id = Tasks.findOne({_id:id}).old_assigned_user_id
  #        old_assigned_user = Meteor.users.findOne({_id: old_assigned_user_id})
  #        Tasks.update
  #          _id: id,
  #            $push:
  #              histories:
  #                user_id: Meteor.userId || Meteor.users.findOne({})._id
  #                text: "unassigned from " + old_assigned_user.username
  #                timestamp: new Date().getTime()


  #  "added": (id, fields)->
  #    created = _.find fields.histories, (history)->  history.text == "created task"
  #    if (_.isUndefined(created) )
  #      Tasks.update
  #        _id: id,
  #          $push:
  #            histories:
  #              user_id: Meteor.userId || Meteor.users.findOne({})._id
  #              text: "created task",
  #              timestamp: new Date().getTime()

