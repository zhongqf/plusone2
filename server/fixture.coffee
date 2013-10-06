the_time = null
faketime= ->
  if the_time
    return the_time + _.random(2, 20) * 3600 * 1000
  else
    return new Date().getTime() - _.random(1,10) * 3600 * 24 * 1000

user_ids = []

if Meteor.users.find().count() == 0
  user_ids.push Accounts.createUser
    email: "universac@qq.com"
    username: "universac"
    password: "123456"
    createdAt: faketime()
    profile:
      name: "Jane Fishcer"

  _(10).times (n)->
    user = Fake.user()
    user_ids.push Accounts.createUser
      email: user.email
      username: (user.name + "." + user.surname).toLowerCase()
      password: "123456"
      createdAt: faketime()
      profile:
        name: user.name + " " + user.surname

random_times = (min,max,callback)->
  _(_.random(min,max)).times callback

random_user_id = ->
  shuffled = _.shuffle(user_ids)
  return shuffled[0]

user = (id)->
  Meteor.users.findOne(id)

words = ->
  words_array = Fake.paragraph().split(" ")
  return _.head(words_array, _.random(1,3)).join(" ")

tags = ["important","someday", "asap", "offshore", "onshore", "youchousei", "irai", "question", "clame", "trouble"]
random_tags = ->
  _.chain(tags).shuffle().head(_.random(1,3)).value()

if Projects.find().count() == 0
  random_times 5,10, ->
    ownerId = random_user_id()
    project = Projects.insert
      name: words()
      ownerId: ownerId
      timestamp: faketime()
      description: Fake.paragraph()
      public: (_.random(0,1) == 0)

    members = _.chain(user_ids).shuffle().head(_.random(3,6)).value()
    members.push(ownerId)
    _.each _.uniq(members), (m) ->
      Members.insert
        projectId: project
        userId: m

    random_times 3,6, ->
      list = Tasklists.insert
        projectId: project
        name: words()
        creatorId: random_user_id()
        timestamp: faketime()
        description: Fake.paragraph()

      random_times 5,10, ->
        task = Tasks.insert
          projectId: project
          tasklistId: list
          text: Fake.sentence()
          done: (_.random(0,2) == 0)
          timestamp: faketime()
          creatorId: random_user_id()
          assigneeId: random_user_id()
          dueAt: new Date().getTime() + _.random(3,30) * 3600 * 24 * 1000
          tags: random_tags()
          description: Fake.paragraph()


        random_times 0,3, ->
          Comments.insert
            objectId: task
            userId: random_user_id()
            text: Fake.sentence()
            timestamp: faketime()

