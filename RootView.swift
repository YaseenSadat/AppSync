//
//  RootView.swift
//  AppSync
//
//  Created by Yaseen Sadat on 2025-03-18.
//

import SwiftUI

struct RootView: View {
    @ObservedObject var authService = AuthService()
    @State private var showLogin = false
    
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

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
