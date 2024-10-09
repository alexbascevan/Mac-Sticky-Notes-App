//  ContentView.swift
//  StickyNotes
//
//  Created by Alexander Bascevan on 2024-10-09.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MainScreenView() // Use the new MainScreenView
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            // Previewing the widget entry with a sample note
            StickyNotesWidgetEntryView(entry: SimpleEntry(date: Date(), note: Note(title: "Untitled Note", content: "Sample Content")))
        }
    }
}
