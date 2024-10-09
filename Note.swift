import Foundation

class Note: Identifiable, ObservableObject, Hashable {
    let id = UUID() // Unique identifier for each note
    @Published var content: String
    let creationDate: Date

    init(content: String) {
        self.content = content
        self.creationDate = Date()
    }

    // Implementing the Hashable protocol
    static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.id == rhs.id // Compare notes by their unique id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id) // Use the id for hashing
    }
}
