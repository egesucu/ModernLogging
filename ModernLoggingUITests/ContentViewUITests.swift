//
//  ContentViewUITests.swift
//  ModernLoggingUITests
//
//  Created by Sucu, Ege on 27.11.2024.
//

import XCTest
@testable import ModernLogging

final class ContentViewUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testAddButtonExists() throws {
        let buttonText = AccessibilityIdentifiers.addLogButton
        XCTAssertFalse(buttonText.isEmpty)
        let addLogButton = app.buttons[buttonText]
        let exists = addLogButton.waitForExistence(timeout: 2)
        XCTAssertTrue(exists)
    }

    private func openAddLogView() throws {
        let buttonText = AccessibilityIdentifiers.addLogButton
        let addLogButton = app.buttons[buttonText]
        addLogButton.tap()
    }

    func testAddButtonTap() throws {
        try openAddLogView()
        let addLogViewTitle = AccessibilityIdentifiers.addLogView
        let addLogView = app.staticTexts[addLogViewTitle]
        let exists = addLogView.waitForExistence(timeout: 1)
        XCTAssertTrue(exists, "The Add Log View title is not visible.")

    }

    func testLaunchPerformance() throws {
//        measure(metrics: [XCTApplicationLaunchMetric()]) {
//            XCUIApplication().launch()
//        }
    }
}
