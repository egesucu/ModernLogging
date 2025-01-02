//
//  DataOfDaySource.swift
//  ModernLogging
//
//  Created by Sucu, Ege on 2.01.2025.
//

import Foundation
import OSLog
import UIKit

@MainActor
final class DataOfDaySource {
    private let bundle: Bundle
    var url: URL?
    
    init(bundle: Bundle = .main, url: URL? = nil) {
        self.bundle = bundle
        if let url = url {
            self.url = url
        } else {
            guard let apiURL = bundle.object(forInfoDictionaryKey: "APIURL") as? String else {
                self.url = nil
                return
            }
            if let url = URL(string: apiURL),
               UIApplication.shared.canOpenURL(url){
                self.url = url
            } else {
                self.url = nil
            }
        }
    }
    
    func fetchData() async throws(DataOfDayError) -> Content? {
        if let url {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let content = decodeContent(from: data)
                return content
            } catch {
                throw .fetchError
            }
        } else {
            throw .noURL
        }
    }
    
}

enum DataOfDayError: Error {
    case fetchError
    case noURL
}
