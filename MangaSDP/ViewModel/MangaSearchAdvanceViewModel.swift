//
//  MangaSearchAdvanceViewModel.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 16/2/26.
//

import Foundation
import SwiftData

@Observable @MainActor
final class MangaSearchAdvanceViewModel {
    var genres: [String] = []
    var demographics: [String] = []
    var themes: [String] = []
    
    var mangaTitle: String = ""
    var mangaFirstName: String = ""
    var mangaLastName: String = ""
    var selectedGenres: [String] = []
    var selectedThemes: [String] = []
    var selectedDemographics: [String] = []
    
    var isSearchValid: Bool {
        !mangaTitle.isEmpty ||
        !mangaFirstName.isEmpty ||
        !mangaLastName.isEmpty ||
        !selectedGenres.isEmpty ||
        !selectedThemes.isEmpty ||
        !selectedDemographics.isEmpty
    }
    
    let network = Network()
    var mangaResult: [MangaItem] = []
    var page = 1
    var totalMangas: Int = 0
    var isAdvanceSearch = false
    var isLoading: Bool = false
    
    private var modelContext: ModelContext?
    
    func setModelContext(_ context: ModelContext) {
        modelContext = context
    }
    
    func loadCategories() async {
        guard let context = modelContext else { return }
        
        let fetch = FetchDescriptor<MangaCategories>()
        if let categories = try? context.fetch(fetch).first {
            genres = categories.genres.sorted()
            demographics = categories.demographics.sorted()
            themes = categories.themes.sorted()
        }
    }
    
    func toggleGenre(_ genre: String) {
        if selectedGenres.contains(genre) {
            selectedGenres.removeAll { $0 == genre }
        } else {
            selectedGenres.append(genre)
        }
    }
    
    func toggleTheme(_ theme: String) {
        if selectedThemes.contains(theme) {
            selectedThemes.removeAll { $0 == theme }
        } else {
            selectedThemes.append(theme)
        }
    }
    
    func toggleDemographic(_ demographic: String) {
        if selectedDemographics.contains(demographic) {
            selectedDemographics.removeAll { $0 == demographic }
        } else {
            selectedDemographics.append(demographic)
        }
    }
    
    func searchAdvance() async throws {
        var customSearch: CustomSearch = CustomSearch(searchContains: !selectedGenres.isEmpty || !selectedThemes.isEmpty || !selectedDemographics.isEmpty)
        if !mangaTitle.isEmpty {
            customSearch.searchTitle = mangaTitle
        }
        if !mangaFirstName.isEmpty {
            customSearch.searchAuthorFirstName = mangaFirstName
        }
        if !mangaLastName.isEmpty {
            customSearch.searchAuthorLasttName = mangaLastName
        }
        if !selectedGenres.isEmpty {
            customSearch.searchGenres = selectedGenres
        }
        if !selectedThemes.isEmpty {
            customSearch.searchThemes = selectedThemes
        }
        if !selectedDemographics.isEmpty {
            customSearch.searchDemographics = selectedDemographics
        }
        
        isLoading = true
        
        let response: MangaDTO
        do {
            response = try await network.getMangasAdvanceSearch(customSearch: customSearch, page: page)
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
        isAdvanceSearch = true
        isLoading = false
    }
    
    func loadNextPage() async throws {
        guard mangaResult.count < totalMangas else { return }
        
        page += 1
        
        try await searchAdvance()
    }
    
    func refreshAdvanceSearch() async throws {
        page = 1
        try await searchAdvance()
    }

    func reset() {
        mangaTitle = ""
        mangaFirstName = ""
        mangaLastName = ""
        selectedGenres = []
        selectedThemes = []
        selectedDemographics = []
        isAdvanceSearch = false
    }
    
    func resetData() {
        mangaResult = []
        totalMangas = 0
        page = 1
    }
}
