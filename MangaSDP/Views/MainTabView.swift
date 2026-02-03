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
    
    var body: some View {
        TabView {
            Tab("Mangas", systemImage: "book") {
                if isiPhone {
                    MangaView()
                } else {
                    
                }
            }
            Tab("Authors", systemImage: "long.text.page.and.pencil.fill") {
                if isiPhone {
                    
                } else {
                    
                }
            }
            Tab("Search", systemImage: "magnifyingglass") {
                
            }
            Tab("User", systemImage: "person") {
                MangaUserView()
            }
        }
        .task {
            mangaUserViewModel.setModelContext(modelContext)
        }
    }
}

#Preview {
    MainTabView()
}
