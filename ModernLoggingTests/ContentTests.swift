//
//  ContentTests.swift
//  ModernLoggingTests
//
//  Created by Sucu, Ege on 2.01.2025.
//

import Testing
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
        """.data(using: .utf8)!
        
        if let content = decodeContent(from: jsonData) {
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
    
    @Test func testDecodeStoicQuote() {
        let jsonData = """
        {
            "data": {
                "author": "Marcus Aurelius",
                "quote": "The best revenge is not to be like your enemy."
            }
        }
        """.data(using: .utf8)!
        
        if let content = decodeContent(from: jsonData) {
            switch content {
            case .stoicQuote(let quote):
                #expect(quote == "Marcus Aurelius - The best revenge is not to be like your enemy.")
                #expect(content.title == "Today's Stoic Quote")
                #expect(content.content == "Marcus Aurelius - The best revenge is not to be like your enemy.")
            default:
                #expect(Bool(false), "Expected .stoicQuote but got \(content)")
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
        """.data(using: .utf8)!
        
        if let content = decodeContent(from: jsonData) {
            switch content {
            case .uselessAdvice(let advice):
                #expect(advice == "Always lick the spoon.")
                #expect(content.title == "Useless Advice")
                #expect(content.content == "Always lick the spoon.")
            default:
                #expect(Bool(false), "Expected .uselessAdvice but got \(content)")
            }
        } else {
            #expect(Bool(false),"Failed to decode JSON")
        }
    }
    
    @Test func testDecodeInvalidJSON() {
        let jsonData = """
        {
            "unknown": "This key is not handled"
        }
        """.data(using: .utf8)!
        
        let content = decodeContent(from: jsonData)
        #expect(content == nil, "Decoding should fail for invalid JSON structure")
    }
    
    @Test func testDecodeEmptyJSON() {
        let jsonData = "{}".data(using: .utf8)!
        
        let content = decodeContent(from: jsonData)
        #expect(content == nil, "Decoding should fail for empty JSON")
    }
}
