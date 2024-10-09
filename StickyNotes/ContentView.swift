//  ContentView.swift
//  StickyNotes
//
//  Created by Alexander Bascevan on 2024-10-09.
//

import SwiftUI

struct ContentView: View {
    // State variables for the note's title and content
    @State private var newNoteTitle = ""
    @State private var newNoteContent = ""
    
    // State variable for the search text
    @State private var searchText = ""
    
    // State variable for sorting options
    @State private var selectedSortOption = "Date Created"
    
    // Observed object to manage the list of notes
    @ObservedObject var viewModel = NotesViewModel()
    
    // State variable to keep track of the currently selected note
    @State private var selectedNote: Note?

    var body: some View {
        HStack {
            // Vertical stack for the left sidebar (notes list and sorting options)
            VStack {
                // Search bar for filtering notes
                TextField("Search", text: $searchText)
                    .padding()
                    .border(Color.gray, width: 1)

                // Picker for sorting options
                Picker("Sort by:", selection: $selectedSortOption) {
                    Text("Date Created").tag("Date Created")
                    Text("Title").tag("Title")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                // List of notes with titles
                List(viewModel.notes.filter { note in
                    // Filter notes by title or content
                    searchText.isEmpty || note.title.localizedCaseInsensitiveContains(searchText) || note.content.localizedCaseInsensitiveContains(searchText)
                }
                .sorted(by: { note1, note2 in
                    // Sort notes based on the selected option
                    switch selectedSortOption {
                    case "Title":
                        return note1.title < note2.title
                    default:
                        return note1.id < note2.id // Sort by date created (ID)
                    }
                }), id: \.id, selection: $selectedNote) { note in
                    VStack(alignment: .leading) {
                        // Display note title; default to "Untitled Note" if empty
                        Text(note.title.isEmpty ? "Untitled Note" : note.title)
                            .font(.headline)
                        // Display note content, limited to one line
                        Text(note.content)
                            .lineLimit(1)
                    }
                    // On tapping a note, update the selected note and fill the editor fields
                    .onTapGesture {
                        selectedNote = note
                        newNoteTitle = note.title
                        newNoteContent = note.content
                    }
                    // Button to delete the note
                    .contextMenu {
                        Button(action: {
                            viewModel.deleteNote(note: note) // Call the delete function in the ViewModel
                        }) {
                            Text("Delete Note")
                            Image(systemName: "trash")
                        }
                    }
                }
                .frame(minWidth: 200) // Minimum width for the note list
            }

            VStack {
                // Text field for editing the note title
                TextField("Title", text: $newNoteTitle)
                    .padding()
                    .border(Color.gray, width: 1)
                    .foregroundColor(.white) // Set text color to white

                // Text editor for editing the note content
                TextEditor(text: $newNoteContent)
                    .padding()
                    .border(Color.gray, width: 1)
                    .foregroundColor(.white) // Set text color to white
                    .opacity(viewModel.notes.isEmpty && selectedNote == nil ? 0.6 : 1) // Dim if empty

                // Button to save the note
                Button(action: {
                    if let selectedNote = selectedNote {
                        // Update the selected note's title and content
                        selectedNote.title = newNoteTitle.isEmpty ? newNoteContent.split(separator: "\n").first?.description ?? "Untitled Note" : newNoteTitle
                        selectedNote.content = newNoteContent
                    } else if !newNoteContent.isEmpty {
                        // Add a new note with the specified title and content
                        let noteTitle = newNoteTitle.isEmpty ? newNoteContent.split(separator: "\n").first?.description ?? "Untitled Note" : newNoteTitle
                        viewModel.addNote(title: noteTitle, content: newNoteContent)
                    }

                    // Clear the editor for a new note
                    selectedNote = nil
                    newNoteTitle = ""
                    newNoteContent = ""
                }) {
                    // Save Note button appearance
                    Text("Save Note")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
            .frame(maxWidth: .infinity) // Allow right section to fill remaining space
        }
        .navigationTitle("Sticky Notes") // Title for the navigation bar
        .onAppear {
            // Load the last saved note if available when the view appears
            if let lastNote = viewModel.notes.last {
                selectedNote = lastNote
                newNoteTitle = lastNote.title
                newNoteContent = lastNote.content
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().navigationTitle("Sticky Notes")
    }
}
