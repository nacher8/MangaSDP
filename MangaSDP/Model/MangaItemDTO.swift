//
//  MangaItemModel.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 20/1/26.
//

import Foundation

struct MangaItemDTO: Codable, Identifiable {
    let id: Int
    let title: String?
    let titleJapanese: String?
    let titleEnglish: String?
    let sypnosis: String?
    let background: String?
    let themes: [ThemeDTO]
    let demographics: [DemographicDTO]
    let authors: [AuthorDTO]
    let genres: [GenreDTO]
    let startDate: String?
    let endDate: String?
    let volumes: Int?
    let chapters: Int?
    let status: String?
    let score: Double?
    let url: String?
    let mainPicture: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case titleJapanese
        case titleEnglish
        case sypnosis
        case background
        case themes
        case demographics
        case authors
        case genres
        case startDate
        case endDate
        case volumes
        case chapters
        case status
        case score
        case url
        case mainPicture
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        titleJapanese = try container.decodeIfPresent(String.self, forKey: .titleJapanese)
        titleEnglish = try container.decodeIfPresent(String.self, forKey: .titleEnglish)
        sypnosis = try container.decodeIfPresent(String.self, forKey: .sypnosis)
        background = try container.decodeIfPresent(String.self, forKey: .background)
        
        themes = try container.decode([ThemeDTO].self, forKey: .themes)
        demographics = try container.decode([DemographicDTO].self, forKey: .demographics)
        authors = try container.decode([AuthorDTO].self, forKey: .authors)
        genres = try container.decode([GenreDTO].self, forKey: .genres)
        
        startDate = try container.decodeIfPresent(String.self, forKey: .startDate)
        endDate = try container.decodeIfPresent(String.self, forKey: .endDate)
        volumes = try container.decodeIfPresent(Int.self, forKey: .volumes)
        chapters = try container.decodeIfPresent(Int.self, forKey: .chapters)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        score = try container.decodeIfPresent(Double.self, forKey: .score)
        
        let rawUrl = try container.decode(String.self, forKey: .url)
        let rawPicture = try container.decode(String.self, forKey: .mainPicture)
        self.url = rawUrl.cleanedURL()
        self.mainPicture = rawPicture.cleanedURL()
    }
}

extension String {
    func cleanedURL() -> String {
        self.trimmingCharacters(in: .init(charactersIn: "\""))
            .trimmingCharacters(in: .whitespaces)
    }
}
