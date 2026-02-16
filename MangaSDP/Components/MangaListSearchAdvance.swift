//
//  MangaListAdvancedSearch.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 16/2/26.
//

import SwiftUI

struct MangaListSearchAdvance: View {
    @Environment(MangaUserViewModel.self) private var mangaUserVM
    @Environment(MangaSearchAdvanceViewModel.self) private var mangaSearchAdvanceVM
    
    var body: some View {
        VStack(spacing: 0) {
            if mangaSearchAdvanceVM.isLoading && mangaSearchAdvanceVM.mangaResult.isEmpty {
                Spacer()
                ProgressView()
                Spacer()
            } else if mangaSearchAdvanceVM.mangaResult.isEmpty {
                ContentUnavailableView("No mangas found",
                                       systemImage: "magnifyingglass.circle",
                                       description: Text("No mangas found in the advanced search"))
            } else {
                List {
                    ForEach(mangaSearchAdvanceVM.mangaResult) { manga in
                        NavigationLink(value: manga) {
                            MangaRow(manga: manga)
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
                    
                    // Paginación para resultados filtrados
                    if mangaSearchAdvanceVM.mangaResult.count < mangaSearchAdvanceVM.totalMangas {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .onAppear {
                            Task {
                                try await mangaSearchAdvanceVM.loadNextPage()
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        .navigationTitle("Saotome Manga")
        .navigationDestination(for: MangaItem.self) { manga in
            MangaDetailView(manga: manga)
        }
    }
}

#Preview {
    MangaListSearchAdvance()
        .environment(MangaUserViewModel())
        .environment(MangaSearchAdvanceViewModel())
}
