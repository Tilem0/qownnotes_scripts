import QtQml 2.0
import QOwnNotesTypes 1.0

/**
 * Zettelkasten note creation script with custom template
 */
QtObject {
    /**
     * Initializes the custom actions
     */
    function init() {
        script.registerCustomAction("createZettelkastenNote", "Create Zettelkasten note", "Zettelkasten note", "task-new");
    }

    /**
     * Generates a random 6-character alphanumeric ID
     */
    function generateShortId() {
        var chars = "abcdefghijklmnopqrstuvwxyz0123456789";
        var id = "";
        for (var i = 0; i < 6; i++) {
            id += chars.charAt(Math.floor(Math.random() * chars.length));
        }
        return id;
    }

    /**
     * Formats the current date as YYYY-MM-DD
     */
    function getCurrentDate() {
        var date = new Date();
        var year = date.getFullYear();
        var month = ("0" + (date.getMonth() + 1)).slice(-2);
        var day = ("0" + date.getDate()).slice(-2);
        return year + "-" + month + "-" + day;
    }

    /**
     * This function is invoked when a custom action is triggered
     * 
     * @param identifier string the identifier defined in registerCustomAction
     */
    function customActionInvoked(identifier) {
        switch (identifier) {
            case "createZettelkastenNote":
                // Get the note name from the user (via new-note-namer script or dialog)
                var noteTitle = script.inputDialogGetText(
                    "Zettelkasten Note", 
                    "Enter note title:", 
                    ""
                );
                
                if (noteTitle === "") {
                    script.log("Note creation cancelled - no title provided");
                    return;
                }

                // Generate unique ID and current date
                var noteId = generateShortId();
                var currentDate = getCurrentDate();

                // Create the note content with the template
                var noteContent = "---\n";
                noteContent += "title: " + noteTitle + "\n";
                noteContent += "id: " + noteId + "\n";
                noteContent += "date: " + currentDate + "\n";
                noteContent += "folgezettel: \n";
                noteContent += "tags: \n";
                noteContent += "links:  \n";
                noteContent += "---\n\n";
                noteContent += "NOTE\n";
                noteContent += "---\n";
                noteContent += "*refs*\n";

                // Jump to the Zettelbox subfolder first
                script.jumpToNoteSubFolder("Zettelbox");
                
                // Create the note with the title as filename
                script.createNote(noteTitle + "\n" + noteContent);
                
                script.log("Created Zettelkasten note: " + noteTitle + " with ID: " + noteId);
                break;
        }
    }
}
