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
    @Published var notes: [Note] = []      // For storing top-level notes or folder-based notes
    @Published var folders: [Folder] = []  // For storing folder data

    // MARK: - Firestore References
    private let db = Firestore.firestore()
    private let collectionName = "notes"       // Name of the top-level notes collection
    private let foldersCollection = "folders"  // Name of the folders collection

    // MARK: - Top-Level Notes (Optional)
    // These methods let you store notes in a single, global "notes" collection at the top level of Firestore.

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

    func addNote(title: String, content: String) {
        let newNote = Note(id: "", title: title, content: content, timestamp: Date())
        let noteData = newNote.toDictionary()

        db.collection(collectionName).addDocument(data: noteData) { error in
            if let error = error {
                print("Error adding note to top-level collection: \(error)")
            }
        }
    }

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

    /// Fetch only the folders that belong to a specific user (by UID).
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

    /// Add a folder with the given name for a specific user (by UID).
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
