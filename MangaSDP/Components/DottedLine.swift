//
//  DottedLine.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 31/1/26.
//

import SwiftUI

struct DottedLine: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: .zero)
                path.addLine(to: CGPoint(x: geometry.size.width, y: 0))
            }
            .stroke(
                Color.secondary,
                style: StrokeStyle(
                    lineWidth: 1,
                    dash: [1, 5]
                )
            )
        }
        .frame(height: 1)
    }
}
