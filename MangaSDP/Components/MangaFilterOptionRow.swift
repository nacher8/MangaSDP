//
//  MangaFilterOptionRow.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 10/2/26.
//

import SwiftUI

struct MangaFilterOptionRow: View {
    let option: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(option)
                    .font(.body)
                    .foregroundStyle(isSelected ? .primary : .secondary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(.orange)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background {
                if isSelected {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.orange.opacity(0.1))
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

//#Preview {
//    MangaFilterOptionRow()
//}
