//
//  FirestoreService.swift
//  AppSync
//
//  Created by Yaseen Sadat on 2025-03-18.
//

import Foundation
import Firebase
import FirebaseFirestore
import AppSyncCore

/// A service class for managing Firestore operations (notes, folders) in your main Xcode target.
class FirestoreService: ObservableObject {
    
    // MARK: - Published Properties
    
    /// An array of notes fetched from the top-level notes collection or folder-based notes.
    @Published var notes: [Note] = []
    /// An array of folders fetched from the folders collection.
    @Published var folders: [Folder] = []

    // MARK: - Firestore References
    
    /// The Firestore database instance.
    private let db = Firestore.firestore()
    /// The name of the top-level notes collection.
    private let collectionName = "notes"
    /// The name of the folders collection.
    private let foldersCollection = "folders"

    // MARK: - Top-Level Notes (Optional)
    // These methods let you store notes in a single, global "notes" collection at the top level of Firestore.

    /// Fetches top-level notes from Firestore and listens for real-time updates.
    func fetchNotes() {
        db.collection(collectionName)
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching top-level notes: \(error)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    self.notes = []
                    return
                }

                self.notes = documents.compactMap { doc in
                    var data = doc.data()
                    // Convert Firestore Timestamp to Date if needed
                    if let timestampObj = data["timestamp"] as? Timestamp {
                        data["timestamp"] = timestampObj.dateValue()
                    }
                    return Note(document: data, documentID: doc.documentID)
                }
            }
    }

    /// Adds a new note with the given title and content to the top-level notes collection.
    ///
    /// - Parameters:
    ///   - title: The title of the note.
    ///   - content: The content of the note.
    func addNote(title: String, content: String) {
        let newNote = Note(id: "", title: title, content: content, timestamp: Date())
        let noteData = newNote.toDictionary()

        db.collection(collectionName).addDocument(data: noteData) { error in
            if let error = error {
                print("Error adding note to top-level collection: \(error)")
            }
        }
    }

    /// Updates an existing note in the top-level notes collection.
    ///
    /// - Parameter note: The note to update.
    func updateNote(note: Note) {
        let noteData = note.toDictionary()
        db.collection(collectionName)
            .document(note.id)
            .setData(noteData) { error in
                if let error = error {
                    print("Error updating note in top-level collection: \(error)")
                }
            }
    }

    /// Deletes a note from the top-level notes collection.
    ///
    /// - Parameter note: The note to delete.
    func deleteNote(note: Note) {
        db.collection(collectionName)
            .document(note.id)
            .delete { error in
                if let error = error {
                    print("Error deleting note from top-level collection: \(error)")
                }
            }
    }

    // MARK: - User-Specific Folders

    /// Fetches folders that belong to a specific user.
    ///
    /// - Parameter userID: The UID of the user whose folders should be fetched.
    func fetchFolders(forUser userID: String) {
        db.collection(foldersCollection)
            .whereField("uid", isEqualTo: userID)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching user-specific folders: \(error)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    self.folders = []
                    return
                }

                self.folders = documents.compactMap { doc in
                    let data = doc.data()
                    return Folder(document: data, documentID: doc.documentID)
                }
            }
    }

    /// Adds a new folder with the specified name for a given user.
    ///
    /// - Parameters:
    ///   - name: The name of the new folder.
    ///   - userID: The UID of the user for whom the folder is being added.
    func addFolder(name: String, forUser userID: String) {
        let folderData: [String: Any] = [
            "uid": userID,
            "name": name
        ]

        db.collection(foldersCollection).addDocument(data: folderData) { error in
            if let error = error {
                print("Error adding folder for user: \(error)")
            }
        }
    }

    /// Deletes a folder from Firestore.
    ///
    /// - Parameter folder: The folder to delete.
    func deleteFolder(folder: Folder) {
        db.collection(foldersCollection)
            .document(folder.id)
            .delete { error in
                if let error = error {
                    print("Error deleting folder: \(error)")
                }
            }
    }

    // MARK: - Folder-Based Notes

    /// Fetches notes from a specific folder and listens for real-time updates.
    ///
    /// - Parameter folder: The folder from which to fetch notes.
    func fetchNotes(inFolder folder: Folder) {
        db.collection(foldersCollection)
            .document(folder.id)
            .collection(collectionName) // "notes"
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching notes in folder: \(error)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    self.notes = []
                    return
                }

                self.notes = documents.compactMap { doc in
                    var data = doc.data()
                    if let timestampObj = data["timestamp"] as? Timestamp {
                        data["timestamp"] = timestampObj.dateValue()
                    }
                    return Note(document: data, documentID: doc.documentID)
                }
            }
    }

    /// Adds a new note with the given title and content to a specific folder.
    ///
    /// - Parameters:
    ///   - title: The title of the note.
    ///   - content: The content of the note.
    ///   - folder: The folder to which the note should be added.
    func addNote(title: String, content: String, toFolder folder: Folder) {
        let newNote = Note(id: "", title: title, content: content, timestamp: Date())
        let noteData = newNote.toDictionary()

        db.collection(foldersCollection)
            .document(folder.id)
            .collection(collectionName)
            .addDocument(data: noteData) { error in
                if let error = error {
                    print("Error adding note to folder: \(error)")
                }
            }
    }

    /// Updates an existing note within a specific folder.
    ///
    /// - Parameters:
    ///   - note: The note to update.
    ///   - folder: The folder in which the note exists.
    func updateNote(_ note: Note, inFolder folder: Folder) {
        let noteData = note.toDictionary()
        db.collection(foldersCollection)
            .document(folder.id)
            .collection(collectionName)
            .document(note.id)
            .setData(noteData) { error in
                if let error = error {
                    print("Error updating note in folder: \(error)")
                }
            }
    }

    /// Deletes a note from a specific folder.
    ///
    /// - Parameters:
    ///   - note: The note to delete.
    ///   - folder: The folder from which the note should be deleted.
    func deleteNote(_ note: Note, fromFolder folder: Folder) {
        db.collection(foldersCollection)
            .document(folder.id)
            .collection(collectionName)
            .document(note.id)
            .delete { error in
                if let error = error {
                    print("Error deleting note from folder: \(error)")
                }
            }
    }
}
