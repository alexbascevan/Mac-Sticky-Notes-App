//  StickyNotesWidget.swift
//  StickyNotesWidget
//
//  Created by Alexander Bascevan on 2024-10-09.
//

import WidgetKit
import SwiftUI

// Define the SimpleEntry struct for the widget's timeline
struct SimpleEntry: TimelineEntry {
    let date: Date
    let note: Note // Store the selected note
}

// Create a provider for the widget
struct Provider: TimelineProvider {
    // Placeholder for the widget
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), note: Note(title: "Placeholder", content: "This is a placeholder note."))
    }

    // Snapshot of the widget to provide a quick view of the current state
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), note: fetchSelectedNote())
        completion(entry)
    }

    // Generate the timeline for the widget
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let currentDate = Date() // Get the current date
        let entry = SimpleEntry(date: currentDate, note: fetchSelectedNote()) // Create an entry for the timeline
        let timeline = Timeline(entries: [entry], policy: .atEnd) // Set the policy to at end
        completion(timeline) // Return the timeline
    }

    // Function to fetch the selected note from UserDefaults or your persistence layer
    private func fetchSelectedNote() -> Note {
        // Attempt to retrieve the note from UserDefaults
        if let data = UserDefaults.standard.data(forKey: "selectedNote") {
            let decoder = JSONDecoder()
            if let note = try? decoder.decode(Note.self, from: data) {
                return note // Return the decoded note
            }
        }
        // Return a default note if no selected note is found
        return Note(title: "Default Note", content: "This note is displayed by default.")
    }
}

// Widget view to display the note
struct StickyNotesWidgetEntryView: View {
    var entry: SimpleEntry // The entry containing the note data

    var body: some View {
        VStack(alignment: .leading) {
            // Display the title of the note, or "Untitled Note" if the title is empty
            Text(entry.note.title.isEmpty ? "Untitled Note" : entry.note.title)
                .font(.headline) // Set the font style to headline
                .foregroundColor(.white) // Change text color to white

            // Display the content of the note, limiting to 3 lines
            Text(entry.note.content)
                .lineLimit(3) // Limit to 3 lines
                .foregroundColor(.white) // Change text color to white
        }
        .padding()
        .background(Color.black) // Change the background color of the widget to black
        .cornerRadius(10) // Apply corner radius for rounded corners
        .shadow(radius: 5) // Apply shadow for depth effect
    }
}

// Main Widget structure
struct StickyNotesWidget: Widget {
    let kind: String = "StickyNotesWidget" // Define the widget kind

    var body: some WidgetConfiguration {
        // Configure the widget using StaticConfiguration
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            StickyNotesWidgetEntryView(entry: entry) // Pass the entry to the widget view
                .containerBackground(.fill.tertiary, for: .widget) // Set the background for the widget container
        }
        .configurationDisplayName("Sticky Notes Widget") // Display name for the widget
        .description("Display your selected note on the home screen.") // Description of the widget
    }
}
// Preview structure for the widget
struct StickyNotesWidgetEntryView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a sample note with valid data
        let sampleNote = Note(title: "Sample Note", content: "This is a sample note content for the widget preview.")
        
        // Create a sample entry using the sample note
        let sampleEntry = SimpleEntry(date: Date(), note: sampleNote)

        // Provide the sample entry for preview
        StickyNotesWidgetEntryView(entry: sampleEntry)
            .previewContext(WidgetPreviewContext(family: .systemMedium)) // Use .systemMedium or .systemLarge for larger sizes
            .previewDisplayName("Medium Size Widget Preview") // Optional: provide a display name for clarity
    }
}
