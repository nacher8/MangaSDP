//
//  MainTabView.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 27/1/26.
//

import SwiftUI

@MainActor let isiPhone = UIDevice.current.userInterfaceIdiom == .phone

struct MainTabView: View {
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
                
            }
        }
    }
}

#Preview {
    MainTabView()
}
