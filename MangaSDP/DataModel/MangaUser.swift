//
//  MangaUser.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 2/2/26.
//

import Foundation
import SwiftData

@Model
final class MangaUser {
    @Attribute(.unique) var id: Int
    var ownedVolumes: Int
    var currentVolume: Int
    var isCompleted: Bool
    
    @Relationship(deleteRule: .nullify)
    var manga: MangaItem
    
    init(id: Int, ownedVolumes: Int = 0, currentVolume: Int = 0, isCompleted: Bool = false, manga: MangaItem) {
        self.id = id
        self.ownedVolumes = ownedVolumes
        self.currentVolume = currentVolume
        self.isCompleted = isCompleted
        self.manga = manga
    }
}
