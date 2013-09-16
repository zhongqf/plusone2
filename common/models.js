// Lists -- {name: String}
Tasklists = new Meteor.Collection("tasklists");

// Todos -- {text: String,
//           done: Boolean,
//           tags: [String, ...],
//           list_id: String,
//           timestamp: Number}
Tasks = new Meteor.Collection("tasks");

Projects = new Meteor.Collection("projects");

//Uploads = new CollectionFS("uploads");