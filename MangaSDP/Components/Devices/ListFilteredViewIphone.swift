//
//  ListFilteredViewIphone.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 18/2/26.
//

import SwiftUI

struct ListFilteredViewIphone: View {
    @Environment(MangaUserViewModel.self) private var mangaUserVM
    @Environment(MangaFilterViewModel.self) private var mangaFilterVM
    
    var body: some View {
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

#Preview {
    ListFilteredViewIphone()
        .environment(MangaUserViewModel())
        .environment(MangaFilterViewModel())
}
