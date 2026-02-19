//
//  MangaAuthorsDetailView.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 13/2/26.
//

import SwiftUI

struct MangaAuthorsDetailView: View {
    let author: Author
    @Environment(MangaAuthorsViewModel.self) private var mangaAuthorsVM
    @Environment(MangaUserViewModel.self) private var mangaUserVM
    
    let flexibleItems: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ZStack {
            Color.orange.opacity(0.15)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                if mangaAuthorsVM.isLoading && mangaAuthorsVM.mangaResult.isEmpty {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else if mangaAuthorsVM.mangaResult.isEmpty {
                    ContentUnavailableView("No mangas found",
                                           systemImage: "magnifyingglass.circle",
                                           description: Text("No mangas found to \(author.fullName)"))
                } else {
                    ScrollView {
                        LazyVGrid(columns: flexibleItems) {
                            ForEach(mangaAuthorsVM.mangaResult) { manga in
                                NavigationLink(value: manga) {
                                    ZStack(alignment: .topTrailing) {
                                        MangaImageView(mainPicture: manga.mainPicture, size: .list)
                                        
                                        if mangaUserVM.isUserCollection(manga.id) {
                                            Image(systemName: "books.vertical.fill")
                                                .font(.subheadline)
                                                .foregroundStyle(.yellow)
                                                .padding(6)
                                                .background(.red, in: Circle())
                                        }
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                            
                            if mangaAuthorsVM.mangaResult.count < mangaAuthorsVM.totalMangas && !mangaAuthorsVM.isLoading {
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
                                            try await mangaAuthorsVM.loadNextPage(id: author.id)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
        }
        .navigationTitle(author.fullName)
        .navigationDestination(for: MangaItem.self) { manga in
            MangaDetailView(manga: manga)
        }
        .onAppear {
            mangaAuthorsVM.resetData()
            Task {
                try await mangaAuthorsVM.getMangasAuthor(id: author.id)
            }
        }
    }
}

#Preview {
    MangaAuthorsDetailView(author: .author)
        .environment(MangaAuthorsViewModel())
        .environment(MangaUserViewModel())
}
