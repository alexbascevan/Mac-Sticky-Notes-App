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

    // Snapshot of the widget
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), note: fetchSelectedNote())
        completion(entry)
    }

    // Generate the timeline for the widget
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let currentDate = Date()
        let entry = SimpleEntry(date: currentDate, note: fetchSelectedNote())
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }

    // Function to fetch the selected note from UserDefaults
    private func fetchSelectedNote() -> Note {
        if let data = UserDefaults.standard.data(forKey: "selectedNote") {
            let decoder = JSONDecoder()
            if let note = try? decoder.decode(Note.self, from: data) {
                print("Fetched note: \(note.title), \(note.content)") // Debugging
                return note
            }
        }
        return Note(title: "Default Note", content: "This note is displayed by default.")
    }

}

// Main Widget structure
struct StickyNotesWidget: Widget {
    let kind: String = "StickyNotesWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            StickyNotesWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Sticky Notes Widget")
        .description("Display your selected note on the home screen.")
    }
}

// Widget view to display the note
struct StickyNotesWidgetEntryView: View {
    var entry: SimpleEntry

    var body: some View {
        VStack(alignment: .leading) {
            Text(entry.note.title.isEmpty ? "Untitled Note" : entry.note.title)
                .font(.headline)
                .foregroundColor(.white)

            Text(entry.note.content)
                .lineLimit(3)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.black)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
