//
//  MangaUserRow.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 3/2/26.
//

import SwiftUI

struct MangaUserRow: View {
    let mangaUser: MangaUser
    
    var body: some View {
        if let manga = mangaUser.manga {
            HStack(alignment: .top) {
                MangaImageView(mainPicture: manga.mainPicture, size: .user)
                
                VStack(alignment: .leading) {
                    Text(manga.title ?? "")
                        .font(.title3)
                        .bold()
                    
                    Text(manga.titleJapanese ?? "")
                        .font(.caption)
                    Spacer()
                    HStack {
                        Text("Owned: \(mangaUser.ownedVolumes)/\(manga.volumesString)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("Reading: \(mangaUser.currentVolume)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack(alignment: .lastTextBaseline) {
                        Text("Completed: ")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Image(systemName: mangaUser.isCompleted ? "hand.thumbsup.fill" : "hand.thumbsdown.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(mangaUser.isCompleted ? .green : .gray)
                            .frame(height: 14)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
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
        } else {
            Text("Manga noy available")
                .foregroundStyle(.secondary)
                .padding()
        }
    }
}

#Preview {
    MangaUserRow(mangaUser: .mangaUser)
}
