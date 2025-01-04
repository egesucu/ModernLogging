//
//  ContentTests.swift
//  ModernLoggingTests
//
//  Created by Sucu, Ege on 2.01.2025.
//

import Testing
import Foundation
@testable import ModernLogging

struct ContentTests {

    @Test func testDecodeDogFact() {
        let jsonData = """
        {
            "data": [
                {
                    "attributes": {
                        "body": "Dogs wag their tails when they are happy."
                    }
                }
            ]
        }
        """
        let data = Data(jsonData.utf8)

        if let content = Content.decodeContent(from: data) {
            switch content {
            case .dogFact(let fact):
                #expect(fact == "Dogs wag their tails when they are happy.")
                #expect(content.title == "Today's Dog Fact")
                #expect(content.content == "Dogs wag their tails when they are happy.")
            default:
                #expect(Bool(false), "Expected .dogFact but got \(content)")
            }
        } else {
            #expect(Bool(false), "Failed to decode JSON")
        }
    }

    @Test func testDecodeUselessAdvice() {
        let jsonData = """
        {
            "text": "Always lick the spoon."
        }
        """
        let data = Data(jsonData.utf8)

        if let content = Content.decodeContent(from: data) {
            switch content {
            case .uselessAdvice(let advice):
                #expect(advice == "Always lick the spoon.")
                #expect(content.title == "Useless Advice")
                #expect(content.content == "Always lick the spoon.")
            default:
                #expect(Bool(false), "Expected .uselessAdvice but got \(content)")
            }
        } else {
            #expect(Bool(false), "Failed to decode JSON")
        }
    }

    @Test func testDecodeInvalidJSON() {
        let jsonData = """
        {
            "unknown": "This key is not handled"
        }
        """
        let data = Data(jsonData.utf8)

        let content = Content.decodeContent(from: data)
        #expect(content == nil, "Decoding should fail for invalid JSON structure")
    }

    @Test func testDecodeEmptyJSON() {
        let jsonData = "{}"
        let data = Data(jsonData.utf8)

        let content = Content.decodeContent(from: data)
        #expect(content == nil, "Decoding should fail for empty JSON")
    }
}
