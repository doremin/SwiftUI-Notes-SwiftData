//
//  DRNotesApp.swift
//  DRNotes
//
//  Created by doremin on 1/22/24.
//

import SwiftData
import SwiftUI

@main
struct DRNotesApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
        .frame(minWidth: 320, minHeight: 400)
    }
    .windowResizability(.contentSize)
    .modelContainer(for: [Note.self, NoteCategory.self])
  }
}
