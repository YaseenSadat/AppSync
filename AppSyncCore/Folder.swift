//
//  Folder.swift
//  AppSync
//
//  Created by Yaseen Sadat on 2025-03-18.
//

import Foundation

/// A model representing a folder used to organize notes.
///
/// The `Folder` struct conforms to `Identifiable` to be easily used in SwiftUI lists,
/// and provides initializers and methods to interface with Firestore data.
public struct Folder: Identifiable {
    /// A unique identifier for the folder.
    public let id: String
    /// The name of the folder.
    public let name: String

    /// Initializes a new Folder with the specified identifier and name.
    ///
    /// - Parameters:
    ///   - id: A unique identifier for the folder.
    ///   - name: The name of the folder.
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }

    /// Initializes a Folder from a Firestore document.
    ///
    /// - Parameters:
    ///   - document: A dictionary representing the Firestore document.
    ///   - documentID: The document's unique identifier.
    /// - Returns: An optional Folder if the document contains a valid name; otherwise, `nil`.
    public init?(document: [String: Any], documentID: String) {
        guard let name = document["name"] as? String else {
            return nil
        }
        self.id = documentID
        self.name = name
    }

    /// Converts the Folder instance into a dictionary representation suitable for Firestore.
    ///
    /// - Returns: A dictionary containing the folder's data.
    public func toDictionary() -> [String: Any] {
        return ["name": name]
    }
}
