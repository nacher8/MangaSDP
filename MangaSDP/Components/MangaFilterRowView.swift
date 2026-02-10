//
//  MangaFilterRowView.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 10/2/26.
//

import SwiftUI

struct MangaFilterTypeRowView: View {
    let filterType: FilterType
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                // Icono según el tipo
                Image(systemName: iconForFilterType(filterType))
                    .font(.title3)
                    .foregroundStyle(isSelected ? .green : .secondary)
                    .frame(width: 30)
                
                // Nombre del filtro
                Text(filterType.rawValue)
                    .font(.body)
                    .foregroundStyle(isSelected ? .primary : .secondary)
                
                Spacer()
                
                // Check verde cuando está seleccionado
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(.green)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
    
    // Helper para asignar iconos según el tipo de filtro
    private func iconForFilterType(_ type: FilterType) -> String {
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

//#Preview {
//    MangaFilterRowView()
//}
