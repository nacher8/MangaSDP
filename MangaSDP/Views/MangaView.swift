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
    @State private var showAdvanceSearch: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.orange.opacity(0.15)
                    .ignoresSafeArea()
                
                if mangaFilterVM.isApplyFilter {
                    MangaListFilteredView()
                } else if mangas.isEmpty {
                    ProgressView() // mirar para meter contentUnailable
                } else {
                    MangaListMainView(mangas: mangas,
                                      totalMangas: totalMangas,
                                      context: context)
                }
            }
            .refreshable {
                if mangaFilterVM.isApplyFilter {
                    do {
                        try await mangaFilterVM.applyFilter()
                    } catch {
                        print("Error refreshing: \(error)")
                    }
                } else {
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
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showFilterSheet.toggle()
                    }, label: {
                        Image(systemName: mangaFilterVM.isApplyFilter ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                    })
                    .foregroundStyle(mangaFilterVM.isApplyFilter ? .yellow : .gray)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showAdvanceSearch.toggle()
                    }, label: {
                        Image(systemName: "magnifyingglass.circle")
                    })
                    .foregroundStyle(.gray)
                }
            }
            .sheet(isPresented: $showFilterSheet) {
                MangaFilterView()
            }
            .sheet(isPresented: $showAdvanceSearch) {
                MangaSearchAdvanceView()
            }
        }
    }
}

#Preview {
    MangaView()
        .modelContainer(for: [
            MangaItem.self,
            MangaUser.self,
            Author.self,
            Theme.self,
            Demographic.self,
            Genre.self,
            MangaCategories.self
        ], inMemory: true)
        .environment(MangaUserViewModel())
        .environment(MangaFilterViewModel())
}
