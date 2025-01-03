//
//  ModernLoggingApp.swift
//  ModernLogging
//
//  Created by Sucu, Ege on 6.11.2024.
//

import SwiftUI
import SwiftData

@main
struct ModernLoggingApp: App {

    var modelContainer: ModelContainer

    // swiftlint: disable force_try
    init() {
        modelContainer = try! ModelContainer(for: MLog.self)
    }
    // swiftlint: enable force_try

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer)
        }
    }
}
