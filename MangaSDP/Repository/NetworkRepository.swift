//
//  NetworkRepository.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 22/1/26.
//

import Foundation

protocol NetworkRepository: Sendable, NetworkInteractor {
    func getMangas() async throws(NetworkError) -> MangaDTO
    func getMangas(page: Int) async throws(NetworkError) -> MangaDTO
    func findManga(search: String, page: Int) async throws(NetworkError) -> MangaDTO
    func getGenres() async throws(NetworkError) -> [String]
    func getDemographics() async throws(NetworkError) -> [String]
    func getThemes() async throws(NetworkError) -> [String]
    func getMangaByGenre(genre: String, page: Int) async throws(NetworkError) -> MangaDTO
    func getMangasByDemographic(demographic: String, page: Int) async throws(NetworkError) -> MangaDTO
    func getMangasByTheme(theme: String, page: Int) async throws(NetworkError) -> MangaDTO
    func getAuthors(page: Int) async throws(NetworkError) -> AuthorPageDTO
    func getMangasAuthor(id: String, page: Int) async throws(NetworkError) -> MangaDTO
}

struct Network: NetworkRepository {
    func getMangas() async throws(NetworkError) -> MangaDTO {
        return try await getJSON(.get(url: .getMangas), type: MangaDTO.self)
    }
    
    func getMangas(page: Int) async throws(NetworkError) -> MangaDTO {
        return try await getJSON(.get(url: .getMangas(page: page)), type: MangaDTO.self)
    }
    
    func findManga(search: String, page: Int) async throws(NetworkError) -> MangaDTO {
        return try await getJSON(.get(url: .findManga(search: search, page: page)), type: MangaDTO.self)
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
    
    func getMangaByGenre(genre: String, page: Int) async throws(NetworkError) -> MangaDTO {
        return try await getJSON(.get(url: .getMangaByGenre(genre: genre, page: page)), type: MangaDTO.self)
    }
    
    func getMangasByDemographic(demographic: String, page: Int) async throws(NetworkError) -> MangaDTO {
        return try await getJSON(.get(url: .getMangaByDemographic(demographic: demographic, page: page)), type: MangaDTO.self)
    }
    
    func getMangasByTheme(theme: String, page: Int) async throws(NetworkError) -> MangaDTO {
        return try await getJSON(.get(url: .getMangaByTheme(theme: theme, page: page)), type: MangaDTO.self)
    }
    
    func getAuthors(page: Int) async throws(NetworkError) -> AuthorPageDTO {
        return try await getJSON(.get(url: .getAuthors(page: page)), type: AuthorPageDTO.self)
    }
    
    func getMangasAuthor(id: String, page: Int) async throws(NetworkError) -> MangaDTO {
        return try await getJSON(.get(url: .getMangasAuthor(id: id, page: page)), type: MangaDTO.self)
    }
}
