//
//  Manga.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 20/1/26.
//

import Foundation

struct MangaDTO: Codable {
    let items: [MangaItemDTO]
    let metadata: MetadataDTO
}
