//
//  MangaFilterOptionsSection.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 10/2/26.
//

import SwiftUI

struct MangaFilterOptionsSection: View {
    @Environment(MangaFilterViewModel.self) private var mangaFilterVM
    @Environment(\.dismiss) private var dismiss
    let selectedFilter: MangaFilterType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Available \(selectedFilter.rawValue)s")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text("\(mangaFilterVM.availableOptions.count)")
                    .font(.caption)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue)
                    .clipShape(Capsule())
            }
            
            if mangaFilterVM.availableOptions.isEmpty {
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundStyle(.orange)
                    Text("No options available")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding()
            } else {
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(mangaFilterVM.availableOptions, id: \.self) { option in
                            MangaFilterOptionRow(
                                option: option,
                                isSelected: mangaFilterVM.isOptionSelected(option)
                            ) {
                                mangaFilterVM.selectOption(option)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                }
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                }
                
                if mangaFilterVM.selectedOption != nil {
                    VStack(spacing: 4) {
                        Button(action: {
                            mangaFilterVM.clearFilter()
                        }) {
                            HStack {
                                Image(systemName: "xmark.circle.fill")
                                Text("Clear")
                            }
                            .font(.subheadline)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        
                        Button(action: {
                            Task {
                                await mangaFilterVM.applyFilter()
                                dismiss()
                            }
                        }) {
                            HStack {
                                if mangaFilterVM.isLoading {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Image(systemName: "checkmark.circle.fill")
                                }
                                Text("Apply Filter")
                            }
                            .font(.subheadline)
                            .bold()
                            .foregroundStyle(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .disabled(mangaFilterVM.isLoading)
                    }
                }
            }
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: selectedFilter)
    }
}

#Preview() {
    let filterVM = MangaFilterViewModel()
    filterVM.genres = ["Action","Adventure","Comedy","Drama"]
    filterVM.selectedFilter = .genre
    
    return MangaFilterOptionsSection(selectedFilter: .genre)
        .environment(filterVM)
}
