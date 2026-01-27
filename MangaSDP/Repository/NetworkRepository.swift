//
//  NetworkRepository.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 22/1/26.
//

import Foundation

protocol NetworkRepository: Sendable, NetworkInteractor {
    func getMangas() async throws(NetworkError) -> Manga
}

struct Network: NetworkRepository {
    func getMangas() async throws(NetworkError) -> Manga {
        return try await getJSON(.get(url: .getMangas), type: Manga.self)
    }
    func getMangas(page: Int) async throws(NetworkError) -> [MangaItemDTO] {
        return try await getJSON(.get(url: .getMangas(page: page)), type: Manga.self).items
    }
}
