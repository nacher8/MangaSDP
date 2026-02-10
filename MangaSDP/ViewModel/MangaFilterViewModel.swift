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
    
    func applyFilter() {
        isApplyFilter = true
    }
    
    func clearFilter() {
        selectedFilter = nil
        selectedOption = nil
        isApplyFilter = false
    }
    
    func changeFilterType(_ newType: MangaFilterType) {
        if selectedFilter != newType {
            selectedOption = nil
        }
        selectedFilter = newType
    }
}
