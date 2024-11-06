//
//  MLog.swift
//  ModernLogging
//
//  Created by Sucu, Ege on 6.11.2024.
//

import Foundation


/// A Logging Model to log users overall mood, current day, some image content and some notes.
struct MLog {
    
    var mood: Mood
    var date: Date
    var images: [Data?]
    var notes: String?
    
    init(
        mood: Mood,
        date: Date,
        images: [Data?] = [],
        notes: String? = nil
    ) {
        self.mood = mood
        self.date = date
        self.images = images
        self.notes = notes
    }
    
}

enum Mood: String {
    case happy, sad, neutral, optimistic, dreamy, content, pleased
}
