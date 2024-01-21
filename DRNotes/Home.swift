//
//  Home.swift
//  DRNotes
//
//  Created by doremin on 1/22/24.
//

import SwiftUI
import SwiftData

struct Home: View {
  @State private var selectedTag: String?
  @Query(animation: .snappy) private var categories: [NoteCategory]
  
  @Environment(\.modelContext) private var context
  
  @State private var addCategory: Bool = false
  @State private var categoryTitle: String = ""
  @State private var requestedCategory: NoteCategory?
  @State private var deleteRequest: Bool = false
  @State private var renameReqeust: Bool = false
  @State private var isDarkMode: Bool = true
  
  var body: some View {
    NavigationSplitView {
      List(selection: $selectedTag) {
        Text("All Notes")
          .tag("All Notes")
          .foregroundStyle(selectedTag == "All Notes" ? Color.primary : .gray)
        
        Text("Liked Notes")
          .tag("Liked Notes")
          .foregroundStyle(selectedTag == "Liked Notes" ? Color.primary : .gray)
        
        Section {
          ForEach(categories) { category in
            Text(category.title)
              .tag(category.title)
              .foregroundStyle(selectedTag == category.title ? Color.primary : .gray)
              .contextMenu {
                Button("Rename") {
                  categoryTitle = category.title
                  requestedCategory = category
                  renameReqeust = true
                }
                
                Button("Delete") {
                  requestedCategory = category
                  deleteRequest = true
                }
              }
          }
        } header: {
          HStack {
            Text("Categories")
            Button("", systemImage: "plus") {
              addCategory.toggle()
            }
            .tint(.gray)
            .buttonStyle(.plain)
          }
        }
      }
    } detail: {
      NotesView(category: selectedTag, allCategories: categories)
    }
    .navigationTitle(selectedTag ?? "Notes")
    .alert("Add Category", isPresented: $addCategory) {
      TextField("Record Video", text: $categoryTitle)
      
      Button("Cancel", role: .cancel) {
        categoryTitle = ""
        addCategory = false
      }
      
      Button("Add") {
        guard categoryTitle != "" else { return }
        let category = NoteCategory(title: categoryTitle)
        context.insert(category)
        categoryTitle = ""
      }
    }
    .alert("Rename Category", isPresented: $renameReqeust) {
      TextField("rename", text: $categoryTitle)
      
      Button("Cancel", role: .cancel) {
        categoryTitle = ""
        requestedCategory = nil
      }
      
      Button("Rename") {
        guard let category = requestedCategory else { return }
        category.title = categoryTitle
        categoryTitle = ""
        requestedCategory = nil
      }
    }
    .alert("Delete Category", isPresented: $deleteRequest) {
      Button("Cancel", role: .cancel) {
        categoryTitle = ""
        requestedCategory = nil
      }
      
      Button("Delete", role: .destructive) {
        guard let category = requestedCategory else { return }
        context.delete(category)
        categoryTitle = ""
        requestedCategory = nil
      }
    }
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        HStack {
          Button("", systemImage: "plus") {
            let note = Note(content: "")
            context.insert(note)
          }
          
          Button("", systemImage: isDarkMode ? "sun.min" : "moon") {
            isDarkMode.toggle()
          }
          .contentTransition(.symbolEffect(.replace))
        }
      }
    }
    .preferredColorScheme(isDarkMode ? .dark : .light)
  }
}

#Preview {
  Home()
}
