//
//  ColorExtensionTests.swift
//  ModernLoggingTests
//
//  Created by Sucu, Ege on 4.01.2025.
//

import Foundation
@testable import ModernLogging
import Testing
import SwiftUI

struct ColorExtensionTests {
    
    @Test func testLabelColor() {
        let labelColor = Color.label
        let labelUIColor = UIColor.label
        
        #expect(UIColor(labelColor) == labelUIColor, "Both colors should match")
    }
}
