//
//  MangaAuthorView.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 12/2/26.
//

import SwiftUI

struct MangaAuthorRow: View {
    let author: Author
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [roleGradientColors.0, roleGradientColors.1],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 140)
                
                VStack(spacing: 8) {
                    Image(author.role.roleIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundStyle(.white.opacity(0.9))
                    
                    Text(author.role.uppercased())
                        .font(.caption2)
                        .fontWeight(.bold)
                        .tracking(1)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(.white.opacity(0.2))
                                .overlay(
                                    Capsule()
                                        .stroke(.white.opacity(0.4), lineWidth: 1)
                                )
                        )
                    
                    Text(author.fullName)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .foregroundStyle(.primary)
                }
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
        }
    }
    
    private var roleGradientColors: (Color, Color) {
        switch author.role.lowercased() {
        case "story":
            return (.blue, .cyan)
        case "art":
            return (.purple, .pink)
        case "story & art":
            return (.orange, .red)
        default:
            return (.gray, .gray.opacity(0.6))
        }
    }
}

#Preview {
    HStack(spacing: 16) {
        MangaAuthorRow(author: .author)
            .frame(width: 170)
        
        MangaAuthorRow(author: .author)
            .frame(width: 170)
    }
    .padding()
}
