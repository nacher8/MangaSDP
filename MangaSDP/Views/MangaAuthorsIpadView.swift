//
//  MangaAuthorsIpadView.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 19/2/26.
//

import SwiftUI
import SwiftData

struct MangaAuthorsIpadView: View {
    @Environment(\.modelContext) private var context
    @Environment(MangaAuthorsViewModel.self) private var mangaAuthorViewModel
    @Query(filter: #Predicate<Author> { $0.isFromAuthorsList == true })
    private var authors: [Author]
    
    @AppStorage("totalAuthors") private var totalAuthors: Int = 0
    
    let flexibleItems: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        @Bindable var mangaAuthorVM = mangaAuthorViewModel
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Color.orange.opacity(0.15)
                        .ignoresSafeArea()
                    
                    ScrollView {
                        if mangaAuthorVM.isLoading {
                            VStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        } else {
                            if !mangaAuthorVM.authorSearchText.isEmpty {
                                if mangaAuthorVM.authorsSearchResult.isEmpty {
                                    VStack {
                                        Spacer()
                                        searchView
                                        Spacer()
                                    }
                                } else {
                                    LazyVGrid(columns: flexibleItems) {
                                        ForEach(mangaAuthorVM.authorsSearchResult) { author in
                                            NavigationLink(value: author) {
                                                MangaAuthorRow(author: author)
                                            }
                                            .buttonStyle(.plain)
                                        }
                                    }
                                    .padding()
                                }
                            } else {
                                if authors.isEmpty {
                                    VStack {
                                        Spacer()
                                        ContentUnavailableView {
                                            Label("No Authors Yet", systemImage: "long.text.page.and.pencil.fill")
                                        } description: {
                                            Text("Pull down to refresh and load authors")
                                        }
                                        Spacer()
                                    }
                                } else {
                                    LazyVGrid(columns: flexibleItems) {
                                        ForEach(authors) { author in
                                            NavigationLink(value: author) {
                                                MangaAuthorRow(author: author)
                                            }
                                            .buttonStyle(.plain)
                                        }
                                        
                                        if authors.count < totalAuthors {
                                            HStack {
                                                Spacer()
                                                ProgressView()
                                                Spacer()
                                            }
                                            .onAppear {
                                                let modelContainer = DataContainer(modelContainer: context.container)
                                                Task {
                                                    do {
                                                        try await modelContainer.loadNextPageAuthors()
                                                    } catch {
                                                        print(error)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    .padding()
                                }
                            }
                        }
                    }
                }
                .searchable(text: $mangaAuthorVM.authorSearchText, prompt: "Search authors (min. 3 characters)")
                .autocorrectionDisabled()
                .keyboardType(.alphabet)
            }
            .navigationTitle("Authors")
            .navigationDestination(for: Author.self) { author in
                MangaAuthorsDetailView(author: author)
            }
            .refreshable {
                let modelContainer = DataContainer(modelContainer: context.container)
                do {
                    try await modelContainer.refreshAllAuthors()
                } catch {
                    print("Error refreshing: \(error)")
                }
            }
            .onChange(of: mangaAuthorVM.authorSearchText) { oldValue, newValue in
                if newValue.count >= 3 {
                    mangaAuthorVM.resetSearchAuthor()
                    Task {
                        try await mangaAuthorVM.searchAuthors()
                    }
                } else {
                    mangaAuthorVM.resetSearchAuthor()
                }
            }
        }
    }
    
    var searchView: some View {
        Group {
            if mangaAuthorViewModel.authorSearchText.count <= 2 {
                ContentUnavailableView("Keep swimming",
                                       systemImage: "keyboard",
                                       description: Text("Type at least 3 characters to search."))
            } else if mangaAuthorViewModel.authorsSearchResult.isEmpty {
                ContentUnavailableView("No authors found",
                                       systemImage: "long.text.page.and.pencil.fill",
                                       description: Text("There're no authors at the database with your search criteria."))
            }
        }
    }
}

#Preview {
    MangaAuthorsIpadView()
        .environment(MangaAuthorsViewModel())
        .modelContainer(for: [
            Author.self,
            MangaItem.self
        ])
}
