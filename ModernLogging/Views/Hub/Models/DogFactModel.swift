//
//  DogFactModel.swift
//  ModernLogging
//
//  Created by Sucu, Ege on 4.01.2025.
//

import Foundation


struct DogFactData: Decodable {
    let attributes: DogFactAttributes
}

struct DogFactAttributes: Decodable {
    let body: String
}
