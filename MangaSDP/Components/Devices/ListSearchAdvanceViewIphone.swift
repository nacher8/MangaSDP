//
//  ListSearchAdvanceIphone.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 19/2/26.
//

import SwiftUI

struct ListSearchAdvanceViewIphone: View {
    @Environment(MangaUserViewModel.self) private var mangaUserVM
    @Environment(MangaSearchAdvanceViewModel.self) private var mangaSearchAdvanceVM
    
    var body: some View {
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

#Preview {
    ListSearchAdvanceViewIphone()
        .environment(MangaUserViewModel())
        .environment(MangaSearchAdvanceViewModel())
}
