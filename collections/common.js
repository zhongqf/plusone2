authenticatedUser = function(){
    var user = Meteor.user();

    if (!user)
        throw new Meteor.Error(401, "You need to login.");

    return user;
}

buildChangeObject = function(oldObj, newObj){
    var oldKeys = _.keys(oldObj);
    var newKeys = _.keys(newObj);

    var iteKeys = oldKeys.length < newKeys.length ? oldKeys : newKeys;

    var sameKeys = [];

    _.each(iteKeys, function(key){
        if (oldObj[key] === newObj[key])
            sameKeys.push(key);
    });

    return {
        before: _.omit(oldObj, sameKeys),
        after: _.omit(newObj, sameKeys)
    };
}

