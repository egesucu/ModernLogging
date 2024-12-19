//
//  DateExtensionTests.swift
//  ModernLoggingTests
//
//  Created by Sucu, Ege on 19.12.2024.
//

import Foundation
@testable import ModernLogging
import Testing

struct DateExtensionTests {
    @Test
    func testRandomDate() {
        let twoYearsAgo = DateComponents(calendar: .current, timeZone: TimeZone(secondsFromGMT: 0), year: 2022, month: 1, day: 1).date ?? Date()
        print("Two Years Ago Date is: ", twoYearsAgo)
        #expect(twoYearsAgo != Date())
        let oneYearLater = DateComponents(calendar: .current, timeZone: TimeZone(secondsFromGMT: 0), year: 2025, month: 12, day: 1).date ?? Date()
        #expect(oneYearLater != Date())
        print("One Year Later Date is: ", oneYearLater)
        let randomDate = Date.random(in: twoYearsAgo..<oneYearLater)
        print("Generated Random Date is: ", randomDate)
        #expect(randomDate >= twoYearsAgo && randomDate < oneYearLater)
    }
}
