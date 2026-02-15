//
//  MangaListFilteredView.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 10/2/26.
//

import SwiftUI

struct MangaListFilteredView: View {
    @Environment(MangaUserViewModel.self) private var mangaUserVM
    @Environment(MangaFilterViewModel.self) private var mangaFilterVM
    
    var body: some View {
        VStack(spacing: 0) {
            if mangaFilterVM.isLoading && mangaFilterVM.mangaResult.isEmpty {
                Spacer()
                ProgressView()
                Spacer()
            } else if mangaFilterVM.mangaResult.isEmpty {
                ContentUnavailableView("No mangas found",
                                       systemImage: "magnifyingglass.circle",
                                       description: Text("No mangas found with the filter \(mangaFilterVM.selectedOption ?? "")"))
            } else {
                List {
                    ForEach(mangaFilterVM.mangaResult) { manga in
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
                    if mangaFilterVM.mangaResult.count < mangaFilterVM.totalMangas {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .onAppear {
                            Task {
                                try await mangaFilterVM.loadNextPage()
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
    MangaListFilteredView()
        .environment(MangaUserViewModel())
        .environment(MangaFilterViewModel())
}
