//
//  WAVApp.swift
//  WAV
//
//  Created by Karthik Gurram on 2025-06-21.
//

import SwiftUI
import SwiftData
import FirebaseCore
import FirebaseStorage

@main
struct WAVApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Recording.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    init() {
        FirebaseApp.configure()

        // Enforce dark mode globally
        UIView.appearance().overrideUserInterfaceStyle = .dark

        AuthManager.shared.signInAnonymouslyIfNeeded { uid in
            if let uid = uid {
                print("✅ Logged in as user: \(uid)")
            } else {
                print("❌ Failed to log in anonymously")
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
