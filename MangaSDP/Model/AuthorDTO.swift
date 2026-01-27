//
//  Author.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 20/1/26.
//

import Foundation

struct AuthorDTO: Identifiable, Codable {
    let id: String
    let firstName: String
    let lastName: String
    let role: String
}
