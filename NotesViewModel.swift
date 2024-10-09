//
//  NotesViewModel.swift
//  StickyNotes
//
//  Created by Alexander Bascevan on 2024-10-09.
//

import Foundation

// ViewModel to manage the list of notes
class NotesViewModel: ObservableObject {
    // Published property to notify views of changes
    @Published var notes: [Note] = []
    
    // Function to add a new note with a title and content
    func addNote(title: String, content: String) {
        // Create a new note instance
        let newNote = Note(title: title, content: content)
        // Append the new note to the notes array
        notes.append(newNote)
    }
}
