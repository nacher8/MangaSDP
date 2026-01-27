//
//  DataContainer.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 24/1/26.
//

import SwiftUI
import SwiftData

@ModelActor
actor DataContainer {
    private let repository = Network()
    
    @AppStorage("page") private var actualPage: Int = 1
    
    func loadInitialData() async throws {
        let mangas = try await getMangas()
        try loadMangas(mangas: mangas)
    }
    
    func getMangas() async throws -> [MangaItemDTO] {
        async let getMangas = repository.getMangas(page: actualPage)
        return try await getMangas
    }
    
    func loadMangas(mangas: [MangaItemDTO]) throws {
        for manga in mangas {
            let mangaID = manga.id
            var fetchManga = FetchDescriptor<MangaItem>(predicate: #Predicate { $0.id == mangaID })
            fetchManga.fetchLimit = 1
            let queryManga = try modelContext.fetch(fetchManga)
            let mangaItem: MangaItem
            if let foundManga = queryManga.first {
                mangaItem = foundManga
                mangaItem.title = manga.title
                mangaItem.titleJapanese = manga.titleJapanese
                mangaItem.titleEnglish = manga.titleEnglish
                mangaItem.sypnosis = manga.sypnosis
                mangaItem.background = manga.background
                mangaItem.startDate = manga.startDate
                mangaItem.endDate = manga.endDate
                mangaItem.volumes = manga.volumes
                mangaItem.chapters = manga.chapters
                mangaItem.status = manga.status
                mangaItem.score = manga.score
                mangaItem.url = manga.url
                mangaItem.mainPicture = manga.mainPicture
            } else {
                mangaItem = MangaItem(id: manga.id,
                                      title: manga.title ?? "",
                                      titleJapanese: manga.titleJapanese ?? "",
                                      titleEnglish: manga.titleEnglish ?? "",
                                      sypnosis: manga.sypnosis ?? "",
                                      background: manga.background ?? "",
                                      startDate: manga.startDate ?? "",
                                      endDate: manga.endDate ?? "",
                                      volumes: manga.volumes ?? 0,
                                      chapters: manga.chapters ?? 0,
                                      status: manga.status ?? "",
                                      score: manga.score ?? 0.0,
                                      url: manga.url ?? "",
                                      mainPicture: manga.mainPicture ?? "")
                modelContext.insert(mangaItem)
            }
            
            print("📚 Cargando manga: \(manga.title ?? "Manga sin titulo")")
            print("   Genres en DTO: \(manga.genres.count)")
            print("   Authors en DTO: \(manga.authors.count)")
            print("   Themes en DTO: \(manga.themes.count)")
            print("   Demographic en DTO: \(manga.demographics.count)")
            
            mangaItem.genres = try loadGenres(manga.genres)
            mangaItem.themes = try loadThemes(manga.themes)
            mangaItem.demographics = try loadDemographics(manga.demographics)
            mangaItem.authors = try loadAuthors(manga.authors)
        }
        
        if modelContext.hasChanges {
            try modelContext.save()
        }
    }
    
    func loadAuthors(_ authorsDTO: [AuthorDTO]) throws -> [Author] {
        var authors: [Author] = []
        
        for authorDTO in authorsDTO {
            let authorID = authorDTO.id
            var fetch = FetchDescriptor<Author>(predicate: #Predicate { $0.id == authorID })
            fetch.fetchLimit = 1
            let queryAuthor = try modelContext.fetch(fetch)
            
            let author: Author
            if let existingAuthor = queryAuthor.first {
                author = existingAuthor
            } else {
                author = Author(id: authorDTO.id,
                                firstName: authorDTO.firstName,
                                lastName: authorDTO.lastName,
                                role: authorDTO.role)
                modelContext.insert(author)
            }
            authors.append(author)
        }
    
        return authors
    }
    
    func loadThemes(_ themesDTO: [ThemeDTO]) throws -> [Theme] {
        var themes: [Theme] = []
        
        for themeDTO in themesDTO {
            let themeID = themeDTO.id
            var fetch = FetchDescriptor<Theme>(predicate: #Predicate { $0.id == themeID })
            fetch.fetchLimit = 1
            let query = try modelContext.fetch(fetch)
            
            let theme: Theme
            if let existingTheme = query.first {
                theme = existingTheme
            } else {
                theme = Theme(id: themeDTO.id,
                              theme: themeDTO.theme)
                modelContext.insert(theme)
            }
            themes.append(theme)
        }

        return themes
    }
    
    func loadDemographics(_ demographicsDTO: [DemographicDTO]) throws -> [Demographic] {
        var demographics: [Demographic] = []
        
        for demographicDTO in demographicsDTO {
            let demographicID = demographicDTO.id
            var fetch = FetchDescriptor<Demographic>(predicate: #Predicate { $0.id == demographicID })
            fetch.fetchLimit = 1
            let query = try modelContext.fetch(fetch)
            
            let demographic: Demographic
            if let existingDemographic = query.first {
                demographic = existingDemographic
            } else {
                demographic = Demographic(id: demographicDTO.id,
                                          demographic: demographicDTO.demographic)
                modelContext.insert(demographic)
            }
            demographics.append(demographic)
        }

        return demographics
    }
    
    func loadGenres(_ genresDTO: [GenreDTO]) throws -> [Genre] {
        var genres: [Genre] = []
        
        for genreDTO in genresDTO {
            print("   - ID: \(genreDTO.id), Nombre: \(genreDTO.genre)")
            let genreID = genreDTO.id
            var fetch = FetchDescriptor<Genre>(predicate: #Predicate { $0.id == genreID })
            fetch.fetchLimit = 1
            let query = try modelContext.fetch(fetch)
            
            let genre: Genre
            if let existingGenre = query.first {
                genre = existingGenre
            } else {
                genre = Genre(id: genreDTO.id,
                              genre: genreDTO.genre)
                modelContext.insert(genre)
            }
            print("   ✅ Total géneros en array: \(genres.count)")
            genres.append(genre)
        }
        
        return genres
    }
    
    func loadNextPage() async throws {
        actualPage += 1
        let mangas = try await repository.getMangas(page: actualPage)
        try loadMangas(mangas: mangas)
    }
}
