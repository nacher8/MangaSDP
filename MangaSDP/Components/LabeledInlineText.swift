//
//  LabeledInlineText.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 31/1/26.
//

import SwiftUI

struct LabeledInlineText: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.body)
                .bold()
                .underline()
            
            Text(value)
                .font(.subheadline)
                .italic()
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    LabeledInlineText(title: "Prueba", value: "valor1, valor2, valor3")
}
