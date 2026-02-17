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
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.orange.opacity(0.15)
                    .ignoresSafeArea()

                Form {
                    Section {
                        DisclosureGroup("Select Category") {
                            ForEach(MangaFilterType.allCases) { filterType in
                                HStack {
                                    Image(systemName: iconForFilterType(filterType))
                                        .font(.body)
                                        .foregroundStyle(.secondary)
                                    
                                    Text(filterType.rawValue)
                                        .font(.body)
                                        .foregroundStyle(.secondary)
                                    
                                    Spacer()
                                    
                                    Button {
                                        mangaFilterVM.changeFilterType(filterType)
                                    } label: {
                                        if mangaFilterVM.selectedFilter == filterType {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundStyle(.yellow)
                                        } else {
                                            Image(systemName: "circle")
                                                .foregroundStyle(.gray)
                                        }
                                    }
                                }
                                
                            }
                        }
                    } header: {
                        Text("Categories")
                    }
                    .listRowBackground(Color.white.opacity(0.8))
                    
                    if let selectedFilter = mangaFilterVM.selectedFilter {
                        Section {
                            if mangaFilterVM.availableOptions.isEmpty {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle")
                                        .foregroundStyle(.orange)
                                    Text("No options available")
                                        .font(.body)
                                        .foregroundStyle(.secondary)
                                }
                            } else {
                                DisclosureGroup("Select \(selectedFilter.rawValue)") {
                                    ForEach(mangaFilterVM.availableOptions, id: \.self) { option in
                                        HStack {
                                            Text(option)
                                                .font(.body)
                                                .foregroundStyle(.secondary)
                                            
                                            Spacer()
                                            
                                            Button {
                                                mangaFilterVM.selectOption(option)
                                            } label: {
                                                if mangaFilterVM.isOptionSelected(option) {
                                                    Image(systemName: "checkmark.circle.fill")
                                                        .foregroundStyle(.yellow)
                                                } else {
                                                    Image(systemName: "circle")
                                                        .foregroundStyle(.gray)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        } header: {
                            Text("\(selectedFilter.rawValue)s")
                        }
                        .listRowBackground(Color.white.opacity(0.8))
                    }
                    
                    Section {
                        Button(action: {
                            Task {
                                try await mangaFilterVM.applyFilter()
                                dismiss()
                            }
                        }) {
                            HStack {
                                Spacer()
                                Image(systemName: "line.3.horizontal.decrease.circle")
                                    .font(.body)
                                Text("Filter")
                                    .font(.headline)
                                Spacer()
                            }
                            .padding(.vertical, 8)
                        }
                        .disabled(mangaFilterVM.selectedOption == nil)
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.roundedRectangle(radius: 12))
                        .tint(.yellow)
                        .listRowBackground(Color.clear)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Filter category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        mangaFilterVM.clearFilter()
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                    }
                }
                
                ToolbarItem {
                    Button(role: .close) {
                        dismiss()
                    }
                }
            }
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

    private func iconForFilterType(_ type: MangaFilterType) -> String {
        switch type {
        case .genre:
            return "tag.fill"
        case .demographic:
            return "person.2.fill"
        case .theme:
            return "sparkles"
        }
    }
}


#Preview {
    MangaFilterView()
        .environment(MangaFilterViewModel())
}
