//
//  MangaUserView.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 3/2/26.
//

import SwiftUI
import SwiftData

struct MangaUserView: View {
    @Environment(MangaUserViewModel.self) private var mangaUserVM
    @Query private var mangas: [MangaUser]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.orange.opacity(0.15)
                    .ignoresSafeArea()
                
                if mangas.isEmpty {
                    ContentUnavailableView("No collections yet",
                                           systemImage: "books.vertical.circle",
                                           description: Text("There's no manga collection yet."))
                } else {
                    List {
                        ForEach(mangas) { mangaUser in
                            NavigationLink(value: mangaUser) {
                                MangaUserRow(mangaUser: mangaUser)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                let isUserCollection = mangaUserVM.isUserCollection(mangaUser.manga.id)
                                Button {
                                    mangaUserVM.toggleCollection(mangaUser.manga)
                                } label: {
                                    Label(isUserCollection ? "Delete" : "Add",
                                          systemImage: "books.vertical")
                                }
                                .tint(isUserCollection ? .gray : .yellow)
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .navigationDestination(for: MangaUser.self) { mangaUser in
                        MangaUserDetailView(mangaUser: mangaUser)
                    }
                }
            }
            .navigationTitle("My Collection")
        }
    }
}

#Preview {
    MangaUserView()
        .environment(MangaUserViewModel())
}
