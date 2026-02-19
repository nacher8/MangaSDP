//
//  ListMainViewIphone.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 18/2/26.
//

import SwiftUI
import SwiftData

struct ListMainViewIphone: View {
    @Environment(MangaUserViewModel.self) private var mangaUserVM
    let mangas: [MangaItem]
    let totalMangas: Int
    let context: ModelContext
    
    var body: some View {
        List {
            ForEach(mangas) { manga in
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
            if mangas.count < totalMangas {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
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
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
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
        ListMainViewIphone(
            mangas: [manga],
            totalMangas: 100,
            context: context
        )
    }
    .modelContainer(container)
    .environment(MangaUserViewModel())
}
