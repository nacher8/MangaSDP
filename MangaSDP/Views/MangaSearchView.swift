//
//  MangaSearchView.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 4/2/26.
//

import SwiftUI

struct MangaSearchView: View {
    @Environment(MangaUserViewModel.self) private var mangaUserVM
    @Environment(MangaSearchViewModel.self) private var searchVM
    @FocusState private var isSearchFocus: Bool
    @State private var isNavigation: Bool = false
    
    var body: some View {
        @Bindable var searchViewModel = searchVM
        NavigationStack {
            ZStack {
                Color.orange.opacity(0.15)
                    .ignoresSafeArea()
                
                VStack {
                    if searchVM.mangaResult.isEmpty {
                        searchView
                    } else {
                        List {
                            ForEach(searchVM.mangaResult) { manga in
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
                            
                            if searchVM.mangaResult.count < searchVM.totalMangas && !searchVM.isLoading {
                                HStack {
                                    Spacer()
                                    ProgressView()
                                    Spacer()
                                }
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                                .onAppear {
                                    Task {
                                        do {
                                            await searchVM.loadNextPage()
                                        }
                                    }
                                }
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                }
            }
            .navigationDestination(for: MangaItem.self) { manga in
                MangaDetailView(manga: manga)
            }
            .searchable(text: $searchViewModel.search, prompt: "Enter the name of the manga")
            .focused($isSearchFocus)
            .onChange(of: searchVM.search) { _, newValue in
                if newValue.isEmpty {
                    isSearchFocus = false
                    searchVM.reset()
                } else if searchVM.search.count >= 3 {
                    searchVM.page = 1
                    searchVM.mangaResult.removeAll()
                    Task {
                        await searchVM.findManga()
                    }
                }
            }
        }
    }
    
    var searchView: some View {
        Group {
            if searchVM.search.isEmpty {
                ContentUnavailableView("No search",
                                       systemImage: "magnifyingglass.circle",
                                       description: Text("Type at least 3 characters to find any manga by its title at the database."))
            } else if searchVM.search.count <= 2 {
                ContentUnavailableView("Keep swimming",
                                       systemImage: "keyboard",
                                       description: Text("Type at least 3 characters to search."))
            } else if !searchVM.search.isEmpty {
                ContentUnavailableView("No manga found",
                                       systemImage: "books.vertical.fill",
                                       description: Text("There's no manga at the database with your search criteria."))
            }
        }
    }
}

#Preview {
    MangaSearchView()
}
