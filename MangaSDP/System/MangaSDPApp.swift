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
    @State private var mangaSearchVM = MangaSearchViewModel()
    @State private var mangaFilterVM = MangaFilterViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(mangaUserVM)
                .environment(mangaSearchVM)
                .environment(mangaFilterVM)
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
                    try await modelContainer.loadInitialData()
                } catch {
                    print(error)
                }
            }
        }
    }
}
