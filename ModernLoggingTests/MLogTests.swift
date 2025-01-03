//
//  MLogTests.swift
//  ModernLoggingTests
//
//  Created by Sucu, Ege on 6.11.2024.
//

import Foundation
import Testing
import UIKit
@testable import ModernLogging

@Suite("MLog Model Testing")
class MLogTests {

    var model: MLog?

    @Test func testCreation() async throws {
        model = MLog(mood: .happy, date: Date(), notes: "Some Days, you can't help but smile.")
        #expect(model != nil)
    }

    @Test func testImage() async throws {
        let imageData = UIImage(systemName: "square.and.arrow.up.fill")?.jpegData(compressionQuality: 0.8)
        model = MLog(mood: .sad, date: Date(), images: [imageData], notes: "Some Days, you can't help but smile.")
        #expect(imageData != nil)
        if let data = imageData {
            let image = UIImage(data: data)
            #expect(image != nil)
        }
    }

    @Test func testMood() async throws {
        model = MLog(mood: .optimistic, date: Date(), notes: "Some Days, you can't help but smile.")
        #expect(model?.mood == .optimistic)
    }

    @Test func testDate() async throws {
        let date = Calendar.current.date(from: .init(year: 2024, month: 9, day: 3))
        if let date {
            model = MLog(mood: .neutral, date: date, notes: "Some Days, you can't help but smile.")
            if let model {
                let components = Calendar.current.dateComponents([.day, .month], from: model.date)

                #expect(components.day == 3)
                #expect(components.month  == 9)
            }
        }
    }

    @Test func testMoodDefaultsToNeutral() async throws {
        let log = MLog(moodRawValue: "invalid", date: .now)

        #expect(log.mood == .neutral)
        log.mood = .content
        #expect(log.mood == .content)

    }

    @Test func testMoodIdentifiableConformance() async throws {
        for mood in Mood.allCases {
            #expect(mood.id == mood, "The ID of \(mood) should equal itself.")
        }
    }

    @Test func testNotes() async throws {
        model = MLog(mood: .dreamy, date: Date(), notes: "Some Days, you can't help but smile.")
        #expect(model?.notes == "Some Days, you can't help but smile.")
    }
}
