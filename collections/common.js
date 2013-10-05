authenticatedUser = function(){
    var user = Meteor.user();

    if (!user)
        throw new Meteor.Error(401, "You need to login.");

    return user;
}

buildChangeObject = function(oldObj, newObj){

    var oldKeys = _.keys(oldObj);

    var omitKeys = []
    _.each(oldKeys, function(key){
        if ((oldObj[key] === newObj[key]) || (! _.has(newObj, key)))
            omitKeys.push(key);
    });

    result = {
        before: _.omit(oldObj, omitKeys),
        after: _.omit(newObj, omitKeys)
    };

    console.log("changeObject:")
    console.log(result);

    return result;
}

