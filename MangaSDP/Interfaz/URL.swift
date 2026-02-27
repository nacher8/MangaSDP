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

    static func findManga(search: String, page: Int) -> URL {
        let url = api.appending(path: "/search/mangasContains").appending(path: search)
        let queryItems: [URLQueryItem] = [URLQueryItem(name: "page", value: "\(page)"),
                                          URLQueryItem(name: "per", value: "10")]
        return url.appending(queryItems: queryItems)
    }
    
    static func getGenres() -> URL {
        api.appending(path: "/list/genres")
    }
    
    static func getDemographics() -> URL {
        api.appending(path: "/list/demographics")
    }
    
    static func getThemes() -> URL {
        api.appending(path: "/list/themes")
    }
    
    static func getMangaByGenre(genre: String, page: Int) -> URL {
        let url = api.appending(path: "/list/mangaByGenre").appending(path: genre)
        let queryItems: [URLQueryItem] = [URLQueryItem(name: "page", value: "\(page)"),
                                          URLQueryItem(name: "per", value: "10")]
        return url.appending(queryItems: queryItems)
    }
    
    static func getMangaByDemographic(demographic: String, page: Int) -> URL {
        let url = api.appending(path: "/list/mangaByDemographic").appending(path: demographic)
        let queryItems: [URLQueryItem] = [URLQueryItem(name: "page", value: "\(page)"),
                                          URLQueryItem(name: "per", value: "10")]
        return url.appending(queryItems: queryItems)
    }
    
    static func getMangaByTheme(theme: String, page: Int) -> URL {
        let url = api.appending(path: "/list/mangaByTheme").appending(path: theme)
        let queryItems: [URLQueryItem] = [URLQueryItem(name: "page", value: "\(page)"),
                                          URLQueryItem(name: "per", value: "10")]
        return url.appending(queryItems: queryItems)
    }
    
    static func getAuthors(page: Int) -> URL {
        let url = api.appending(path: "/list/authorsPaged")
        let queryItems: [URLQueryItem] = [URLQueryItem(name: "page", value: "\(page)"),
                                          URLQueryItem(name: "per", value: "10")]
        return url.appending(queryItems: queryItems)
    }
    
    static func getMangasAuthor(id: String, page: Int) -> URL {
        let url = api.appending(path: "/list/mangaByAuthor").appending(path: id)
        let queryItems: [URLQueryItem] = [URLQueryItem(name: "page", value: "\(page)"),
                                          URLQueryItem(name: "per", value: "10")]
        return url.appending(queryItems: queryItems)
    }
    
    static func getMangasAdvanceSearch(page: Int) -> URL {
        let url = api.appending(path: "/search/manga")
        let queryItems: [URLQueryItem] = [URLQueryItem(name: "page", value: "\(page)"),
                                          URLQueryItem(name: "per", value: "10")]
        return url.appending(queryItems: queryItems)
    }
    
    static func findAuthor(search: String) async throws(NetworkError) -> URL {
        api.appending(path: "/search/author").appending(path: search)
    }
}
