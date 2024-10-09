import SwiftUI
import WidgetKit
struct MainScreenView: View {
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

    // State variable to keep track of the note to be displayed in the widget
    @State private var widgetNote: Note? = nil // Initialize to nil

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

                // Picker for selecting the note to display in the widget
                Picker("Widget Note:", selection: $widgetNote) {
                    Text("Select a note").tag(nil as Note?) // Add an option to select nothing
                    ForEach(viewModel.notes, id: \.id) { note in
                        Text(note.title.isEmpty ? "Untitled Note" : note.title)
                            .tag(note as Note?) // Tag each note
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .onChange(of: widgetNote) { newValue in
                    saveSelectedNoteToWidget(newValue)
                }
                .padding()

                // List of notes with titles
                List(viewModel.notes.filter { note in
                    searchText.isEmpty || note.title.localizedCaseInsensitiveContains(searchText) || note.content.localizedCaseInsensitiveContains(searchText)
                }
                .sorted(by: { note1, note2 in
                    switch selectedSortOption {
                    case "Title":
                        return note1.title < note2.title
                    default:
                        return note1.id < note2.id
                    }
                }), id: \.id, selection: $selectedNote) { note in
                    VStack(alignment: .leading) {
                        Text(note.title.isEmpty ? "Untitled Note" : note.title)
                            .font(.headline)
                        Text(note.content)
                            .lineLimit(1)
                    }
                    .onTapGesture {
                        selectedNote = note
                        newNoteTitle = note.title
                        newNoteContent = note.content
                    }
                    .contextMenu {
                        Button(action: {
                            viewModel.deleteNote(note: note)
                        }) {
                            Text("Delete Note")
                            Image(systemName: "trash")
                        }
                    }
                }
                .frame(minWidth: 200)
            }

            VStack {
                // Text field for editing the note title
                TextField("Title", text: $newNoteTitle)
                    .padding()
                    .border(Color.gray, width: 1)

                // Text editor for editing the note content
                TextEditor(text: $newNoteContent)
                    .padding()
                    .border(Color.gray, width: 1)
                    .opacity(viewModel.notes.isEmpty && selectedNote == nil ? 0.6 : 1)

                // Button to save the note
                Button(action: {
                    if let selectedNote = selectedNote {
                        selectedNote.title = newNoteTitle.isEmpty ? newNoteContent.split(separator: "\n").first?.description ?? "Untitled Note" : newNoteTitle
                        selectedNote.content = newNoteContent
                    } else if !newNoteContent.isEmpty {
                        let noteTitle = newNoteTitle.isEmpty ? newNoteContent.split(separator: "\n").first?.description ?? "Untitled Note" : newNoteTitle
                        viewModel.addNote(title: noteTitle, content: newNoteContent)
                    }

                    // Clear the editor for a new note
                    selectedNote = nil
                    newNoteTitle = ""
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
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("Sticky Notes")
        .onAppear {
            // Load the last saved note if available when the view appears
            if let lastNote = viewModel.notes.last {
                selectedNote = lastNote
                newNoteTitle = lastNote.title
                newNoteContent = lastNote.content
            }
            // Load the previously selected widget note if available
            loadSelectedNoteForWidget()
        }
    }

    private func saveSelectedNoteToWidget(_ note: Note?) {
        guard let note = note else { return }
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(note) {
            UserDefaults.standard.set(encoded, forKey: "selectedNote")
            print("Saved selected note: \(note.title)") // Debugging line
        } else {
            print("Failed to encode note") // Debugging line
        }
    }


    private func fetchSelectedNote() -> Note {
        if let data = UserDefaults.standard.data(forKey: "selectedNote") {
            let decoder = JSONDecoder()
            if let note = try? decoder.decode(Note.self, from: data) {
                print("Fetched note: \(note.title), \(note.content)") // Debugging line
                return note
            }
        }
        print("Using default note") // Debugging line
        return Note(title: "Default Note", content: "This note is displayed by default.")
    }



    private func loadSelectedNoteForWidget() {
        if let data = UserDefaults.standard.data(forKey: "selectedNote") {
            let decoder = JSONDecoder()
            if let note = try? decoder.decode(Note.self, from: data) {
                widgetNote = note
            }
        }
    }
}
