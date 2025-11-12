import QtQml 2.0
import QOwnNotesTypes 1.0

Script {
    function init() {
        // Custom Actions registrieren
        script.registerCustomAction("createPrompt", "Prompt Template", "Templates", "edit-paste");
        script.registerCustomAction("createJournal", "Journal Template", "Templates", "view-calendar"); 
        script.registerCustomAction("createStudy", "Study Template", "Templates", "view-media-notes");
        script.registerCustomAction("createMeeting", "Meeting Template", "Templates", "view-calendar-day");
        script.registerCustomAction("createBookNote", "Book Note Template", "Templates", "documentation");
        
        script.log("Templates Skript initialisiert");
    }
    
    function customActionInvoked(identifier) {
        script.log("Template Action: " + identifier);
        
        switch(identifier) {
            case "createPrompt":
                createPromptNote();
                break;
            case "createJournal":
                createJournalNote();
                break;
            case "createStudy":
                createStudyNote();
                break;
            case "createMeeting":
                createMeetingNote();
                break;
            case "createBookNote":
                createBookNote();
                break;
        }
    }
    
    function generateShortId() {
        var chars = "abcdefghijklmnopqrstuvwxyz0123456789";
        var id = "";
        for (var i = 0; i < 6; i++) {
            id += chars.charAt(Math.floor(Math.random() * chars.length));
        }
        return id;
    }
    
    function getCurrentDate() {
        var date = new Date();
        var year = date.getFullYear();
        var month = ("0" + (date.getMonth() + 1)).slice(-2);
        var day = ("0" + date.getDate()).slice(-2);
        return year + "-" + month + "-" + day;
    }
    
    function createPromptNote() {
        // Benutzereingaben abfragen
        var promptText = script.inputDialogGetText(
            "Prompt eingeben", 
            "Gib den Prompt-Text ein:", 
            ""
        );
        
        if (promptText === "") {
            script.log("Prompt-Erstellung abgebrochen");
            return;
        }
        
        var exampleOutput = script.inputDialogGetText(
            "Beispielausgabe eingeben", 
            "Gib eine Beispielausgabe ein (optional):", 
            ""
        );
        
        var category = script.inputDialogGetText(
            "Kategorie", 
            "Kategorie eingeben (z.B. 'coding', 'writing', 'analysis'):", 
            ""
        );
        
        var model = script.inputDialogGetText(
            "AI Model", 
            "Welches Model? (z.B. 'gpt-4', 'claude-3', 'gemini'):", 
            ""
        );
        
        var noteId = generateShortId();
        var currentDate = getCurrentDate();
        
        var content = "---\n";
        content += "type: prompt\n";
        content += "id: " + noteId + "\n";
        content += "date: " + currentDate + "\n";
        content += "category: " + category + "\n";
        content += "rating: \n";
        content += "tags: [prompt]\n";
        content += "model: " + model + "\n";
        content += "---\n\n";
        content += "*Prompt:*\n";
        content += "```\n";
        content += promptText + "\n";
        content += "```\n\n";
        content += "## Kontext:\n\n";
        
        if (exampleOutput !== "") {
            content += "### Beispielausgabe:\n\n";
            content += "```\n";
            content += exampleOutput + "\n";
            content += "```\n\n";
        } else {
            content += "### Beispielausgabe:\n\n";
            content += "```\n\n";
            content += "```\n\n";
        }
        
        content += "## Notizen:\n\n";
        
        script.createNote(content);
        script.log("Prompt Template erstellt mit ID: " + noteId);
    }
    
    function createJournalNote() {
        var today = getCurrentDate();
        var noteId = generateShortId();
        
        // Optionale Stimmungsabfrage
        var mood = script.inputDialogGetText(
            "Stimmung", 
            "Wie fühlst du dich heute? (optional)", 
            ""
        );
        
        var content = "---\n";
        content += "type: journal\n";
        content += "id: " + noteId + "\n";
        content += "date: " + today + "\n";
        content += "mood: " + mood + "\n";
        content += "tags: [journal]\n";
        content += "---\n\n";
        content += "# Journal " + new Date().toLocaleDateString('de-DE') + "\n\n";
        content += "## Highlights:\n\n";
        content += "## Gelernt:\n\n";
        content += "## Gedanken:\n\n";
        content += "## To-Do für morgen:\n\n";
        
        script.createNote(content);
        script.log("Journal Template erstellt mit ID: " + noteId);
    }
    
    function createStudyNote() {
        // Kursauswahl
        var courses = ["datingseminar", "ml", "gambling", "integrale", "wissarbeiten"];
        var courseChoice = script.inputDialogGetItem(
            "Kurs auswählen",
            "Wähle den Kurs:",
            courses,
            0,
            false
        );
        
        if (courseChoice === "") {
            script.log("Study Note Erstellung abgebrochen");
            return;
        }
        
        var subject = script.inputDialogGetText(
            "Thema", 
            "Welches Thema/Fach?", 
            ""
        );
        
        if (subject === "") {
            script.log("Study Note Erstellung abgebrochen");
            return;
        }
        
        var source = script.inputDialogGetText(
            "Quelle", 
            "Quelle (Buch, Kurs, Video, etc.):", 
            ""
        );
        
        var noteId = generateShortId();
        var currentDate = getCurrentDate();
        
        var content = "---\n";
        content += "type: study\n";
        content += "id: " + noteId + "\n";
        content += "date: " + currentDate + "\n";
        content += "course: " + courseChoice + "\n";
        content += "subject: " + subject + "\n";
        content += "source: " + source + "\n";
        content += "tags: [study, " + courseChoice + ", " + subject.toLowerCase() + "]\n";
        content += "---\n\n";
        content += "# " + subject + "\n\n";
        content += "## Kernkonzepte:\n\n";
        content += "## Wichtige Punkte:\n\n";
        content += "## Beispiele:\n\n";
        content += "## Fragen:\n\n";
        content += "## Zusammenfassung:\n\n";
        
        // Zum entsprechenden Unterordner springen
        var folderPath = "aktuelles semester/" + courseChoice;
        script.jumpToNoteSubFolder(folderPath);
        
        script.createNote(content);
        script.log("Study Template erstellt mit ID: " + noteId + " in " + folderPath);
    }
    
    function createMeetingNote() {
        var meetingTitle = script.inputDialogGetText(
            "Meeting Titel", 
            "Meeting Name/Titel:", 
            ""
        );
        
        if (meetingTitle === "") {
            script.log("Meeting Note Erstellung abgebrochen");
            return;
        }
        
        var participants = script.inputDialogGetText(
            "Teilnehmer", 
            "Teilnehmer (kommagetrennt):", 
            ""
        );
        
        var noteId = generateShortId();
        var currentDate = getCurrentDate();
        var currentTime = new Date().toLocaleTimeString('de-DE', {hour: '2-digit', minute:'2-digit'});
        
        var content = "---\n";
        content += "type: meeting\n";
        content += "id: " + noteId + "\n";
        content += "date: " + currentDate + "\n";
        content += "time: " + currentTime + "\n";
        content += "title: " + meetingTitle + "\n";
        content += "participants: " + participants + "\n";
        content += "tags: [meeting]\n";
        content += "---\n\n";
        content += "# " + meetingTitle + "\n\n";
        content += "**Datum:** " + currentDate + " | **Zeit:** " + currentTime + "\n";
        content += "**Teilnehmer:** " + participants + "\n\n";
        content += "## Agenda:\n\n";
        content += "## Diskussion:\n\n";
        content += "## Entscheidungen:\n\n";
        content += "## Action Items:\n\n";
        content += "- [ ] \n\n";
        content += "## Nächste Schritte:\n\n";
        
        script.createNote(content);
        script.log("Meeting Template erstellt mit ID: " + noteId);
    }
    
    function createBookNote() {
        var bookTitle = script.inputDialogGetText(
            "Buchtitel", 
            "Titel des Buches:", 
            ""
        );
        
        if (bookTitle === "") {
            script.log("Book Note Erstellung abgebrochen");
            return;
        }
        
        var author = script.inputDialogGetText(
            "Autor", 
            "Autor des Buches:", 
            ""
        );
        
        var noteId = generateShortId();
        var currentDate = getCurrentDate();
        
        var content = "---\n";
        content += "type: book\n";
        content += "id: " + noteId + "\n";
        content += "date: " + currentDate + "\n";
        content += "title: " + bookTitle + "\n";
        content += "author: " + author + "\n";
        content += "status: reading\n";
        content += "rating: \n";
        content += "tags: [book]\n";
        content += "---\n\n";
        content += "# " + bookTitle + "\n\n";
        content += "**Autor:** " + author + "\n";
        content += "**Status:** 📖 Am Lesen\n\n";
        content += "## Zusammenfassung:\n\n";
        content += "## Wichtige Zitate:\n\n";
        content += "> \n\n";
        content += "## Kernaussagen:\n\n";
        content += "## Persönliche Gedanken:\n\n";
        content += "## Anwendung:\n\n";
        
        script.createNote(content);
        script.log("Book Note Template erstellt mit ID: " + noteId);
    }
}