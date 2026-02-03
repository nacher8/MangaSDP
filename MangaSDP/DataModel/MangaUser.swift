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
    
    @Relationship(deleteRule: .nullify)
    var manga: MangaItem
    
    init(id: Int, ownedVolumes: Int = 0, currentVolume: Int = 0, manga: MangaItem) {
        self.id = id
        self.ownedVolumes = ownedVolumes
        self.currentVolume = currentVolume
        self.manga = manga
    }
}

extension MangaUser {
    var isCompleted: Bool {
        guard let volumes = manga.volumes else { return false }
        return ownedVolumes >= volumes
    }

    @MainActor
    static let mangaUser = MangaUser(id: 1,
                                     ownedVolumes: 5,
                                     currentVolume: 2,
                                     manga: .manga)
}
