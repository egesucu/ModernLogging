//
//  MLog.swift
//  ModernLogging
//
//  Created by Sucu, Ege on 6.11.2024.
//

import Foundation
import SwiftData

/// A Logging Model to log users overall mood, current day, some image content and some notes.
@Model class MLog {

    private var moodRawValue: String
    var date: Date
    var images: [Data?]
    var notes: String?

    var mood: Mood {
        get {
            Mood(rawValue: moodRawValue) ?? .neutral
        }
        set {
            moodRawValue = newValue.rawValue
        }
    }

    init(
        mood: Mood,
        date: Date,
        images: [Data?] = [],
        notes: String? = nil
    ) {
        self.moodRawValue = mood.rawValue
        self.date = date
        self.images = images
        self.notes = notes
    }

    internal init(
        moodRawValue: String,
        date: Date,
        images: [Data?] = [],
        notes: String? = nil
    ) {
        self.moodRawValue = moodRawValue
        self.date = date
        self.images = images
        self.notes = notes
    }

}

enum Mood: String, CaseIterable {
    case happy, sad, neutral, optimistic, dreamy, content, pleased
}

extension Mood: Identifiable {
    var id: Self { self }
}
