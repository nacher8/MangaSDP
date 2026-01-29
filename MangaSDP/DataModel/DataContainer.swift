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
    @AppStorage("totalMangas") private var totalMangas: Int = 0
    
    func loadInitialData() async throws {
        let mangas = try await getMangas()
        updatePagination(from: mangas.metadata)
        try loadMangas(mangas: mangas.items)
    }
    
    func getMangas() async throws -> Manga {
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
                mangaItem.status = manga.status.flatMap(MangaStatus.init(rawValue:))
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
                                      status: manga.status.flatMap(MangaStatus.init(rawValue:)),
                                      score: manga.score ?? 0.0,
                                      url: manga.url ?? "",
                                      mainPicture: manga.mainPicture ?? "")
                modelContext.insert(mangaItem)
            }

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
            genres.append(genre)
        }
        
        return genres
    }
    
    func loadNextPage() async throws {
        actualPage += 1
        let mangas = try await repository.getMangas(page: actualPage)
        updatePagination(from: mangas.metadata)
        try loadMangas(mangas: mangas.items)
    }
    
    func refreshAll() async throws {
        actualPage = 1
        
        let fetch = FetchDescriptor<MangaItem>()
        let allMangas = try modelContext.fetch(fetch)
        
        for manga in allMangas {
            modelContext.delete(manga)
        }
        
        try modelContext.save()
        
        try await loadInitialData()
    }
    
    private func updatePagination(from metadata: MetadataDTO) {
        totalMangas = metadata.total
    }
}
