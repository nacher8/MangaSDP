//
//  CustomSearch.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 16/2/26.
//

import Foundation

struct CustomSearch: Codable {
    var searchTitle: String?
    var searchAuthorFirstName: String?
    var searchAuthorLasttName: String?
    var searchGenres: [String]?
    var searchThemes: [String]?
    var searchDemographics: [String]?
    var searchContains: Bool
}
