//
//  ShareSheet.swift
//  AppSync
//
//  Created by Yaseen Sadat on 2025-03-20.
//

import SwiftUI
import UIKit

/// A SwiftUI wrapper for presenting the native iOS share sheet (UIActivityViewController).
///
/// This structure conforms to `UIViewControllerRepresentable` and allows you to use
/// `UIActivityViewController` in SwiftUI to share text, URLs, images, and other data.
struct ShareSheet: UIViewControllerRepresentable {
    /// The items to share. This can include text, URLs, images, etc.
    var activityItems: [Any]
    
    /// Optional custom activities to include in the share sheet.
    var applicationActivities: [UIActivity]? = nil
    
    /// Creates the UIActivityViewController instance to present.
    ///
    /// - Parameter context: The context for coordinating with SwiftUI.
    /// - Returns: A configured `UIActivityViewController` with the provided activity items and custom activities.
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems,
                                 applicationActivities: applicationActivities)
    }
    
    /// Updates the UIActivityViewController instance.
    ///
    /// This implementation is empty because there is no dynamic state to update.
    /// - Parameters:
    ///   - uiViewController: The current `UIActivityViewController` instance.
    ///   - context: The context for coordinating with SwiftUI.
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // Nothing to update in this simple example.
    }
}
