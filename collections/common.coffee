global = exports ? this

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


