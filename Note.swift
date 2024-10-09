//
//  Note.swift
//  StickyNotes
//
//  Created by Alexander Bascevan on 2024-10-09.
//

import Foundation

// Model class representing a single note
class Note: Identifiable, ObservableObject, Hashable {
    // Unique identifier for the note
    let id: UUID
    
    // Published properties to allow UI to react to changes
    @Published var title: String
    @Published var content: String
    
    // Initializer to set up a new note with optional title and mandatory content
    init(title: String = "", content: String) {
        self.id = UUID() // Generate a unique ID
        self.title = title // Set the note's title
        self.content = content // Set the note's content
    }
    
    // Hashable protocol requirement: checks equality based on ID
    static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.id == rhs.id // Two notes are equal if their IDs match
    }
    
    // Hashable protocol requirement: provides a hash value for the note
    func hash(into hasher: inout Hasher) {
        hasher.combine(id) // Combine the ID into the hasher
    }
}
