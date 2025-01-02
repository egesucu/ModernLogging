//
//  ContentViewModel.swift
//  ModernLogging
//
//  Created by Sucu, Ege on 2.01.2025.
//

import Foundation
import Observation
import UIKit
import OSLog

@Observable
@MainActor
final class ContentViewModel {
    
    let source = DataOfDaySource()
    var selectedImage: UIImage?
    var openAddLog = false
    
    var dataOfDay: Content?
    
    @MainActor
    func fetchData() async {
        do {
            let data = try await source.fetchData()
            if let data {
                Logger().debug("We have data, \(data.title) & \(data.content)")
                dataOfDay = data
            } else {
                Logger().error("No data has been fetched.")
                dataOfDay = nil
            }
        } catch {
            Logger().error("Error occured: \(error.localizedDescription)")
        }
    }
}
