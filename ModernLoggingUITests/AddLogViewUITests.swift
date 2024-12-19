//
//  AddLogViewUITests.swift
//  ModernLoggingUITests
//
//  Created by Sucu, Ege on 7/12/24.
//

import XCTest
@testable import ModernLogging

final class AddLogViewUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }
    
    private func openAddLogView() throws {
        let buttonText = AccessibilityIdentifiers.addLogButton
        let addLogButton = app.buttons[buttonText]
        addLogButton.tap()
    }
    
    func testLoadImages() throws {
        try openAddLogView()
        
        let images = app.images
        XCTAssertGreaterThan(images.count, 0)
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
    
    func testLoadImageLogic() throws {
        try openAddLogView()
        
        // Open Photos Picker
        let button = app.buttons["Add Photo Button"].firstMatch
        button.tap()
            
        
        // Finding the PhotosItemPicker
        let picker = XCUIApplication()
            .otherElements
            .containing(.any, identifier: "PXGSingleViewContainerView_AX")
            .firstMatch
        
        let firstImage = picker
            .images
            .element(matching: NSPredicate(format: "label CONTAINS[c] 'Photo'"))
            .firstMatch

        firstImage.tap()
        
        let doneButton = app.buttons["Add"]
        
        doneButton.tap()
        
        let expectedScrollView = app.scrollViews["Photo Scroll"].firstMatch
        
        let element = expectedScrollView.images.firstMatch
        
        XCTAssertTrue(element.exists)
        
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
    
    
    
}
