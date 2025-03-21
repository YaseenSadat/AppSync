//
//  ContentView.swift
//  AppSync
//
//  Created by Yaseen Sadat on 2025-03-18.
//

import SwiftUI
import AppSyncCore  // New: Import the package to access Note and FirestoreService

/// The main view for displaying and managing notes in the AppSync application.
///
/// This view allows users to view a list of existing notes, add new notes, and edit existing ones.
/// Notes are fetched from a Firestore backend through `FirestoreService`.
struct ContentView: View {
    /// An observed instance of FirestoreService that manages fetching, adding, updating, and deleting notes.
    @ObservedObject var firestoreService = FirestoreService()
    
    // MARK: - State Properties for Adding a New Note
    
    /// The title for a new note entered by the user.
    @State private var newTitle: String = ""
    /// The content for a new note entered by the user.
    @State private var newContent: String = ""
    
    // MARK: - State Properties for Editing a Note
    
    /// The note currently selected for editing.
    @State private var noteToEdit: Note? = nil
    /// The updated title when editing a note.
    @State private var editedTitle: String = ""
    /// The updated content when editing a note.
    @State private var editedContent: String = ""
    
    /// The content and behavior of the view.
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
            // Edit Sheet Presentation for editing a note
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

/// Provides a preview of ContentView for SwiftUI's canvas.
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
