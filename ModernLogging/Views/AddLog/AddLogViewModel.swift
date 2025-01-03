//
//  AddLogViewModel.swift
//  ModernLogging
//
//  Created by Sucu, Ege on 7/12/24.
//

import SwiftUI
import Observation
import PhotosUI
import UIKit
import CoreData
import SwiftData
import OSLog

@Observable
class AddLogViewModel {
    var log = MLog(mood: .content, date: .now)
    var content = ""
    var mood: Mood = .happy
    var selectedItems: [PhotosPickerItem] = []
    var photos: [UIImage] = []

    func save(context: ModelContext) {
        log = MLog(
            mood: mood,
            date: .now,
            images: map(photos),
            notes: content
        )

        context.insert(log)
    }

    private func map(_ photos: [UIImage]) -> [Data?] {
        photos.map { $0.jpegData(compressionQuality: 0.8) }
    }

}
