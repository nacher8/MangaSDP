//
//  MangaSearchViewModel.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 4/2/26.
//

import Foundation
import SwiftData

@Observable @MainActor
final class MangaSearchViewModel {
    var search = ""
    var page = 1
    let network = Network()
    
    var mangaResult: [MangaItem] = []
    var totalMangas: Int = 0
    var isLoading: Bool = false
    
    func findManga() async {
        isLoading = true
        do {
            let response = try await network.findManga(search: search, page: page)
            
            let newMangas = response.items.map { dto in
                MangaItem(id: dto.id,
                          title: dto.title ?? "",
                          titleJapanese: dto.titleJapanese ?? "",
                          titleEnglish: dto.titleEnglish ?? "",
                          sypnosis: dto.sypnosis?.removingSquareBracketContent ?? "",
                          background: dto.background ?? "",
                          startDate: dto.startDate ?? "",
                          endDate: dto.endDate ?? "",
                          volumes: dto.volumes ?? 0,
                          chapters: dto.chapters ?? 0,
                          status: dto.status.flatMap(MangaStatus.init(rawValue:)),
                          score: dto.score ?? 0.0,
                          url: dto.url.flatMap(URL.init(string:)),
                          mainPicture: dto.mainPicture.flatMap(URL.init(string:)))
            }
            
            if mangaResult.isEmpty {
                mangaResult = newMangas
            } else {
                mangaResult.append(contentsOf: newMangas)
            }
            
            totalMangas = response.metadata.total
        } catch {
            print(error)
        }
        isLoading = false
    }
    
    func loadNextPage() async {
        guard !isLoading else { return }
        guard mangaResult.count < totalMangas else { return }

        page += 1
        await findManga()
    }
    
    func reset() {
        search = ""
        page = 1
        mangaResult = []
        totalMangas = 0
    }
}
