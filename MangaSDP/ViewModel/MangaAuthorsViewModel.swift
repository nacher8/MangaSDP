//
//  MangaAuthorsViewModel.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 13/2/26.
//

import Foundation
import SwiftData

@Observable @MainActor
final class MangaAuthorsViewModel {
    var page = 1
    let network = Network()
    
    var mangaResult: [MangaItem] = []
    var totalMangas: Int = 0
    var isLoading: Bool = false
    
    var authorSearchText: String = ""
    var authorsSearchResult: [Author] = []
    var isSearchAuthors: Bool = false
    
    // MARK: - Get mangas Author
    func getMangasAuthor(id: String) async throws {
        isLoading = true
        isSearchAuthors = true
        
        let response: MangaDTO
        do {
            response = try await network.getMangasAuthor(id: id, page: page)
        } catch {
            print("Error en llamada API: \(error)")
            isLoading = false
            return
        }
        
        let newMangas = Utils.mapDTOsToMangaItems(response.items)
        
        if page == 1 {
            mangaResult = newMangas
        } else {
            mangaResult.append(contentsOf: newMangas)
        }
        
        totalMangas = response.metadata.total
        isLoading = false
    }
    
    func loadNextPage(id: String) async throws {
        guard !isLoading else { return }
        guard mangaResult.count < totalMangas else { return }
        
        page += 1
        
        try await getMangasAuthor(id: id)
    }
    
    func resetData() {
        mangaResult = []
        totalMangas = 0
        page = 1
    }
    
    // MARK: - Search Authors
    func searchAuthors() async throws {
        isLoading = true
        
        let response: [AuthorDTO]
        
        do {
            response = try await network.findAuthor(search: authorSearchText)
        } catch {
            print("Error en llamada API: \(error)")
            isLoading = false
            return
        }
        
        authorsSearchResult = Utils.mapDTOsToAuthors(response)
        isSearchAuthors = true
        isLoading = false
    }
    
    func resetSearchAuthor() {
        authorsSearchResult = []
        isSearchAuthors = false
    }
}
