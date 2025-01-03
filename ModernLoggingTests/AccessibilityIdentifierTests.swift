//
//  AccessibilityIdentifierTests.swift
//  ModernLoggingTests
//
//  Created by Sucu, Ege on 28.11.2024.
//

import Testing
@testable import ModernLogging

struct AccessibilityIdentifierTests {

    @Test func testLogItem() async throws {
        let logItem = AccessibilityIdentifiers.listItem(item: "test")
        #expect(logItem == "Log Item test")
    }

}
