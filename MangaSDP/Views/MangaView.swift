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
    @Environment(MangaUserViewModel.self) private var mangaUserVM
    @Environment(MangaFilterViewModel.self) private var mangaFilterVM
    @Query(filter: #Predicate<MangaItem> { $0.isFromMainList == true },
           sort: [SortDescriptor(\MangaItem.score, order: .reverse)])
    private var mangas: [MangaItem]
    
    @AppStorage("totalMangas") private var totalMangas: Int = 0
    @State private var showFilterSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.orange.opacity(0.15)
                    .ignoresSafeArea()
                
                if mangas.isEmpty {
                    ProgressView()
                } else {
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
                    .navigationTitle("Saotome Manga")
                    .navigationDestination(for: MangaItem.self) { manga in
                        MangaDetailView(manga: manga)
                    }
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
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showFilterSheet.toggle()
                    }, label: {
                        Image(systemName: mangaFilterVM.isApplyFilter ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                    })
                    .foregroundStyle(mangaFilterVM.isApplyFilter ? .yellow : .gray)
                }
            }
            .sheet(isPresented: $showFilterSheet) {
                MangaFilterView()
            }
        }
    }
}

#Preview {
    MangaView()
}
