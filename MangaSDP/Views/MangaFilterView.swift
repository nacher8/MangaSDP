//
//  MangaFilterView.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 9/2/26.
//

import SwiftUI
import SwiftData

struct MangaFilterView: View {
    @Environment(MangaFilterViewModel.self) private var mangaFilterVM

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Select category")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
                VStack(spacing: 8) {
                    ForEach(MangaFilterType.allCases) { filterType in
                        MangaFilterTypeRow(
                            filterType: filterType,
                            isSelected: mangaFilterVM.selectedFilter == filterType
                        ) {
                            mangaFilterVM.changeFilterType(filterType)
                        }
                    }
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                }
            }
            
            if let selectedFilter = mangaFilterVM.selectedFilter {
                MangaFilterOptionsSection(selectedFilter: selectedFilter)
            }
            Spacer()
        }
        .padding()
        .onAppear {
            Task {
                await mangaFilterVM.loadFilters()
            }
            if !mangaFilterVM.isApplyFilter {
                mangaFilterVM.clearFilter()
            }
        }
    }
}

#Preview {
    MangaFilterView()
        .environment(MangaFilterViewModel())
}
