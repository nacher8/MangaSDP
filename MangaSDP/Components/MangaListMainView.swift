//
//  MangaListMainView.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 10/2/26.
//

import SwiftUI
import SwiftData

struct MangaListMainView: View {
    @Environment(MangaUserViewModel.self) private var mangaUserVM
    let mangas: [MangaItem]
    let totalMangas: Int
    let context: ModelContext
    
    var body: some View {
        VStack(spacing: 0) {
            if isiPhone {
                ListMainViewIphone(mangas: mangas, totalMangas: totalMangas, context: context)
            } else {
                ListMainViewIpad(mangas: mangas, totalMangas: totalMangas, context: context)
            }
        }
        .navigationTitle("Saotome Manga")
        .navigationDestination(for: MangaItem.self) { manga in
            MangaDetailView(manga: manga)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: MangaItem.self,
        MangaUser.self,
        Author.self,
        Theme.self,
        Demographic.self,
        Genre.self,
        MangaCategories.self, configurations: config)
    let context = container.mainContext
    
    let manga = MangaItem.manga
    manga.isFromMainList = true
    context.insert(manga)
    try? context.save()
    
    return NavigationStack {
        MangaListMainView(
            mangas: [manga],
            totalMangas: 100,
            context: context
        )
    }
    .modelContainer(container)
    .environment(MangaUserViewModel())
}
