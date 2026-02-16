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
    @Environment(MangaSearchAdvanceViewModel.self) private var mangaSearchAdvanceVM
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
                
                switch viewState {
                case .filtered:
                    MangaListFilteredView()
                case .searchAdvance:
                    MangaListSearchAdvance()
                case .loading:
                    ProgressView() // mirar para meter contentUnailable
                case .loaded:
                    MangaListMainView(mangas: mangas,
                                      totalMangas: totalMangas,
                                      context: context)
                }
            }
            .refreshable {
                if mangaFilterVM.isApplyFilter {
                    do {
                        try await mangaFilterVM.refreshFilter()
                    } catch {
                        print("Error refreshing filter: \(error)")
                    }
                } else if mangaSearchAdvanceVM.isAdvanceSearch {
                    do {
                        try await mangaSearchAdvanceVM.refreshAdvanceSearch()
                    } catch {
                        print("Error refreshing search: \(error)")
                    }
                } else {
                    let modelContainer = DataContainer(modelContainer: context.container)
                    Task {
                        do {
                            try await modelContainer.refreshAll()
                        } catch {
                            print("Error refreshing mangas: \(error)")
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
                        Image(systemName: "magnifyingglass")
                    })
                    .foregroundStyle(mangaSearchAdvanceVM.isAdvanceSearch ? .yellow : .gray)
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
    
    var viewState: MangaListState {
        if mangaFilterVM.isApplyFilter {
            return .filtered
        } else if mangaSearchAdvanceVM.isAdvanceSearch {
            return .searchAdvance
        } else if mangas.isEmpty {
            return .loading
        } else {
            return .loaded
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
