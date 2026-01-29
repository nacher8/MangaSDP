//
//  MangaRow.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 27/1/26.
//

import SwiftUI

struct MangaRow: View {
    let manga: MangaItem
    
    private var imageURL: URL? {
        guard let mainPicture = manga.mainPicture else { return nil }
        return URL(string: mainPicture)
    }
    
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
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 90, height: 150)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 90, height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 11))
                case .failure:
                    placeholder
                @unknown default:
                    placeholder
                }
            }
        }
        .frame(height: 150)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 35)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 35)
                        .stroke(Color.white, lineWidth: 0.5)
                        .shadow(color: .black.opacity(0.15),
                                radius: 2,
                                x: 0,
                                y: 1)
                )
        }
    }
    
    private var placeholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 11)
                .fill(Color.gray.opacity(0.2))
            
            Image(systemName: "book.closed")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
        }
        .frame(width: 90, height: 150)
    }
}

#Preview {
    MangaRow(manga: .manga)
}
