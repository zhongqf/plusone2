Activities = new Meteor.Collection("activities");

logTaskActivity = function(action, taskId, user, actionObject){

    var task = Tasks.findOne(taskId);

    if (typeof action === 'undefined' || typeof task === 'undefined')
        throw new Meteor.Error(500, "Internal Error.");

    user = (typeof user !== 'undefined') ? user : task.creatorId;

    Activities.insert({
        userId: user,
        objectId: task._id,
        objectType: "Task",
        projectId: task.projectId,
        action: action,
        timestamp: new Date().getTime(),
        actionObject: actionObject
    })

}
