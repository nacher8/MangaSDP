//
//  MangaRow.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 27/1/26.
//

import SwiftUI

struct MangaRow: View {
    @Environment(MangaUserViewModel.self) private var mangaUserVM
    let manga: MangaItem
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(manga.title ?? "")
                    .font(.title3)
                    .bold()
                Text(manga.titleJapanese ?? "")
                    .font(.caption)
                    .padding(.bottom, 8)
                
                Text("Authors")
                    .font(.caption)
                    .bold()
                Text(manga.authorsString)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .padding(.bottom, 4)
                
                Text("Genres")
                    .font(.caption)
                    .bold()
                Text(manga.genresString)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    
                Spacer()
                HStack {
                    Text("Status:")
                        .bold()
                    Text(manga.status?.displayName ?? "Unknown")
                    
                    Spacer()
                    Text(manga.puntuation)
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                }
                .font(.caption)
            }
            Spacer()
            ZStack(alignment: .topTrailing) {
                MangaImageView(mainPicture: manga.mainPicture)
                
                if mangaUserVM.isUserCollection(manga.id) {
                    Image(systemName: "books.vertical.fill")
                        .font(.subheadline)
                        .foregroundStyle(.yellow)
                        .padding(6)
                        .background(.red, in: Circle())
                }
            }
        }
        .frame(height: 150)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 35)
                .fill(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 35)
                        .stroke(Color(.separator), lineWidth: 0.5)
                        .shadow(color: .black.opacity(0.15),
                                radius: 2,
                                x: 0,
                                y: 1)
                )
        }
    }
}

#Preview {
    MangaRow(manga: .manga)
        .environment(MangaUserViewModel())
}
