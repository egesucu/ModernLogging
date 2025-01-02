//
//  AddLogViewModelTests.swift
//  ModernLoggingTests
//
//  Created by Sucu, Ege on 7/12/24.
//

import Testing
import SwiftData
import SwiftUI
import PhotosUI
import OSLog
@testable import ModernLogging

var modelContainer: ModelContainer {
    do {
        let container = try ModelContainer(
            for: MLog.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        return container
    } catch {
        fatalError("Failed to create container.")
    }
}

struct AddLogViewModelTests {

    let sut: AddLogViewModel

    private var container: ModelContainer!

    init() {
        self.sut = AddLogViewModel()
        container = modelContainer
    }

    @MainActor var modelContext: ModelContext { container.mainContext }

    @Test func testSaving() async throws {
        sut.content = "The quick brown fox jumps over the lazy dog."
        sut.mood = .dreamy
        sut.selectedItems = []
        sut.photos = []

        await sut.save(context: modelContext)
        let descriptor = FetchDescriptor<MLog>()
        let logs = try await modelContext.fetch(descriptor)
        if let log = logs.first {
            Logger().debug("First Log: \(log.mood.rawValue), \(log.notes ?? "") \(log.date) \(log.images.count)")
        }
        #expect(logs.count == 1)
        #expect(logs[0].mood == .dreamy)
        #expect(logs[0].notes == "The quick brown fox jumps over the lazy dog.")
    }
}

extension ModelContext: @unchecked @retroactive Sendable { }
