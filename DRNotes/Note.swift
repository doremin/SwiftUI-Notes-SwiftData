//
//  Note.swift
//  DRNotes
//
//  Created by doremin on 1/22/24.
//

import SwiftData

@Model
class Note {
  var content: String
  var isLiked: Bool
  var category: NoteCategory?
  
  init(
    content: String,
    isLiked: Bool = false) {
    self.content = content
    self.isLiked = isLiked
  }
}

@Model
class NoteCategory {
  var title: String
  @Relationship(deleteRule: .cascade, inverse: \Note.category)
  var notes: [Note]?
  
  init(title: String) {
    self.title = title
  }
}
