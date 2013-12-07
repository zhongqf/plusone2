chance = new Chance()

#Common Functions
around = (num)->
  return num *(0.666 + Math.random() * 0.666)

sample = (array, count = 1)->
  return _.shuffle(array).slice(0, count) if count > 1
  return _.shuffle(array)[0] if count == 1

title = (words = 5)->
  sentence = chance.sentence({words: around(words)})
  return sentence.slice(0, -1)

random_item = (collection, conditions = {})->
  collection = if Array.isArray(collection) then sample(collection) else collection
  objects = collection.find(conditions).fetch()
  return sample(objects)

random_id = (collection, conditions = {})->
  item = random_item(collection, conditions)
  return item._id ? item

random_items = (collection, conditions = {} ) ->
  collection = if Array.isArray(collection) then _.sample(collection) else collection
  objects = collection.find(conditions).fetch()
  return sample(objects, Math.random() * objects.length)


random_ids = (collection, conditions = {} ) ->
  return _.map(random_items(collection, conditions), (obj)->
    obj._id ?  obj
  )

random_timestamp = (options = {year: 2013}) ->
  return chance.date(options).getTime()

random_tags = (count)->
  tags = ["team", "task","discussion","calendar", "event", "file", "document", "invitation", "feature", "bug", "enhancement"]
  return sample(tags, around(count))


generateSampleData= ->
  console.log "Generating sample data ..."

  #Users
  console.log "  Generating users ..."
  _(20).times ->
    name = chance.name()
    username = name.split(/[ -]/).join("_").toLowerCase()
    Accounts.createUser
      email: username + "@" + chance.domain()
      username: username
      password: "123456"
      joinedAt: random_timestamp()
      profile:
        name: name

  #Teams
  console.log "  Generating teams ..."
  _(20).times ->
    name = title(2)
    slug = name.split(" ").slice(0,2).join("-").toLowerCase()
    Teams.insert
      name: name
      slug: slug
      description: chance.paragraph({sentence: around(1)})
      userId: random_id(Meteor.users)
      public: chance.bool()
      memberIds: random_ids(Meteor.users)
      createdAt: random_timestamp()

  #Tasklists
  console.log "  Generating tasklists ..."
  _(100).times ->
    Tasklists.insert
      name: title(2)
      teamId: random_id(Teams)
      userId: random_id(Meteor.users)
      createdAt: random_timestamp()

  #Tasks
  console.log "  Generating tasks ..."
  _(800).times ->
    tasklist = random_item(Tasklists)
    team = Teams.findOne({_id: tasklist.teamId})
    Tasks.insert
      title: title(5)
      description: chance.paragraph({sentence: around(1)})
      userId: random_id(Meteor.users)
      teamId: team._id
      tasklistId: tasklist._id
      assigneeId: if chance.bool() then sample(team.memberIds)
      done: chance.bool()
      createdAt: random_timestamp()
      updatedAt: random_timestamp()
      dueAt: if chance.bool() then random_timestamp()
      commentsCount: 0 #will update below
      lastCommentedAt: random_timestamp()  #Will update below
      lastCommentId: null #Will update below
      lastCommentUserId: null #Will update below
      tags: random_tags()

  #Discussions
  console.log "  Generating discussions ..."
  _(300).times ->
    Discussions.insert
      title: title(6)
      text: chance.paragraph({sentence: around(3)})
      teamId: random_id(Teams)
      userId: random_id(Meteor.users)
      createdAt: random_timestamp()
      updatedAt: random_timestamp()
      commentsCount: 0 #will update below
      lastCommentedAt: random_timestamp()  #Will update below
      lastCommentUserId: null #Will update below
      lastCommentId: null #Will update below

  #Comments
  console.log "  Generating comments ..."
  _(2000).times ->
    object = random_item([Tasks, Discussions])
    Comments.insert
      objectId: object._id
      teamId: object.teamId
      text: chance.paragraph({sentence: around(3)})
      createdAt: random_timestamp()
      userId: random_id(Meteor.users)

  console.log "Done!"

config = SystemConfig.findOne({key: "sampleData"})
if !config? or config.value
  generateSampleData()
  if config?
    SystemConfig.update({key: "sampleData"}, {value: false})
  else
    SystemConfig.insert({key: "sampleData", value: false})







#the_time = null
#faketime= ->
#  if the_time
#    return the_time + _.random(2, 20) * 3600 * 1000
#  else
#    return new Date().getTime() - _.random(1,10) * 3600 * 24 * 1000
#
#user_ids = []
#
#if Meteor.users.find().count() == 0
#  user_ids.push Accounts.createUser
#    email: "universac@qq.com"
#    username: "universac"
#    password: "123456"
#    createdAt: faketime()
#    profile:
#      name: "Jane Fishcer"
#
#  _(10).times (n)->
#    user = Fake.user()
#    user_ids.push Accounts.createUser
#      email: user.email
#      username: (user.name + "." + user.surname).toLowerCase()
#      password: "123456"
#      createdAt: faketime()
#      profile:
#        name: user.name + " " + user.surname
#
#random_times = (min,max,callback)->
#  _(_.random(min,max)).times callback
#
#random_user_id = ->
#  shuffled = _.shuffle(user_ids)
#  return shuffled[0]
#
#user = (id)->
#  Meteor.users.findOne(id)
#
#words = ->
#  words_array = Fake.paragraph().split(" ")
#  return _.head(words_array, _.random(1,3)).join(" ")
#
#tags = ["important","someday", "asap", "offshore", "onshore", "youchousei", "irai", "question", "clame", "trouble"]
#random_tags = ->
#  _.chain(tags).shuffle().head(_.random(1,3)).value()
#
#if Projects.find().count() == 0
#  random_times 5,10, ->
#    ownerId = random_user_id()
#    project = Projects.insert
#      name: words()
#      ownerId: ownerId
#      timestamp: faketime()
#      description: Fake.paragraph()
#      public: (_.random(0,1) == 0)
#
#    members = _.chain(user_ids).shuffle().head(_.random(3,6)).value()
#    members.push(ownerId)
#    _.each _.uniq(members), (m) ->
#      Members.insert
#        projectId: project
#        userId: m
#
#    random_times 10,20, ->
#      discussion = Discussions.insert
#        projectId: project
#        name: words()
#        text: Fake.paragraph()
#        creatorId: random_user_id()
#        timestamp: faketime()
#        lastCommentIds: []
#
#      commentIndex = 1
#      random_times 5, 10, ->
#        comment = Comments.insert
#          projectId: project
#          objectId: discussion
#          userId: random_user_id()
#          text: Fake.sentence()
#          timestamp: faketime()
#
#        if commentIndex <= 3
#          Discussions.update({_id: discussion},
#            $push:
#              lastCommentIds: comment
#          )
#
#        commentIndex = commentIndex + 1
#
#
#    random_times 3,6, ->
#      list = Tasklists.insert
#        projectId: project
#        name: words()
#        creatorId: random_user_id()
#        timestamp: faketime()
#        description: Fake.paragraph()
#
#      random_times 5,10, ->
#        task = Tasks.insert
#          projectId: project
#          tasklistId: list
#          text: Fake.sentence()
#          done: (_.random(0,2) == 0)
#          timestamp: faketime()
#          creatorId: random_user_id()
#          assigneeId: random_user_id()
#          dueAt: new Date().getTime() + _.random(3,30) * 3600 * 24 * 1000
#          tags: random_tags()
#          description: Fake.paragraph()
#
#
#        random_times 0,3, ->
#          Comments.insert
#            projectId: project
#            objectId: task
#            userId: random_user_id()
#            text: Fake.sentence()
#            timestamp: faketime()

