//
//  AccessibilityIdentifiers.swift
//  ModernLogging
//
//  Created by Sucu, Ege on 27.11.2024.
//

import Foundation

struct AccessibilityIdentifiers {
    static let logListView = "LogListView"
    static func listItem(item: String) -> String {
        "Log Item \(item)"
    }
    static let addLogButton = "AddLogButton"
    
    // MARK: - Add Log View
    static let addLogView = "AddLogView"
    static let addLogPicker = "AddLogPicker"
}
