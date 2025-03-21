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
    /// The currently authenticated user, if any.
    @Published var currentUser: FirebaseAuth.User? = nil
    /// An error message to display when an authentication operation fails.
    @Published var errorMessage: String? = nil
    
    /// Initializes the AuthService and sets up a listener for Firebase Auth state changes.
    ///
    /// The listener updates the `currentUser` property whenever the authentication state changes.
    init() {
        // Listen for changes in the Firebase Auth user.
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.currentUser = user
        }
    }

    // MARK: - Sign Up

    /// Signs up a new user using Firebase email/password authentication.
    ///
    /// - Parameters:
    ///   - username: The desired username for the new user.
    ///   - email: The email address for the new user.
    ///   - password: The password for the new user. Must be at least 8 characters long.
    ///
    /// If the password is too short, the `errorMessage` property is set with an appropriate message.
    /// On successful creation, the user is registered with Firebase Auth.
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

    /// Logs in an existing user with Firebase email/password authentication.
    ///
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - password: The user's password.
    ///
    /// If the login fails, the `errorMessage` property is updated with the error details.
    func logIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in
            guard let self = self else { return }
            if let error = error {
                self.errorMessage = "Log in error: \(error.localizedDescription)"
            }
        }
    }
    
    // MARK: - Log Out

    /// Logs out the currently authenticated user.
    ///
    /// If the log out process encounters an error, the `errorMessage` property is updated with the error details.
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            self.errorMessage = "Sign out error: \(error.localizedDescription)"
        }
    }
}

