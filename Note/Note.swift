import Foundation

// Model class representing a single note
class Note: Identifiable, ObservableObject, Hashable, Codable {
    // Unique identifier for the note
    let id: UUID
    
    // Properties to allow UI to react to changes
    var title: String
    var content: String
    
    // Add a property to track the note's creation date
    let dateCreated: Date
    
    // Initializer to set up a new note with optional title and mandatory content
    init(title: String = "", content: String, dateCreated: Date = Date()) {
        self.id = UUID() // Generate a unique ID
        self.title = title // Set the note's title
        self.content = content // Set the note's content
        self.dateCreated = dateCreated // Set the creation date (default is the current date)
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
