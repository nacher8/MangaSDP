//
//  MangaCategories.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 9/2/26.
//

import Foundation
import SwiftData

@Model
final class MangaCategories {
    @Attribute(.unique) var id: String
    var genres: [String]
    var demographics: [String]
    var themes: [String]
    
    init(id: String, genres: [String], demographics: [String], themes: [String]) {
        self.id = id
        self.genres = genres
        self.demographics = demographics
        self.themes = themes
    }
}
