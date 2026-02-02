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
    var status: MangaStatus?
    var score: Double?
    var url: URL?
    var mainPicture: URL?
    
    @Relationship(deleteRule: .cascade) var themes: [Theme] = []
    @Relationship(deleteRule: .cascade) var demographics: [Demographic] = []
    @Relationship(deleteRule: .nullify) var authors: [Author] = []
    @Relationship(deleteRule: .cascade) var genres: [Genre] = []
    
    init(id: Int, title: String?, titleJapanese: String?, titleEnglish: String?, sypnosis: String?, background: String?, startDate: String?, endDate: String?, volumes: Int?, chapters: Int?, status: MangaStatus?, score: Double?, url: URL?, mainPicture: URL?) {
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

extension MangaItem {
    @MainActor
    static let manga = MangaItem(id: 42,
                                 title: "Dragon Ball",
                                 titleJapanese: "ドラゴンボール",
                                 titleEnglish: "Dragon Ball",
                                 sypnosis: "Bulma, a headstrong 16-year-old girl, is on a quest to find the mythical Dragon Balls—seven scattered magic orbs that grant the finder a single wish. She has but one desire in mind: a perfect boyfriend. On her journey, Bulma stumbles upon Gokuu Son, a powerful orphan who has only ever known one human besides her. Gokuu possesses one of the Dragon Balls, it being a memento from his late grandfather. In exchange for it, Bulma invites Gokuu to be a companion in her travels.\n\nBy Bulma's side, Gokuu discovers a world completely alien to him. Powerful enemies embark on their own pursuits of the Dragon Balls, pushing Gokuu beyond his limits in order to protect Bulma and their growing circle of allies. However, Gokuu has secrets unbeknownst to even himself; the incredible strength within him stems from a mysterious source, one that threatens the many people he grows to hold dear.\n\nAs his prowess in martial arts flourishes, Gokuu attracts stronger opponents whose villainous plans could collapse beneath his might. He undertakes the endless venture of combat training to defend his loved ones and the fate of the planet itself.\n\n[Written by MAL Rewrite]",
                                 background: "Dragon Ball has become one of the most successful manga series of all time, with over 230 million copies sold worldwide with 157 million in Japan alone, making it the third all-time best selling manga as of 2015, and the #1 manga series not currently publishing. The series is often credited for the \"Golden Age of Jump\" where the magazine's circulation was at its highest. VIZ Media serialized the manga in English from March 1998 to March 2005 in monthly comic book anthology format; and was later collected into traditional tankobon format volumes from March 12, 2003 to June 6, 2006. To closer follow the English anime localization, the series is split; in which volumes 17-42 are titled Dragon Ball Z and renumbered as volumes 1-26. Other releases by VIZ include the large format VIZ Big Edition, kanzenban cover based 3-in-1 Edition, and a Full Color Edition of chapters 195-245. Other English publishers include Madman Entertainment in Australia/New Zealand, and the now defunct Gollancz Manga (distribution rights transferred to VIZ) in the United Kingdom. The series is also published in Spanish by Planet DeAgostini Cómics and in French by Glénat Editions.",
                                 startDate: "1984-11-20T00:00:00",
                                 endDate: "1995-05-23T00:00:00Z",
                                 volumes: 42,
                                 chapters: 520,
                                 status: .finished,
                                 score: 8.41,
                                 url: URL(string: "https://myanimelist.net/manga/42/Dragon_Ball"),
                                 mainPicture: URL(string: "https://cdn.myanimelist.net/images/manga/1/267793l.jpg"))
}

enum MangaStatus: String, Codable {
    case currentlyPublishing = "currently_publishing"
    case finished
    case onHiatus = "on_hiatus"
    case discontinued
    
    var displayName: String {
        switch self {
        case .currentlyPublishing: 
            return "In publication"
        case .finished:
            return "Finished"
        case .onHiatus:
            return "Paused"
        case .discontinued:
            return "Cancelled"
        }
    }
}

extension MangaItem {
    var authorsString: String {
        authors
            .map { "\($0.firstName) \($0.lastName)" }
            .joined(separator: ", ")
    }
    
    var genresString: String {
        genres
            .map { "\($0.genre)" }
            .joined(separator: ", ")
    }
    
    var themesString: String {
        themes
            .map { "\($0.theme)" }
            .joined(separator: ", ")
    }
    
    var demographicsString: String {
        demographics
            .map{ "\($0.demographic)" }
            .joined(separator: ", ")
    }

    var puntuation: String {
        return "\(self.score ?? 0.0)"
    }
    
    var chaptersString: String {
        guard let chapters else { return "-" }
        return "\(chapters)"
    }
    
    var volumesString: String {
        guard let volumes else { return "-" }
        return "\(volumes)"
    }
}

extension Author {
    var fullName: String {
        "\(self.firstName) \(self.lastName)"
    }
}
