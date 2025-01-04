//
//  Content.swift
//  ModernLogging
//
//  Created by Sucu, Ege on 2.01.2025.
//

import Foundation

enum Content: Decodable {
    case dogFact(String)
    case uselessAdvice(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        
        // Try decoding Dog Fact
        if let data = try? container.decode([DogFactData].self, forKey: DynamicCodingKeys(stringValue: "data")!) {
            if let firstFact = data.first {
                self = .dogFact(firstFact.attributes.body)
                return
            }
        }
        
        // Try decoding Useless Advice
        if let text = try? container.decode(String.self, forKey: DynamicCodingKeys(stringValue: "text")!) {
            self = .uselessAdvice(text)
            return
        }
        
        // If no match found
        throw DecodingError.dataCorrupted(DecodingError.Context(
            codingPath: decoder.codingPath,
            debugDescription: "JSON does not match any expected format."
        ))
    }
}

// MARK: - DynamicCodingKeys
/// A custom key type to allow dynamic key decoding.
struct DynamicCodingKeys: CodingKey {
    var stringValue: String
    var intValue: Int? { return nil }
    
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    init?(intValue: Int) {
        return nil
    }
}

// MARK: - Content Extension
extension Content {
    var title: String {
        switch self {
        case .dogFact:
            return "Today's Dog Fact"
        case .uselessAdvice:
            return "Useless Advice"
        }
    }
    
    var content: String {
        switch self {
        case .dogFact(let string), .uselessAdvice(let string):
            return string
        }
    }
    
    static func decodeContent(from jsonData: Data) -> Self? {
        let decoder = JSONDecoder()
        do {
            let content = try decoder.decode(Content.self, from: jsonData)
            return content
        } catch {
            print("Failed to decode JSON: \(error)")
            return nil
        }
    }
}
