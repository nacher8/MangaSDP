//
//  MainTabView.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 27/1/26.
//

import SwiftUI
import SwiftData

@MainActor let isiPhone = UIDevice.current.userInterfaceIdiom == .phone

struct MainTabView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(MangaUserViewModel.self) private var mangaUserViewModel
    @Environment(MangaSearchViewModel.self) private var mangaSearchViewModel
    @Environment(MangaFilterViewModel.self) private var mangaFilterViewModel
    
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Mangas", systemImage: "book", value: 0) {
                if isiPhone {
                    MangaView()
                } else {
                    
                }
            }
            Tab("Authors", systemImage: "long.text.page.and.pencil.fill", value: 1) {
                if isiPhone {
                    MangaAuthorsView()
                } else {
                    
                }
            }
            Tab("Search", systemImage: "magnifyingglass", value: 2, role: .search) {
                MangaSearchView()
            }
            Tab("User", systemImage: "person", value: 3) {
                MangaUserView()
            }
        }
        .onChange(of: selectedTab, { oldValue, newValue in
            if oldValue == 2 && newValue != 2 {
                mangaSearchViewModel.reset()
            }
        })
        .task {
            mangaUserViewModel.setModelContext(modelContext)
            mangaFilterViewModel.setModelContext(modelContext)
        }
    }
}

#Preview {
    MainTabView()
        .modelContainer(for: [
            MangaItem.self,
            MangaUser.self,
            Author.self,
            Theme.self,
            Demographic.self,
            Genre.self,
            MangaCategories.self
        ], inMemory: true)
        .environment(MangaUserViewModel())
        .environment(MangaSearchViewModel())
        .environment(MangaFilterViewModel())
}
