//
//  MangaUserDetailView.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 3/2/26.
//

import SwiftUI
import SwiftData

struct MangaUserDetailView: View {
    @Environment(MangaUserViewModel.self) private var mangaUserVM
    @Bindable var mangaUser: MangaUser
    
    var body: some View {
        if let manga = mangaUser.manga {
            detailView(for: manga)
        } else {
            ContentUnavailableView(
                "Manga not available",
                systemImage: "exclamationmark.triangle",
                description: Text("This manga does not exist in the database.")
            )
        }
    }
    
    @ViewBuilder
    private func detailView(for manga: MangaItem) -> some View {
        ZStack {
            Color.orange.opacity(0.15)
                .ignoresSafeArea()
            
            Form {
                Section {
                    VStack(spacing: 12) {
                        MangaImageView(mainPicture: manga.mainPicture, size: .list)
                            .frame(maxWidth: .infinity)
                        
                        Text(manga.title ?? "")
                            .font(.title2)
                            .bold()
                            .multilineTextAlignment(.center)

                        Text(manga.titleJapanese ?? "")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .listRowBackground(Color.clear)
                
                Section("Progress") {
                    if let totalVolumes = manga.volumes {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Collection Progress")
                                Spacer()
                                Text("\(mangaUser.ownedVolumes) / \(totalVolumes)")
                                    .foregroundStyle(.secondary)
                            }
                            if totalVolumes > 0 {
                                ProgressView(value: Double(mangaUser.ownedVolumes), total: Double(totalVolumes))
                                    .tint(mangaUser.isCompleted ? .green : .orange)
                            }
                        }
                    }
                    
                    if mangaUser.isCompleted {
                        Label("Collection Complete!", systemImage: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    }
                }
                
                Section("Owned Volumes") {
                    Stepper(
                        value: $mangaUser.ownedVolumes,
                        in: 0...(manga.volumes ?? 999),
                        step: 1
                    ) {
                        HStack {
                            Text("Volumes Owned")
                            Spacer()
                            Text("\(mangaUser.ownedVolumes)")
                                .font(.title2)
                                .bold()
                                .monospacedDigit()
                        }
                    }
                    .onChange(of: mangaUser.ownedVolumes) { oldValue, newValue in
                        if mangaUser.currentVolume > newValue {
                            mangaUser.currentVolume = newValue
                        }
                        mangaUserVM.saveUserCollection()
                    }
                }
                
                Section("Reading Progress") {
                    Stepper(
                        value: $mangaUser.currentVolume,
                        in: 0...mangaUser.ownedVolumes,
                        step: 1
                    ) {
                        HStack {
                            Text("Current Volume")
                            Spacer()
                            Text("\(mangaUser.currentVolume)")
                                .font(.title2)
                                .bold()
                                .monospacedDigit()
                        }
                    }
                    .onChange(of: mangaUser.currentVolume) { _, _ in
                        mangaUserVM.saveUserCollection()
                    }
                }
                
                Section("Manga Information") {
                    LabeledContent("Status", value: manga.status?.displayName ?? "Unknown")
                    LabeledContent {
                        HStack {
                            Text(manga.puntuation)
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)
                        }
                    } label: {
                        Text("Score")
                    }
                    
                    if let totalVolumes = manga.volumes {
                        LabeledContent("Total Volumes", value: "\(totalVolumes)")
                    }
                    
                    if let chapters = manga.chapters {
                        LabeledContent("Total Chapters", value: "\(chapters)")
                    }
                }
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Collection Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MangaUserDetailView(mangaUser: .mangaUser)
        .environment(MangaUserViewModel())
}
