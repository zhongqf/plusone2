global = exports ? this

global.stringPresentMatcher = Match.Where (x)->
  check(x, String)
  return x.length > 0

global.authenticatedUser = ->
  user = Meteor.user()
  if (!user)
    throw new Meteor.Error(401, "You need to login.")
  return user


global.buildChangeObject = (oldObj, newObj)->

  oldKeys = _.keys(oldObj)

  omitKeys = []

  _.each oldKeys, (key)->
    if ((oldObj[key] == newObj[key]) || (! _.has(newObj, key)))
      omitKeys.push(key)

  result = {
    before: _.omit(oldObj, omitKeys),
    after: _.omit(newObj, omitKeys)
  }

  return result


Meteor.methods
  updateProfile: (profile)->
    user = global.authenticatedUser()
    #todo: update user email
    Meteor.users.update
      _id: user._id,
        $set:
          profile:
            first_name: profile.first_name
            last_name: profile.last_name
            name: "#{profile.first_name} #{profile.last_name}"
            email: profile.email

