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
    @Environment(MangaFilterViewModel.self) private var mangaFilterViewModel
    @Environment(MangaSearchAdvanceViewModel.self) private var mangaSearchAdvanceViewModel
    
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Mangas", systemImage: "book", value: 0) {
                MangaView()
            }
            Tab("Authors", systemImage: "long.text.page.and.pencil.fill", value: 1) {
                if isiPhone {
                    MangaAuthorsView()
                } else {
                    MangaAuthorsIpadView()
                }
            }
            Tab("User", systemImage: "person", value: 2) {
                MangaUserView()
            }
        }
        .task {
            mangaUserViewModel.setModelContext(modelContext)
            mangaFilterViewModel.setModelContext(modelContext)
            mangaSearchAdvanceViewModel.setModelContext(modelContext)
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
        .environment(MangaFilterViewModel())
        .environment(MangaSearchAdvanceViewModel())
}
