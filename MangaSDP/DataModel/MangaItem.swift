//
//  MangaItem.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 24/1/26.
//

import Foundation
import SwiftData

@Model
final class MangaItem {
    @Attribute(.unique) var id: Int
    var title: String?
    var titleJapanese: String?
    var titleEnglish: String?
    var sypnosis: String?
    var background: String?
    var startDate: String?
    var endDate: String?
    var volumes: Int?
    var chapters: Int?
    var status: String?
    var score: Double?
    var url: String?
    var mainPicture: String?
    
    @Relationship(deleteRule: .cascade) var themes: [Theme] = []
    @Relationship(deleteRule: .cascade) var demographics: [Demographic] = []
    @Relationship(deleteRule: .nullify) var authors: [Author] = []
    @Relationship(deleteRule: .cascade) var genres: [Genre] = []
    
    init(id: Int, title: String?, titleJapanese: String?, titleEnglish: String?, sypnosis: String?, background: String?, startDate: String?, endDate: String?, volumes: Int?, chapters: Int?, status: String?, score: Double?, url: String?, mainPicture: String?) {
        self.id = id
        self.title = title
        self.titleJapanese = titleJapanese
        self.titleEnglish = titleEnglish
        self.sypnosis = sypnosis
        self.background = background
        self.startDate = startDate
        self.endDate = endDate
        self.volumes = volumes
        self.chapters = chapters
        self.status = status
        self.score = score
        self.url = url
        self.mainPicture = mainPicture
    }
}

@Model
final class Author {
    @Attribute(.unique) var id: String
    var firstName: String
    var lastName: String
    var role: String
    
    @Relationship(deleteRule: .nullify, inverse: \MangaItem.authors) var mangas: [MangaItem]
    
    init(id: String, firstName: String, lastName: String, role: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.role = role
        self.mangas = []
    }
}

@Model
final class Demographic {
    @Attribute(.unique) var id: String
    var demographic: String
    
    @Relationship(deleteRule: .nullify, inverse: \MangaItem.demographics)
        var mangas: [MangaItem] = []
    
    init(id: String, demographic: String) {
        self.id = id
        self.demographic = demographic
    }
}

@Model
final class Genre {
    @Attribute(.unique) var id: String
    var genre: String
    
    @Relationship(deleteRule: .nullify, inverse: \MangaItem.genres)
        var mangas: [MangaItem] = []
    
    init(id: String, genre: String) {
        self.id = id
        self.genre = genre
    }
}

@Model
final class Theme {
    @Attribute(.unique) var id: String
    var theme: String
    
    @Relationship(deleteRule: .nullify, inverse: \MangaItem.themes)
        var mangas: [MangaItem] = []
    
    init(id: String, theme: String) {
        self.id = id
        self.theme = theme
    }
}
