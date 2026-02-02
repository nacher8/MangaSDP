//
//  MangaImageView.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 29/1/26.
//

import SwiftUI

struct MangaImageView: View {
    let mainPicture: URL?
    var isDetail: Bool = false

    var body: some View {
        VStack {
            AsyncImage(url: mainPicture) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .mangaImageFrame(isDetail)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .mangaImageFrame(isDetail)
                        .clipShape(RoundedRectangle(cornerRadius: 11))
                case .failure:
                    placeholder
                @unknown default:
                    placeholder
                }
            }
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
        .mangaImageFrame(isDetail)
    }
}

#Preview {
    MangaImageView(mainPicture: MangaItem.manga.mainPicture)
}
