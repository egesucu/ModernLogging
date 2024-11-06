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
    var day: Date
    var images: [Data]?
    var notes: String?
    
    init(
        mood: Mood,
        day: Date,
        images: [Data]? = nil,
        notes: String? = nil
    ) {
        self.mood = mood
        self.day = day
        self.images = images
        self.notes = notes
    }
    
}

enum Mood: String {
    case happy, sad, neutral, optimistic, dreamy, content, pleased
}
