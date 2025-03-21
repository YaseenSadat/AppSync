//
//  AppSyncApp.swift
//  AppSync
//
//  Created by Yaseen Sadat on 2025-03-18.
//

import SwiftUI
import FirebaseCore

/// The main entry point for the AppSync application.
///
/// This structure conforms to the `App` protocol and is marked with the `@main` attribute,
/// indicating that it is the starting point of the application.
@main
struct AppSyncApp: App {
    /// Initializes the AppSync application.
    ///
    /// In the initializer, Firebase is configured by calling `FirebaseApp.configure()`,
    /// ensuring that all Firebase services are set up before the UI is loaded.
    init() {
        FirebaseApp.configure()
    }

    /// The scene content of the AppSync application.
    ///
    /// This property defines the app’s primary user interface by creating a `WindowGroup`
    /// that contains the `RootView`, which is the main view presented to the user.
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
