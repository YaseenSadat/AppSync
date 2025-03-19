//
//  NotesListView.swift
//  AppSync
//
//  Created by Yaseen Sadat on 2025-03-18.
//

import SwiftUI
import AppSyncCore  // New: Import the package to access Note, Folder, and FirestoreService

struct NotesListView: View {
    let folder: Folder
    @ObservedObject var authService: AuthService
    @ObservedObject var firestoreService = FirestoreService()
    
    @State private var newTitle: String = ""
    @State private var newContent: String = ""
    
    @State private var noteToEdit: Note? = nil
    @State private var editedTitle: String = ""
    @State private var editedContent: String = ""
    
    var body: some View {
        VStack {
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
                        Button(role: .destructive) {
                            firestoreService.deleteNote(note, fromFolder: folder)
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
                firestoreService.fetchNotes(inFolder: folder)
            }
            
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
                            let updatedNote = Note(id: note.id, title: editedTitle, content: editedContent, timestamp: note.timestamp)
                            firestoreService.updateNote(updatedNote, inFolder: folder)
                            noteToEdit = nil
                        }
                    }
                }
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}

struct NotesListView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleFolder = Folder(id: "sampleID", name: "Sample Folder")
        NotesListView(folder: sampleFolder, authService: AuthService())
    }
}
