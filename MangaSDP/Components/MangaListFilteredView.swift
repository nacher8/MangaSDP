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
                if isiPhone {
                    ListFilteredViewIphone()
                } else {
                    ListFilteredViewIpad()
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
    MangaListFilteredView()
        .environment(MangaUserViewModel())
        .environment(MangaFilterViewModel())
}
