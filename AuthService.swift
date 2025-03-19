//
//  AuthService.swift
//  AppSync
//
//  Created by Yaseen Sadat on 2025-03-18.
//

import Foundation
import FirebaseAuth

/// A simple class for handling Firebase email/password authentication.
class AuthService: ObservableObject {
    @Published var currentUser: FirebaseAuth.User? = nil
    @Published var errorMessage: String? = nil
    
    init() {
        // Listen for changes in the Firebase Auth user.
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.currentUser = user
        }
    }

    // MARK: - Sign Up
    func signUp(username: String, email: String, password: String) {
        // Example check: ensure password is at least 8 chars
        guard password.count >= 8 else {
            self.errorMessage = "Password must be at least 8 characters."
            return
        }
        
        // Create the user in Firebase Auth
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                self.errorMessage = "Sign up error: \(error.localizedDescription)"
                return
            }
            // Optionally store the username in Firestore if you wish
        }
    }
    
    // MARK: - Log In
    func logIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in
            guard let self = self else { return }
            if let error = error {
                self.errorMessage = "Log in error: \(error.localizedDescription)"
            }
        }
    }
    
    // MARK: - Log Out
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            self.errorMessage = "Sign out error: \(error.localizedDescription)"
        }
    }
}
