//
//  NotesViewModel.swift
//  StickyNotes
//
//  Created by Alexander Bascevan on 2024-10-09.
//

import Foundation

class NotesViewModel: ObservableObject {
    // Array to hold the list of notes
    @Published var notes: [Note] = []

    // Function to add a new note
    func addNote(content: String) {
        let newNote = Note(content: content)
        notes.append(newNote)
    }

}
