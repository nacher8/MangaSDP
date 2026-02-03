//
//  View+Extension.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 31/1/26.
//

import SwiftUI

extension View {
    @ViewBuilder
    func mangaImageFrame(_ size: MangaImageSize) -> some View {
        frame(width: size.frame.width, height: size.frame.height)
    }
}
