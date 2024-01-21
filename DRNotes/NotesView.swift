//
//  NotesView.swift
//  DRNotes
//
//  Created by doremin on 1/22/24.
//

import SwiftUI
import SwiftData

struct NotesView: View {
  var category: String?
  var allCategories: [NoteCategory]
  @Query private var notes: [Note]
  @Environment(\.modelContext) private var context
  
  init(category: String?, allCategories: [NoteCategory]) {
    self.category = category
    self.allCategories = allCategories
    let predicate = #Predicate<Note> {
      return $0.category?.title == category
    }
    
    let likedPredicate = #Predicate<Note> {
      return $0.isLiked
    }
    
    let finalPredicate: Predicate<Note>? = switch category {
    case "All Notes": nil
    case "Liked Notes": likedPredicate
    default: predicate
    }
    
    _notes = Query(filter: finalPredicate, sort: [], animation: .snappy)
  }
  
  @FocusState private var isKeyboardEnabled: Bool
  
  var body: some View {
    GeometryReader { proxy in
      let size = proxy.size
      let width = size.width
      
      let rowCount = max(Int(width / 250), 1)
      ScrollView(.vertical) {
        LazyVGrid(
          columns: Array(
            repeating: GridItem(spacing: 10),
            count: rowCount)) 
        {
          ForEach(notes) { note in
            NoteCardView(note: note, isKeyboardEnabled: $isKeyboardEnabled)
              .contextMenu {
                Button(note.isLiked ? "Remove from Liked" : "Move to Like") {
                  note.isLiked.toggle()
                }
                
                Menu {
                  ForEach(allCategories) { category in
                    Button {
                      note.category = category
                    } label: {
                      HStack(spacing: 5) {
                        Text(category.title)
                      }
                    }
                  }
                  
                  Button("Remove from Categories") {
                    note.category = nil
                  }
                  
                } label: {
                  Text("Category")
                }
                
                Button("Delete", role: .destructive) {
                  context.delete(note)
                }
              }
          }
          .padding(12)
        }
      }
      .onTapGesture {
        isKeyboardEnabled = false
      }
    }
  }
}

struct NoteCardView: View {
  @Bindable var note: Note
  var isKeyboardEnabled: FocusState<Bool>.Binding
  
  var body: some View {
    TextEditor(text: $note.content)
      .focused(isKeyboardEnabled)
      .overlay(alignment: .leading) {
        Text("Finish Work")
          .foregroundStyle(.gray)
          .padding(.leading, 5)
          .opacity(note.content.isEmpty ? 1 : 0)
          .allowsHitTesting(false)
      }
      .padding(15)
      .kerning(1.2)
      .scrollContentBackground(.hidden)
      .multilineTextAlignment(.leading)
      .frame(maxWidth: .infinity)
      .background(.gray.opacity(0.15), in: .rect(cornerRadius: 12))
  }
}

#Preview {
  NotesView(category: nil, allCategories: [])
}

