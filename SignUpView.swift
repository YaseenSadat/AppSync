//
//  SignUpView.swift
//  AppSync
//
//  Created by Yaseen Sadat on 2025-03-18.
//

import SwiftUI

/// A view that allows a new user to sign up using email and password.
///
/// This view presents text fields for entering a username, email, and password. It also includes
/// a button for creating an account and another button for switching to the Log In screen.
struct SignUpView: View {
    /// An observed instance of AuthService for handling authentication logic.
    @ObservedObject var authService: AuthService
    
    /// A closure that toggles between the Sign Up and Log In screens.
    var toggleScreen: () -> Void
    
    // MARK: - State Properties
    
    /// The username entered by the user.
    @State private var username: String = ""
    /// The email entered by the user.
    @State private var email: String = ""
    /// The password entered by the user.
    @State private var password: String = ""
    
    /// The content and behavior of the view.
    var body: some View {
        VStack(spacing: 20) {
            Text("Sign Up")
                .font(.largeTitle)
            
            // Username input field.
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            // Email input field.
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            
            // Password input field with a hint for minimum length.
            SecureField("Password (min 8 chars)", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            // Button to create an account.
            Button(action: {
                authService.signUp(username: username, email: email, password: password)
            }) {
                Text("Create Account")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            
            // Display an error message if one exists.
            if let errorMessage = authService.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            // Button to switch to the Log In screen.
            Button("Already have an account? Log In") {
                // Clear any previous error messages and toggle the screen.
                authService.errorMessage = nil
                toggleScreen()
            }
            .padding()
        }
        .padding()
    }
}

/// Provides a preview of SignUpView for SwiftUI's canvas.
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(authService: AuthService(), toggleScreen: {})
    }
}
