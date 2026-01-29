//
//  ContentView.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 20/1/26.
//

import SwiftUI
import SwiftData

struct MangaView: View {
    @Environment(\.modelContext) private var context
    @Query private var mangas: [MangaItem]
    
    @AppStorage("totalMangas") private var totalMangas: Int = 0
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(mangas) { manga in
                    NavigationLink(value: manga) {
                        MangaRow(manga: manga)
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
            .background(Color.orange.opacity(0.15))
            .navigationTitle("Saotome Manga")
            .navigationDestination(for: MangaItem.self) { manga in
                MangaDetailView(manga: manga)
            }
        }
        .refreshable {
            let modelContainer = DataContainer(modelContainer: context.container)
            Task {
                do {
                    try await modelContainer.refreshAll()
                } catch {
                    print(error)
                }
            }
        }
    }
}

#Preview {
    MangaView()
}
