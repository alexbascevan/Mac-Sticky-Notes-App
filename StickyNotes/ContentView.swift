import SwiftUI

struct ContentView: View {
    @State private var newNoteContent = ""
    @ObservedObject var viewModel = NotesViewModel()
    @State private var selectedNote: Note? // To hold the currently selected note

    var body: some View {
        NavigationView {
            HStack { // Use HStack for side-by-side layout
                List(viewModel.notes, id: \.id, selection: $selectedNote) { note in
                    Text(note.content)
                        .onTapGesture {
                            selectedNote = note // Set the selected note when tapped
                            newNoteContent = note.content // Load content into the text field
                        }
                }
                .frame(minWidth: 200) // Set a minimum width for the side menu

                VStack { // Right section for the active note
                    // Always display the note editor
                    TextEditor(text: $newNoteContent)
                        .padding()
                        .border(Color.gray, width: 1)
                        .foregroundColor(viewModel.notes.isEmpty && selectedNote == nil ? .gray : .black) // Indicate if empty
                        .opacity(viewModel.notes.isEmpty && selectedNote == nil ? 0.6 : 1) // Indicate if empty

                    // Display a message if no note is selected and notes exist
                    if selectedNote == nil && !viewModel.notes.isEmpty {
                        Text("Select a note to view its content")
                            .padding()
                            .foregroundColor(.gray) // Optional: to indicate it's informational
                    }

                    Button(action: {
                        if let selectedNote = selectedNote, !newNoteContent.isEmpty {
                            // Update the selected note's content
                            selectedNote.content = newNoteContent
                        } else if !newNoteContent.isEmpty {
                            // Add a new note if no note is selected
                            viewModel.addNote(content: newNoteContent)
                        }
                        // Clear the text area after saving
                        newNoteContent = ""
                    }) {
                        Text("Save Note")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity) // Make this fill the remaining space
            }
            .navigationTitle("Sticky Notes")
        }
        .onAppear {
            // Load the last saved note if there is one
            if let lastNote = viewModel.notes.last {
                selectedNote = lastNote
                newNoteContent = lastNote.content
            } else {
                newNoteContent = "" // Clear the text field if there are no notes
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
