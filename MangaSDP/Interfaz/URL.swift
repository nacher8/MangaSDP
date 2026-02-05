//
//  URL.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 22/1/26.
//

import Foundation

let api = URL(string: "https://mymanga-acacademy-5607149ebe3d.herokuapp.com")!

extension URL {
    static let getMangas = api.appending(path: "/list/mangas")

    static func getMangas(page: Int) -> URL {
        let url = api.appending(path: "/list/bestMangas")
        let queryItems: [URLQueryItem] = [URLQueryItem(name: "page", value: "\(page)"),
                                          URLQueryItem(name: "per", value: "10")]
        return url.appending(queryItems: queryItems)
    }

    static func findManga(search:String, page: Int) -> URL {
        let url = api.appending(path: "/search/mangasContains").appending(path: search)
        let queryItems: [URLQueryItem] = [URLQueryItem(name: "page", value: "\(page)"),
                                          URLQueryItem(name: "per", value: "10")]
        return url.appending(queryItems: queryItems)
    }
}
