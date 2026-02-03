//
//  ContentView.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 20/1/26.
//

import SwiftUI
import SwiftData

struct MangaView: View {
    @Environment(\.modelContext) private var context
    @Environment(MangaUserViewModel.self) private var mangaUserVM
    @Query private var mangas: [MangaItem]
    
    @AppStorage("totalMangas") private var totalMangas: Int = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.orange.opacity(0.15)
                    .ignoresSafeArea()
                
                if mangas.isEmpty {
                    ProgressView()
                } else {
                    List {
                        ForEach(mangas) { manga in
                            NavigationLink(value: manga) {
                                MangaRow(manga: manga, isUserCollection: mangaUserVM.isUserCollection(manga.id))
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                let isUserCollection = mangaUserVM.isUserCollection(manga.id)
                                Button {
                                    mangaUserVM.toggleCollection(manga)
                                } label: {
                                    Label(isUserCollection ? "Delete" : "Add",
                                          systemImage: "books.vertical")
                                }
                                .tint(isUserCollection ? .gray : .yellow)
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
                        if mangas.count < totalMangas {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .onAppear {
                                let modelContainer = DataContainer(modelContainer: context.container)
                                Task {
                                    do {
                                        try await modelContainer.loadNextPage()
                                    } catch {
                                        print(error)
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .navigationTitle("Saotome Manga")
                    .navigationDestination(for: MangaItem.self) { manga in
                        MangaDetailView(manga: manga)
                    }
                }
            }
            .refreshable {
                let modelContainer = DataContainer(modelContainer: context.container)
                Task {
                    do {
                        try await modelContainer.refreshAll()
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}

#Preview {
    MangaView()
}
