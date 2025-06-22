//
//  Recording.swift
//  WAV
//
//  Created by Karthik Gurram on 2025-06-21.
//

import Foundation
import SwiftData

@Model
class Recording {
    // MARK: - Required Fields
    var id: UUID
    var fileName: String
    var createdAt: Date

    // MARK: - Optional AI Metadata
    var detectedKey: String?
    var bpm: Int?
    var mood: String?
    var transcript: String?
    var suggestedLyrics: String?

    // MARK: - User Tags
    var title: String
    var isFavorite: Bool
    var colorTag: String? // e.g. "red", "green", "blue"

    // MARK: - Init
    init(
        fileName: String,
        createdAt: Date = .now,
        title: String = "",
        detectedKey: String? = nil,
        bpm: Int? = nil,
        mood: String? = nil,
        transcript: String? = nil,
        suggestedLyrics: String? = nil,
        isFavorite: Bool = false,
        colorTag: String? = nil
    ) {
        self.id = UUID()
        self.fileName = fileName
        self.createdAt = createdAt
        self.title = title
        self.detectedKey = detectedKey
        self.bpm = bpm
        self.mood = mood
        self.transcript = transcript
        self.suggestedLyrics = suggestedLyrics
        self.isFavorite = isFavorite
        self.colorTag = colorTag
    }
}
