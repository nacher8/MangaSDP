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
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(mangaUserVM)
        }
        .modelContainer(for: [MangaItem.self,
                              MangaUser.self,
                              Author.self,
                              Theme.self,
                              Demographic.self,
                              Genre.self]) { result in
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
