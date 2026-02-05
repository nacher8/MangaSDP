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
    
    private var modelContext: ModelContext?
    
    func setModelContext(_ context: ModelContext) {
        modelContext = context
    }
    
    func findManga() async {
        isLoading = true
        do {
            let response = try await network.findManga(search: search, page: page)

            try await saveMangasToSwiftData(response.items)
            
            totalMangas = response.metadata.total
        } catch {
            print(error)
        }
        isLoading = false
    }
    
    private func saveMangasToSwiftData(_ dtos: [MangaItemDTO]) async throws {
        guard let contex = modelContext else { return }
        
        let container = DataContainer(modelContainer: contex.container)
        
        do {
            try await container.loadMangas(mangas: dtos)
            
            var savedMangas: [MangaItem] = []
            
            for dto in dtos {
                let mangaID = dto.id
                let fetch = FetchDescriptor<MangaItem>(predicate: #Predicate { $0.id == mangaID })
                if let savedManga = try? contex.fetch(fetch).first {
                    savedMangas.append(savedManga)
                }
            }
            
            if mangaResult.isEmpty {
                mangaResult = savedMangas
            } else {
                mangaResult.append(contentsOf: savedMangas)
            }
            
        } catch {
            print(error)
        }
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
