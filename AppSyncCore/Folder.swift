//
//  Folder.swift
//  AppSync
//
//  Created by Yaseen Sadat on 2025-03-18.
//

import Foundation

public struct Folder: Identifiable {
    public let id: String
    public let name: String

    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }

    // Initialize from Firestore document
    public init?(document: [String: Any], documentID: String) {
        guard let name = document["name"] as? String else {
            return nil
        }
        self.id = documentID
        self.name = name
    }

    // Convert to Firestore dictionary
    public func toDictionary() -> [String: Any] {
        return ["name": name]
    }
}
