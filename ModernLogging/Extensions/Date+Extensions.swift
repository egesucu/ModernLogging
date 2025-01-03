//
//  Date+Extensions.swift
//  ModernLogging
//
//  Created by Sucu, Ege on 19.12.2024.
//

import Foundation

extension Date {
    static func random(in range: Range<Date>) -> Date {
        Date(
            timeIntervalSinceNow: .random(
                in: range.lowerBound.timeIntervalSinceNow...range.upperBound.timeIntervalSinceNow
            )
        )
    }
}
