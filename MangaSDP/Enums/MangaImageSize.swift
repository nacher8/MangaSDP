//
//  MangaImageSize.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 3/2/26.
//

import Foundation

enum MangaImageSize {
    case list, detail, user
    
    var frame: CGSize {
        switch self {
        case .list: return CGSize(width: 90, height: 150)
        case .detail: return CGSize(width: 160, height: 260)
        case .user: return CGSize(width: 70, height: 100)
        }
    }
}
