//
//  ContentView.swift
//  AppSync
//
//  Created by Yaseen Sadat on 2025-03-18.
//

import SwiftUI
import AppSyncCore  // New: Import the package to access Note and FirestoreService

struct ContentView: View {
    @ObservedObject var firestoreService = FirestoreService()
    
    // For adding a new note
    @State private var newTitle: String = ""
    @State private var newContent: String = ""
    
    // For editing a note
    @State private var noteToEdit: Note? = nil
    @State private var editedTitle: String = ""
    @State private var editedContent: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                // List of existing notes with swipe actions for Edit and Delete
                List {
                    ForEach(firestoreService.notes) { note in
                        VStack(alignment: .leading) {
                            Text(note.title)
                                .font(.headline)
                            Text(note.content)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                firestoreService.deleteNote(note: note)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                noteToEdit = note
                                editedTitle = note.title
                                editedContent = note.content
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .onAppear {
                    firestoreService.fetchNotes()
                }
                
                Divider()
                
                // Simple UI for adding a new note
                TextField("Note Title", text: $newTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                TextField("Note Content", text: $newContent)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button(action: {
                    if !newTitle.isEmpty && !newContent.isEmpty {
                        firestoreService.addNote(title: newTitle, content: newContent)
                        newTitle = ""
                        newContent = ""
                    }
                }) {
                    Text("Add Note")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.bottom)
            }
            .navigationTitle("My Notes")
            // Edit Sheet Presentation
            .sheet(item: $noteToEdit) { note in
                NavigationView {
                    Form {
                        Section(header: Text("Edit Note")) {
                            TextField("Title", text: $editedTitle)
                            TextField("Content", text: $editedContent)
                        }
                    }
                    .navigationTitle("Edit Note")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                noteToEdit = nil
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                let updatedNote = Note(id: note.id,
                                                       title: editedTitle,
                                                       content: editedContent,
                                                       timestamp: Date())
                                firestoreService.updateNote(note: updatedNote)
                                noteToEdit = nil
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
