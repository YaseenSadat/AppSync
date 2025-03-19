//
//  Note.swift
//  AppSync
//
//  Created by Yaseen Sadat on 2025-03-18.
//

import Foundation
import FirebaseFirestore

/// A public struct so the main app can use it
public struct Note: Identifiable {
    /// Public properties to be accessed from outside the package
    public let id: String
    public let title: String
    public let content: String
    public let timestamp: Date

    // MARK: - Primary Initializer
    /// Public initializer if the main app needs to create notes directly
    public init(id: String, title: String, content: String, timestamp: Date = Date()) {
        self.id = id
        self.title = title
        self.content = content
        self.timestamp = timestamp
    }

    // MARK: - Firestore Snapshot Initializer
    /// Public failable initializer to parse a Firestore document
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
    /// Public method to convert a Note into a dictionary for Firestore
    public func toDictionary() -> [String: Any] {
        return [
            "title": title,
            "content": content,
            "timestamp": timestamp
        ]
    }
}
