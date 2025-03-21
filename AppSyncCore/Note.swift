//
//  Note.swift
//  AppSync
//
//  Created by Yaseen Sadat on 2025-03-18.
//

import Foundation
import FirebaseFirestore

/// A model representing a note within the AppSync application.
///
/// The `Note` struct conforms to `Identifiable` for easy use in SwiftUI lists and includes methods for
/// initialization from Firestore documents as well as conversion to a Firestore-compatible dictionary.
public struct Note: Identifiable {
    // MARK: - Public Properties
    
    /// A unique identifier for the note.
    public let id: String
    /// The title of the note.
    public let title: String
    /// The content of the note.
    public let content: String
    /// The timestamp indicating when the note was created or last updated.
    public let timestamp: Date

    // MARK: - Primary Initializer
    
    /// Creates a new `Note` instance.
    ///
    /// Use this initializer when creating notes directly within the app.
    ///
    /// - Parameters:
    ///   - id: A unique identifier for the note.
    ///   - title: The title of the note.
    ///   - content: The content of the note.
    ///   - timestamp: The creation or update time for the note. Defaults to the current date.
    public init(id: String, title: String, content: String, timestamp: Date = Date()) {
        self.id = id
        self.title = title
        self.content = content
        self.timestamp = timestamp
    }

    // MARK: - Firestore Snapshot Initializer
    
    /// Initializes a `Note` from a Firestore document.
    ///
    /// Use this failable initializer to parse a Firestore document into a `Note` instance.
    ///
    /// - Parameters:
    ///   - document: A dictionary representing the Firestore document.
    ///   - documentID: The unique identifier of the document.
    /// - Returns: An optional `Note` if the document contains valid data; otherwise, `nil`.
    public init?(document: [String: Any], documentID: String) {
        guard let title = document["title"] as? String,
              let content = document["content"] as? String,
              let timestamp = document["timestamp"] as? Date
        else {
            return nil
        }
        self.id = documentID
        self.title = title
        self.content = content
        self.timestamp = timestamp
    }

    // MARK: - Convert to Firestore Dictionary
    
    /// Converts the `Note` instance into a dictionary suitable for storing in Firestore.
    ///
    /// - Returns: A dictionary containing the note's data.
    public func toDictionary() -> [String: Any] {
        return [
            "title": title,
            "content": content,
            "timestamp": timestamp
        ]
    }
}
