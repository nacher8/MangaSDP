//
//  MangaFilterViewModel.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 9/2/26.
//

import Foundation
import SwiftData

@Observable @MainActor
final class MangaFilterViewModel {
    var genres: [String] = []
    var demographics: [String] = []
    var themes: [String] = []
    var selectedFilter: MangaFilterType?
    
    var selectedOption: String?
    
    let network = Network()
    var mangaResult: [MangaItem] = []
    var page = 1
    var totalMangas: Int = 0

    private var modelContext: ModelContext?
    
    var isApplyFilter: Bool = false
    var isLoading: Bool = false
    
    var availableOptions: [String] {
        switch selectedFilter {
        case .genre:
            return genres
        case .demographic:
            return demographics
        case .theme:
            return themes
        case .none:
            return []
        }
    }
    
    func setModelContext(_ context: ModelContext) {
        modelContext = context
    }
    
    func loadFilters() async {
        guard let context = modelContext else { return }
        
        let fetch = FetchDescriptor<MangaCategories>()
        if let categories = try? context.fetch(fetch).first {
            genres = categories.genres.sorted()
            demographics = categories.demographics.sorted()
            themes = categories.themes.sorted()
        }
        
    }
    
    func selectOption(_ option: String) {
        if selectedOption == option {
            selectedOption = nil
        } else {
            selectedOption = option
        }
    }
    
    func isOptionSelected(_ option: String) -> Bool {
        return selectedOption == option
    }
    
    func applyFilter() async {
        guard let filter = selectedFilter,
              let option = selectedOption else { return }
        
        isLoading = true
        page = 1
        mangaResult = []
        
        do {
            let response: Manga
            
            switch filter {
            case .genre:
                response = try await network.getMangaByGenre(genre: option, page: page)
            case .demographic:
                response = try await network.getMangasByDemographic(demographic: option, page: page)
            case .theme:
                response = try await network.getMangasByTheme(theme: option, page: page)
            }
            
            mangaResult = mapDTOsToMangaItems(response.items)
            totalMangas = response.metadata.total
            isApplyFilter = true
            
        } catch {
            print("Error applying filter: \(error)")
        }
        
        isLoading = false
    }
    
    func loadNextPage() async {
        guard !isLoading else { return }
        guard mangaResult.count < totalMangas else { return }
        guard let filter = selectedFilter,
              let option = selectedOption else { return }
        
        isLoading = true
        page += 1
        
        do {
            let response: Manga
            
            switch filter {
            case .genre:
                response = try await network.getMangaByGenre(genre: option, page: page)
            case .demographic:
                response = try await network.getMangasByDemographic(demographic: option, page: page)
            case .theme:
                response = try await network.getMangasByTheme(theme: option, page: page)
            }
            
            let newMangas = mapDTOsToMangaItems(response.items)
            mangaResult.append(contentsOf: newMangas)
            
        } catch {
            print("Error loading next page: \(error)")
        }
        
        isLoading = false
    }
    
    func clearFilter() {
        selectedFilter = nil
        selectedOption = nil
        isApplyFilter = false
        mangaResult = []
        totalMangas = 0
        page = 1
    }
    
    func changeFilterType(_ newType: MangaFilterType) {
        if selectedFilter != newType {
            selectedOption = nil
        }
        selectedFilter = newType
    }
    
    private func mapDTOsToMangaItems(_ dtos: [MangaItemDTO]) -> [MangaItem] {
        dtos.map { dto in
            let mangaItem = MangaItem(id: dto.id,
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
                                      mainPicture: dto.mainPicture.flatMap(URL.init(string:)),
                                      isFromMainList: false)
            
            // Crear las relaciones (sin insertar en SwiftData)
            mangaItem.genres = dto.genres.map { genreDTO in
                Genre(id: genreDTO.id, genre: genreDTO.genre)
            }
            
            mangaItem.themes = dto.themes.map { themeDTO in
                Theme(id: themeDTO.id, theme: themeDTO.theme)
            }
            
            mangaItem.demographics = dto.demographics.map { demographicDTO in
                Demographic(id: demographicDTO.id, demographic: demographicDTO.demographic)
            }
            
            mangaItem.authors = dto.authors.map { authorDTO in
                Author(id: authorDTO.id,
                       firstName: authorDTO.firstName,
                       lastName: authorDTO.lastName,
                       role: authorDTO.role)
            }
            
            return mangaItem
        }
    }
}
