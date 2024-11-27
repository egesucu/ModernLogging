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
        XCTAssertTrue(addLogView.exists, "The Add Log View title is not visible.")
        
    }
    
    func testMoodPickerSelection() throws {
        try openAddLogView()
        let button = app.buttons[AccessibilityIdentifiers.addLogPicker]
        let buttonExists = button.waitForExistence(timeout: 2)
        if buttonExists {
            button.tap()
            let optimisticOption = app.buttons["Optimistic"]
            XCTAssertTrue(optimisticOption.exists, "Mood option 'Optimistic' is not visible.")
            optimisticOption.tap()
            XCTAssertEqual(button.label, "Mood, Optimistic", "Mood Picker did not update correctly.")
        } else {
            XCTFail("Button bulunamadı.")
        }
    }
    
    func testContentEditorInteraction() throws {
        try openAddLogView()
        let textEditor = app.textViews.firstMatch
        XCTAssertTrue(textEditor.exists, "Content Editor alanı bulunamadı.")

        textEditor.tap()
        textEditor.typeText("Bugün harika bir gün!")
        XCTAssertEqual(textEditor.value as? String, "Bugün harika bir gün!", "Content Editor'a yazılan metin hatalı.")
    }
    
    func testSaveButtonFunctionality() throws {
        try openAddLogView()
        
        let button = app.buttons[AccessibilityIdentifiers.addLogPicker]
        button.tap()
        let optimisticOption = app.buttons["Optimistic"]
        optimisticOption.tap()
        let textEditor = app.textViews.firstMatch
        textEditor.tap()
        textEditor.typeText("Bugün fena bir gün değil!")

        let saveButton = app.buttons["Save"]
        XCTAssertTrue(saveButton.exists, "Save butonu bulunamadı.")

        saveButton.tap()
        
        let moodCheck = app.staticTexts["Optimistic"]
        let textCheck = app.staticTexts["Bugün fena bir gün değil!"]
        
        XCTAssertTrue(moodCheck.exists)
        XCTAssertTrue(textCheck.exists)
    }

    func testLaunchPerformance() throws {
//        measure(metrics: [XCTApplicationLaunchMetric()]) {
//            XCUIApplication().launch()
//        }
    }
}
