//
//  NotesListView.swift
//  AppSync
//
//  Created by Yaseen Sadat on 2025-03-18.
//

import SwiftUI
import AppSyncCore  // New: Import the package to access Note, Folder, and FirestoreService

/// A view for displaying and managing notes within a specific folder.
///
/// This view displays a list of notes associated with the given folder, allows users to add new notes,
/// edit existing ones, and share a note using the native iOS share sheet.
struct NotesListView: View {
    /// The folder whose notes are being displayed.
    let folder: Folder
    /// An observed instance of AuthService for handling user authentication.
    @ObservedObject var authService: AuthService
    /// An observed instance of FirestoreService for fetching and managing notes.
    @ObservedObject var firestoreService = FirestoreService()
    
    // MARK: - State Properties for Adding Notes
    
    /// The title for a new note entered by the user.
    @State private var newTitle: String = ""
    /// The content for a new note entered by the user.
    @State private var newContent: String = ""
    
    // MARK: - State Properties for Editing and Sharing Notes
    
    /// The note currently selected for editing.
    @State private var noteToEdit: Note? = nil
    /// The note currently selected for sharing.
    @State private var noteToShare: Note? = nil
    /// The updated title used when editing a note.
    @State private var editedTitle: String = ""
    /// The updated content used when editing a note.
    @State private var editedContent: String = ""
    
    /// The view's content and behavior.
    var body: some View {
        VStack {
            // List of notes with swipe actions for editing, sharing, and deleting.
            List {
                ForEach(firestoreService.notes) { note in
                    VStack(alignment: .leading) {
                        Text(note.title)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text(note.content)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .swipeActions(edge: .trailing) {
                        // Delete action for the note.
                        Button(role: .destructive) {
                            firestoreService.deleteNote(note, fromFolder: folder)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .swipeActions(edge: .leading) {
                        // Edit action for the note.
                        Button {
                            noteToEdit = note
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.blue)
                        
                        // Share action for the note.
                        Button {
                            noteToShare = note
                        } label: {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                        .tint(.green)
                    }
                }
            }
            .listStyle(PlainListStyle())
            .onAppear {
                // Fetch notes for the given folder when the view appears.
                firestoreService.fetchNotes(inFolder: folder)
            }
            
            // UI for adding a new note.
            VStack(spacing: 15) {
                TextField("Note Title", text: $newTitle)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                
                TextField("Note Content", text: $newContent)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                
                Button(action: {
                    // Add a new note if title and content are not empty.
                    if !newTitle.isEmpty && !newContent.isEmpty {
                        firestoreService.addNote(title: newTitle, content: newContent, toFolder: folder)
                        newTitle = ""
                        newContent = ""
                    }
                }) {
                    Text("Add Note")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .navigationTitle(folder.name)
        // Sheet for editing a note.
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
                                                   timestamp: note.timestamp)
                            firestoreService.updateNote(updatedNote, inFolder: folder)
                            noteToEdit = nil
                        }
                    }
                }
            }
        }
        // Sheet for sharing a note using the native iOS share sheet.
        .sheet(item: $noteToShare) { note in
            ShareSheet(activityItems: [note.title, note.content])
        }
        .background(Color(.systemGroupedBackground))
    }
}

/// Provides a preview of NotesListView for SwiftUI's canvas.
struct NotesListView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleFolder = Folder(id: "sampleID", name: "Sample Folder")
        NotesListView(folder: sampleFolder, authService: AuthService())
    }
}
