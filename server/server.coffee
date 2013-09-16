

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

Meteor.startup ->

  Meteor.publish null, ->
    Meteor.users.find {},
      fields:
        username: 1
        emails: 1
        profile: 1

  Tasks.find().observeChanges
    "changed":  (id, fields)->
      if 'done' of fields
        if fields['done']
          Tasks.update
            _id: id, 
              $push: 
                histories: 
                  user_id: this.userId || Meteor.users.findOne({})._id
                  text: "completed this task" 
                  timestamp: new Date().getTime()
        else
          Tasks.update
            _id: id,
              $pull:
                histories:
                  text: "completed this task"

    "added": (id, fields)->
      created = _.find fields.histories, (history)->  history.text == "created task"
      if (_.isUndefined(created) ) 
        Tasks.update
          _id: id, 
            $push: 
              histories: 
                user_id: this.userId || Meteor.users.findOne({})._id
                text: "created task", 
                timestamp: new Date().getTime()

  if Projects.find().count() == 0
    timestamp = new Date().getTime()
    Projects.insert 
      name: "Sample Project"
      timestamp: timestamp
    Projects.insert 
      name: "Great Peace"
      timestamp: timestamp + 1

  if Meteor.users.find().count() == 0
    Accounts.createUser
      email: "universac@qq.com"
      username: "Jane Fishcer"
      password: "hello"


  if Tasklists.find().count() == 0
    data = [{
      name: "Meteor Principles",
      contents: [
        ["Data on the Wire", "Simplicity", "Better UX", "Fun"],
        ["One Language", "Simplicity", "Fun"],
        ["Database Everywhere", "Simplicity"],
        ["Latency Compensation", "Better UX"],
        ["Full Stack Reactivity", "Better UX", "Fun"],
        ["Embrace the Ecosystem", "Fun"],
        ["Simplicity Equals Productivity", "Simplicity", "Fun"]
      ]},{
      name: "Languages",
      contents: [
        ["Lisp", "GC"],
        ["C", "Linked"],
        ["C++", "Objects", "Linked"],
        ["Python", "GC", "Objects"],
        ["Ruby", "GC", "Objects"],
        ["JavaScript", "GC", "Objects"],
        ["Scala", "GC", "Objects"],
        ["Erlang", "GC"],
        ["6502 Assembly", "Linked"]
      ]},{
      name: "Favorite Scientists",
      contents: [
        ["Ada Lovelace", "Computer Science"],
        ["Grace Hopper", "Computer Science"],
        ["Marie Curie", "Physics", "Chemistry"],
        ["Carl Friedrich Gauss", "Math", "Physics"],
        ["Nikola Tesla", "Physics"],
        ["Claude Shannon", "Math", "Computer Science"]
      ]}
    ]

    timestamp = new Date().getTime()
    for element in data
      list_id = Tasklists.insert({name: element.name, timestamp: timestamp})
      timestamp+= 1

      for content in element.contents
        info = content
        Tasks.insert
          list_id: list_id
          text: info[0]
          timestamp: timestamp
          tags: info.slice(1)

        timestamp += 1 #ensure unique timestamp.

