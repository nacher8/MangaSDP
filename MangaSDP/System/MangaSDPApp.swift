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
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [MangaItem.self,
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
