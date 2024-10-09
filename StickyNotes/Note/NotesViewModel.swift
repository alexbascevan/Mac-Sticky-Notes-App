//  NotesViewModel.swift
//  StickyNotes
//
//  Created by Alexander Bascevan on 2024-10-09.
//

import Foundation

// ViewModel to manage the list of notes
class NotesViewModel: ObservableObject {
    // Published property to notify views of changes
    @Published var notes: [Note] = [] {
        didSet {
            // Save notes to UserDefaults whenever they change
            saveNotes()
        }
    }
    
    // Initializer to load notes from UserDefaults
    init() {
        loadNotes()
    }
    
    // Function to add a new note with a title and content
    func addNote(title: String, content: String) {
        // Create a new note instance
        let newNote = Note(title: title, content: content)
        // Append the new note to the notes array
        notes.append(newNote)
    }
    
    // Function to delete a note
    func deleteNote(note: Note) {
        if let index = notes.firstIndex(of: note) {
            notes.remove(at: index)
        }
    }

    // Function to save notes to UserDefaults
    private func saveNotes() {
        // Convert notes to data
        if let encoded = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(encoded, forKey: "notes")
        }
    }

    // Function to load notes from UserDefaults
    private func loadNotes() {
        if let data = UserDefaults.standard.data(forKey: "notes"),
           let decoded = try? JSONDecoder().decode([Note].self, from: data) {
            notes = decoded
        }
    }
}
