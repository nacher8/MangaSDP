//
//  MangaFilterType.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 10/2/26.
//

import Foundation

enum MangaFilterType: String, CaseIterable, Identifiable {
    case genre = "Genre"
    case demographic = "Demographic"
    case theme = "Theme"
    
    var id: String { self.rawValue }
}
