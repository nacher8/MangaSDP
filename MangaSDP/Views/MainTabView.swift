//
//  MainTabView.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 27/1/26.
//

import SwiftUI

@MainActor let isiPhone = UIDevice.current.userInterfaceIdiom == .phone

struct MainTabView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(MangaUserViewModel.self) private var mangaUserViewModel
    @Environment(MangaSearchViewModel.self) private var mangaSearchViewModel
    
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
            mangaSearchViewModel.setModelContext(modelContext)
        }
    }
}

#Preview {
    MainTabView()
}
