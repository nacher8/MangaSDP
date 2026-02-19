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
                if isiPhone {
                    ListSearchAdvanceViewIphone()
                } else {
                    ListSearchAdvanceViewIpad()
                }
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
