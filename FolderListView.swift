//
//  FolderListView.swift
//  AppSync
//
//  Created by Yaseen Sadat on 2025-03-18.
//

import SwiftUI
import AppSyncCore  // New: Import the package containing Note, Folder, and FirestoreService

struct FolderListView: View {
    @ObservedObject var firestoreService = FirestoreService()
    @ObservedObject var authService: AuthService
    
    @State private var newFolderName: String = ""
    
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

struct FolderListView_Previews: PreviewProvider {
    static var previews: some View {
        FolderListView(authService: AuthService())
    }
}
