Tasks = new Meteor.Collection("tasks");

Meteor.methods({
    createTask: function(taskAttrs){

        var user = authenticatedUser();

        var task = _.extend(_.pick(taskAttrs, 'projectId', 'tasklistId', 'text'), {
            creatorId: user._id,
            timestamp: new Date().getTime()
        });

        var taskId = Tasks.insert(task);

        logTaskActivity('createTask', taskId);

        return taskId;
    },

    updateTask: function(taskId, taskAttrs){
        var user = authenticatedUser();

        var whitelist = ['tasklistId','done','text','dueAt','assigneeId','tags','description'];
        var searchCondition = _.chain(whitelist).map(function(o){return [o,1];}).object().value();

        var oldValue = Tasks.findOne(taskId, searchCondition);
        var newValue = _.pick(taskAttrs, whitelist);

        Tasks.update({_id: taskId}, {$set: newValue});

        var actionObject = buildChangeObject(oldValue, newValue);
        logTaskActivity('changeTask', taskId, user, actionObject);
    },


    commentTask: function(taskId, commentBody) {
        var user = authenticatedUser();

        commentId = commentIt(taskId, commentBody);
        commentObject = _.clone(Comments.findOne(commentId));

        logTaskActivity("commentTask", taskId, user,commentObject)
    }
})

//#Uploads = new CollectionFS("uploads");