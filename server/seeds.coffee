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

#  #Teams
#  console.log "  Generating teams ..."
#  _(20).times ->
#    name = title(2)
#    slug = name.split(" ").slice(0,2).join("-").toLowerCase()
#    Teams.insert
#      name: name
#      slug: slug
#      description: chance.paragraph({sentence: around(1)})
#      userId: random_id(Meteor.users)
#      public: chance.bool()
#      memberIds: random_ids(Meteor.users)
#      createdAt: random_timestamp()
#
#  #Tasklists
#  console.log "  Generating tasklists ..."
#  _(100).times ->
#    Tasklists.insert
#      name: title(2)
#      teamId: random_id(Teams)
#      userId: random_id(Meteor.users)
#      createdAt: random_timestamp()
#
#  #Tasks
#  console.log "  Generating tasks ..."
#  _(800).times ->
#    tasklist = random_item(Tasklists)
#    team = Teams.findOne({_id: tasklist.teamId})
#    Tasks.insert
#      title: title(5)
#      description: chance.paragraph({sentence: around(1)})
#      userId: random_id(Meteor.users)
#      teamId: team._id
#      tasklistId: tasklist._id
#      assigneeId: sample(team.memberIds)
#      done: chance.bool()
#      createdAt: random_timestamp()
#      updatedAt: random_timestamp()
#      dueAt: random_timestamp()
#      tags: random_tags()
#
#  #Discussions
#  console.log "  Generating discussions ..."
#  _(300).times ->
#    Discussions.insert
#      title: title(6)
#      text: chance.paragraph({sentence: around(3)})
#      teamId: random_id(Teams)
#      userId: random_id(Meteor.users)
#      createdAt: random_timestamp()
#      updatedAt: random_timestamp()
#      lastRepliedAt: random_timestamp()  #Will update below
#      lastCommentId: null #Will update below
#
#  #Comments
#  console.log "  Generating comments ..."
#  _(2000).times ->
#    object = random_item([Tasks, Discussions])
#    Comments.insert
#      objectId: object._id
#      teamId: object.teamId
#      text: chance.paragraph({sentence: around(3)})
#      createdAt: random_timestamp()
#      userId: random_id(Meteor.users)

  console.log "Done!"

config = SystemConfig.findOne({key: "sampleData"})
if !config? or config.value
  generateSampleData()
  if config?
    SystemConfig.update({key: "sampleData"}, {value: false})
  else
    SystemConfig.insert({key: "sampleData", value: false})

