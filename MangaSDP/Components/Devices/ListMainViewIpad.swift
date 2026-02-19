//
//  ListMainViewIpad.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 18/2/26.
//

import SwiftUI
import SwiftData

struct ListMainViewIpad: View {
    @Environment(MangaUserViewModel.self) private var mangaUserVM
    let mangas: [MangaItem]
    let totalMangas: Int
    let context: ModelContext
    
    let flexibleItems: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: flexibleItems) {
                ForEach(mangas) { manga in
                    NavigationLink(value: manga) {
                        MangaRow(manga: manga)
                    }
                    .buttonStyle(.plain)
                }
                if mangas.count < totalMangas {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    .onAppear {
                        let modelContainer = DataContainer(modelContainer: context.container)
                        Task {
                            do {
                                try await modelContainer.loadNextPage()
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
        ListMainViewIpad(
            mangas: [manga],
            totalMangas: 100,
            context: context
        )
    }
    .modelContainer(container)
    .environment(MangaUserViewModel())
}
