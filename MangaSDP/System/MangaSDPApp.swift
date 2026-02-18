//
//  MangaSDPApp.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 20/1/26.
//

import SwiftUI
import SwiftData

@main
struct MangaSDPApp: App {
    @State private var mangaUserVM = MangaUserViewModel()
    @State private var mangaFilterVM = MangaFilterViewModel()
    @State private var mangaAuthorVM = MangaAuthorsViewModel()
    @State private var mangaSearchAdvanceVM = MangaSearchAdvanceViewModel()
    
    var body: some Scene {
        WindowGroup {
            MangaRootView()
                .environment(mangaUserVM)
                .environment(mangaFilterVM)
                .environment(mangaAuthorVM)
                .environment(mangaSearchAdvanceVM)
                .preferredColorScheme(.light)
        }
        .modelContainer(for: [MangaItem.self,
                              MangaUser.self,
                              Author.self,
                              Theme.self,
                              Demographic.self,
                              Genre.self,
                              MangaCategories.self]) { result in
            guard case .success(let container) = result else {
                return
            }
            Task.detached(priority: .high) {
                let modelContainer = DataContainer(modelContainer: container)
                do {
                    // Verificar y cargar datos de mangas
                    let hasData = try await modelContainer.hasExistingData()
                    if !hasData {
                        try await modelContainer.loadInitialData()
                    }
                    // Verificar y cargar lista completa de autores
                    let hasDataAuthors = try await modelContainer.hasExistingAuthorsData()
                    if !hasDataAuthors {
                        try await modelContainer.loadInitialDataAuthors()
                    }
                } catch {
                    print("Error verificando/cargando datos: \(error)")
                }
            }
        }
    }
}
