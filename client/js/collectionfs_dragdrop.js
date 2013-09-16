uploadFiles = function(files, collectionFS,meta) {
	var result = [];
	if (files.length)
	    for (var i = 0, f; f = files[i]; i++) {
	      result.pop( collectionFS.storeFile(f, meta ) );
	    }
	return result; // Return array of file id's
};

dropfile = function(elementId, collectionFS, meta) {
	var dropbox = document.getElementById(elementId);

	// Prevent default drag and drop 
	function noopHandler(evt) {
	  evt.stopPropagation();
	  evt.preventDefault();
	} 

	// Handle file dropped
	function dropped(evt) {
		noopHandler(evt);		
		uploadFiles(evt.dataTransfer.files, collectionFS, meta);
	}

	if (dropbox) {
		// init event handlers
		dropbox.addEventListener("dragenter", noopHandler, false);
		dropbox.addEventListener("dragexit", noopHandler, false);
		dropbox.addEventListener("dragover", noopHandler, false);
		dropbox.addEventListener("drop", dropped, false);
	}

	return dropbox;	
};