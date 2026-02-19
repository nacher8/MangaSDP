//
//  ListFilteredViewIpad.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 19/2/26.
//

import SwiftUI

struct ListFilteredViewIpad: View {
    @Environment(MangaUserViewModel.self) private var mangaUserVM
    @Environment(MangaFilterViewModel.self) private var mangaFilterVM
    
    let flexibleItems: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: flexibleItems) {
                ForEach(mangaFilterVM.mangaResult) { manga in
                    NavigationLink(value: manga) {
                        MangaRow(manga: manga)
                    }
                    .buttonStyle(.plain)
                }
                
                if mangaFilterVM.mangaResult.count < mangaFilterVM.totalMangas {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    .onAppear {
                        Task {
                            try await mangaFilterVM.loadNextPage()
                        }
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    ListFilteredViewIpad()
        .environment(MangaUserViewModel())
        .environment(MangaFilterViewModel())
}
