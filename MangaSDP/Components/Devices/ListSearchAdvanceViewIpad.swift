//
//  ListSearchAdvanceViewIpad.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 19/2/26.
//

import SwiftUI

struct ListSearchAdvanceViewIpad: View {
    @Environment(MangaUserViewModel.self) private var mangaUserVM
    @Environment(MangaSearchAdvanceViewModel.self) private var mangaSearchAdvanceVM
    
    let flexibleItems: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: flexibleItems) {
                ForEach(mangaSearchAdvanceVM.mangaResult) { manga in
                    NavigationLink(value: manga) {
                        MangaRow(manga: manga)
                    }
                    .buttonStyle(.plain)
                }
                
                if mangaSearchAdvanceVM.mangaResult.count < mangaSearchAdvanceVM.totalMangas {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    .onAppear {
                        Task {
                            try await mangaSearchAdvanceVM.loadNextPage()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ListSearchAdvanceViewIpad()
        .environment(MangaUserViewModel())
        .environment(MangaSearchAdvanceViewModel())
}
