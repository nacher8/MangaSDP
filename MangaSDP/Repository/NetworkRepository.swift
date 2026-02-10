//
//  NetworkRepository.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 22/1/26.
//

import Foundation

protocol NetworkRepository: Sendable, NetworkInteractor {
    func getMangas() async throws(NetworkError) -> Manga
    func getMangas(page: Int) async throws(NetworkError) -> Manga
    func findManga(search: String, page: Int) async throws(NetworkError) -> Manga
    func getGenres() async throws(NetworkError) -> [String]
    func getDemographics() async throws(NetworkError) -> [String]
    func getThemes() async throws(NetworkError) -> [String]
    func getMangaByGenre(genre: String, page: Int) async throws(NetworkError) -> Manga
    func getMangasByDemographic(demographic: String, page: Int) async throws(NetworkError) -> Manga
    func getMangasByTheme(theme: String, page: Int) async throws(NetworkError) -> Manga
}

struct Network: NetworkRepository {
    func getMangas() async throws(NetworkError) -> Manga {
        return try await getJSON(.get(url: .getMangas), type: Manga.self)
    }
    
    func getMangas(page: Int) async throws(NetworkError) -> Manga {
        return try await getJSON(.get(url: .getMangas(page: page)), type: Manga.self)
    }
    
    func findManga(search: String, page: Int) async throws(NetworkError) -> Manga {
        return try await getJSON(.get(url: .findManga(search: search, page: page)), type: Manga.self)
    }
    
    func getGenres() async throws(NetworkError) -> [String] {
        return try await getJSON(.get(url: .getGenres()), type: [String].self)
    }
    
    func getDemographics() async throws(NetworkError) -> [String] {
        return try await getJSON(.get(url: .getDemographics()), type: [String].self)
    }
    
    func getThemes() async throws(NetworkError) -> [String] {
        return try await getJSON(.get(url: .getThemes()), type: [String].self)
    }
    
    func getMangaByGenre(genre: String, page: Int) async throws(NetworkError) -> Manga {
        return try await getJSON(.get(url: .getMangaByGenre(genre: genre, page: page)), type: Manga.self)
    }
    
    func getMangasByDemographic(demographic: String, page: Int) async throws(NetworkError) -> Manga {
        return try await getJSON(.get(url: .getMangaByDemographic(demographic: demographic, page: page)), type: Manga.self)
    }
    
    func getMangasByTheme(theme: String, page: Int) async throws(NetworkError) -> Manga {
        return try await getJSON(.get(url: .getMangaByTheme(theme: theme, page: page)), type: Manga.self)
    }
}
