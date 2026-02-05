//
//  MangaDetailView.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 27/1/26.
//

import SwiftUI

struct MangaDetailView: View {
    @Environment(MangaUserViewModel.self) private var mangaUserVM
    let manga: MangaItem
    
    var body: some View {
        ZStack {
            Color.orange.opacity(0.15)
                .ignoresSafeArea()
            
            ScrollView {
                MangaImageView(mainPicture: manga.mainPicture, size: .detail)

                VStack {
                    Text(manga.title ?? "")
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)

                    Text(manga.titleJapanese ?? "")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Text("Chapters: \(manga.chaptersString)")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    
                    Text("Volumes: \(manga.volumesString)")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .padding()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Authors")
                        .font(.body)
                        .bold()
                        .underline()
                    
                    ForEach(manga.authors) { author in
                        HStack(alignment: .firstTextBaseline) {
                            Text(author.fullName)
                                .font(.subheadline)
                            
                            DottedLine()
                            
                            Text(author.role)
                                .font(.subheadline)
                                .italic()
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    if !manga.genres.isEmpty {
                        LabeledInlineText(title: "Genre:", value: manga.genresString)
                    }
                    
                    if !manga.themes.isEmpty {
                        LabeledInlineText(title: "Themes:", value: manga.themesString)
                    }
                    
                    if !manga.demographics.isEmpty {
                        LabeledInlineText(title: "Demographics:", value: manga.demographicsString)
                    }
                    
                    if manga.sypnosis != nil {
                        Text("Sypnosis")
                            .font(.body)
                            .bold()
                            .underline()
                        
                        Text(manga.sypnosis ?? "")
                            .font(.subheadline)
                            .italic()
                            .foregroundStyle(.secondary)
                    }
                }
                .padding()
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    mangaUserVM.toggleCollection(manga)
                } label: {
                    Image(systemName: mangaUserVM.isUserCollection(manga.id) ? "books.vertical.fill" : "books.vertical")
                }
                .tint(mangaUserVM.isUserCollection(manga.id) ? .yellow : .gray)
            }
        }
    }
}

#Preview {
    MangaDetailView(manga: .manga)
}
