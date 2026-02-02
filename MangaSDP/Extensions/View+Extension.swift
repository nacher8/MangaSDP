//
//  View+Extension.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 31/1/26.
//

import SwiftUI

extension View {
    @ViewBuilder
    func mangaImageFrame(_ isDetail: Bool) -> some View {
        self
            .frame(width: isDetail ? 160 : 90, height: isDetail ? 260 : 150)
    }
}
