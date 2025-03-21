//
//  FolderListView.swift
//  AppSync
//
//  Created by Yaseen Sadat on 2025-03-18.
//

import SwiftUI
import AppSyncCore  // New: Import the package containing Note, Folder, and FirestoreService

/// A view that displays a list of folders for the current user and provides functionality to add new folders.
/// It also includes navigation to view notes within a selected folder.
struct FolderListView: View {
    /// An observed instance of FirestoreService for managing folder data.
    @ObservedObject var firestoreService = FirestoreService()
    /// An observed instance of AuthService to manage user authentication.
    @ObservedObject var authService: AuthService
    
    /// Holds the name of the new folder entered by the user.
    @State private var newFolderName: String = ""
    
    /// The view's content and behavior.
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(firestoreService.folders) { folder in
                        NavigationLink(destination: NotesListView(folder: folder, authService: authService)) {
                            Text(folder.name)
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .onAppear {
                    // Fetch folders for the current user when the view appears.
                    if let user = authService.currentUser {
                        firestoreService.fetchFolders(forUser: user.uid)
                    }
                }
                
                HStack {
                    TextField("New Folder Name", text: $newFolderName)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                    
                    Button(action: {
                        // Add a new folder if a valid name is entered and the user is authenticated.
                        if let user = authService.currentUser, !newFolderName.isEmpty {
                            firestoreService.addFolder(name: newFolderName, forUser: user.uid)
                            newFolderName = ""
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.blue)
                    }
                }
                .padding()
            }
            .navigationTitle("My Folders")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Log out the current user.
                        authService.logOut()
                    }) {
                        Text("Log Out")
                            .foregroundColor(.blue)
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
        }
    }
}

/// Provides a preview of FolderListView for SwiftUI's canvas.
struct FolderListView_Previews: PreviewProvider {
    static var previews: some View {
        FolderListView(authService: AuthService())
    }
}
