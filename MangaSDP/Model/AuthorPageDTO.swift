//
//  Author.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 12/2/26.
//

import Foundation

struct AuthorPageDTO: Codable {
    let items: [AuthorDTO]
    let metadata: MetadataDTO
}
