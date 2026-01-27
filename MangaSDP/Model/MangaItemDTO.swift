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
}
