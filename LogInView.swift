//
//  LogInView.swift
//  AppSync
//
//  Created by Yaseen Sadat on 2025-03-18.
//

import SwiftUI

/// A view for logging in the user using email and password.
///
/// This view provides text fields for the user's email and password, and displays a log in button. It also includes an error message display and a button to toggle to the Sign Up screen.
struct LogInView: View {
    /// An observed instance of AuthService to handle authentication logic.
    @ObservedObject var authService: AuthService
    
    /// A closure to toggle between the Log In and Sign Up screens.
    var toggleScreen: () -> Void
    
    /// The email entered by the user.
    @State private var email: String = ""
    /// The password entered by the user.
    @State private var password: String = ""
    
    /// The view's content and behavior.
    var body: some View {
        VStack(spacing: 20) {
            Text("Log In")
                .font(.largeTitle)
            
            // Email input field
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            
            // Password input field
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            // Log In button
            Button(action: {
                authService.logIn(email: email, password: password)
            }) {
                Text("Log In")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            
            // Display error message if authentication fails
            if let errorMessage = authService.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            // Button to switch to the Sign Up screen
            Button("Need an account? Sign Up") {
                // Clear any error messages and toggle to the sign up screen.
                authService.errorMessage = nil
                toggleScreen()
            }
            .padding()
        }
        .padding()
    }
}

/// Provides a preview for LogInView in SwiftUI's canvas.
struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView(authService: AuthService(), toggleScreen: {})
    }
}
