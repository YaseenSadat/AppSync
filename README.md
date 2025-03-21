# AppSync

**AppSync** is a real-time note-sharing iOS app built with SwiftUI and Firebase, designed to let users create, edit, and synchronize notes across multiple devices instantly. The app leverages modern Swift concurrency and modular architecture via Swift Package Manager (SPM) for enhanced performance, maintainability, and faster build times.

Check out the code on GitHub: [AppSync](https://github.com/YaseenSadat/AppSync)  
Check out StaffPilot in action here: [👉 **YouTube Demo**](https://youtube.com/shorts/LuI4ZVJW9yg)  


---

## Table of Contents

1. [Creators](#creators)  
2. [Summary](#summary)  
3. [Features](#features)  
4. [Technology](#technology)

---

## Creators

**AppSync** was founded and developed by:

- [YaseenSadat](https://github.com/YaseenSadat)

---

## Summary

🌟 **What AppSync Does**  
AppSync provides a seamless note-sharing experience, enabling users to create, edit, and synchronize notes in real time. With Firebase integration, every change is instantly reflected across all devices, ensuring collaboration and access to up-to-date content.

🌟 **Why I Built AppSync**  
AppSync was inspired by the need for a simple yet powerful note-sharing app that showcases modern iOS development best practices—combining SwiftUI, Firebase, Swift concurrency, and modular code architecture. This project demonstrates the ability to design a responsive, real-time app while maintaining clean, efficient code and swift build times.

🌟 **Why AppSync is Unique**  
Unlike many traditional note apps, AppSync emphasizes **real-time collaboration** via Firebase snapshot listeners and **high performance** through concurrency optimizations. The codebase is **modularized** with Swift Package Manager, allowing for faster incremental builds and easy maintenance or extension of the code.

---

## Features

### ✨ Real-Time Note Sharing

- **Instant Sync**: Any changes (create, edit, delete) update across all devices in real time.  
- **Firebase Integration**: Leverages Firestore for cloud storage and real-time synchronization.

### SwiftUI + UIKit Hybrid 

- **Modern UI**: Built primarily with SwiftUI for a clean, reactive interface.  
- **UIKit** integration where needed for performance or advanced features.

### Optimized App Launch & Performance

- **Concurrency Improvements**: Heavy tasks run off the main thread, minimizing UI blocking.  
- **Memory Management**: Detailed profiling with Instruments to ensure efficient memory usage.

### Modular Architecture

- **Swift Package Manager**: Separates data models, services (e.g., `FirestoreService`) and UI components into distinct packages for faster build times and maintainability.  
- **Reduced Build Times**: Incremental builds are sped up by modularizing the app’s code.

### Folder Organization 

- **Folder-Based Notes**: Users can create folders to group related notes, improving organization.  
- **Subcollections**: Each folder has its own “notes” subcollection in Firestore for granular data management.

### Basic Authentication

- **Email/Password Auth**: Simple sign-up and login flow via FirebaseAuth.  
- **Protected Access**: Only authenticated users can create or edit notes/folders.

---

## Technology

### Languages & Frameworks

- **Swift**: Primary language for iOS development.  
- **SwiftUI**: Modern, declarative UI framework powering the main app interface.  
- **UIKit** (Optional): Mixed for certain UI or performance-critical components.

### Firebase

- **FirebaseFirestore**: Real-time database for note storage and synchronization.  
- **FirebaseAuth** (Optional): Handles user authentication for secure note access.  
- **FirebaseCore**: Initializes Firebase in the app.

### Swift Package Manager

- **Modularization**: Splits data models and services (like `Note`, `Folder`, `FirestoreService`) into a separate Swift Package for faster incremental builds.

### Tools & Profiling

- **Xcode Instruments**: Used to profile memory usage, concurrency, and launch performance.  
- **Git**: Version control system for tracking changes and collaborating.

---

