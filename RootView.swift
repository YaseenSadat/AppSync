//
//  RootView.swift
//  AppSync
//
//  Created by Yaseen Sadat on 2025-03-18.
//

import SwiftUI

/// The root view for the AppSync application.
///
/// This view determines whether the user is logged in. If authenticated,
/// it displays the `FolderListView`. Otherwise, it toggles between the
/// `LogInView` and `SignUpView` based on the user's selection.
struct RootView: View {
    /// An observed instance of AuthService to manage user authentication.
    @ObservedObject var authService = AuthService()
    /// A state variable that determines whether to show the Log In screen.
    @State private var showLogin = false
    
    /// The main content of the view based on the user's authentication status.
    var body: some View {
        if let _ = authService.currentUser {
            // User is logged in -> show FolderListView
            FolderListView(authService: authService)
        } else {
            // Not logged in -> either show sign up or log in
            if showLogin {
                LogInView(authService: authService) {
                    // Toggle to sign up
                    showLogin = false
                }
            } else {
                SignUpView(authService: authService) {
                    // Toggle to log in
                    showLogin = true
                }
            }
        }
    }
}

/// Provides a preview of RootView for SwiftUI's canvas.
struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
