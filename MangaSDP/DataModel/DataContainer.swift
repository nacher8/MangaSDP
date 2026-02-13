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
    
    @AppStorage("pageAuthors") private var actualPageAuthors: Int = 1
    @AppStorage("totalAuthors") private var totalAuthors: Int = 0
    
    // MARK: - Mangas
    func loadInitialData() async throws {
        let mangas = try await getMangas()
        updatePagination(from: mangas.metadata)
        try loadMangas(mangas: mangas.items)
        try await loadCategories()
    }
    
    func hasExistingData() throws -> Bool {
        let mangaFetch = FetchDescriptor<MangaItem>()
        let mangaCount = try modelContext.fetchCount(mangaFetch)
        
        let categoriesFetch = FetchDescriptor<MangaCategories>()
        let categoriesCount = try modelContext.fetchCount(categoriesFetch)
        
        return mangaCount > 0 && categoriesCount > 0
    }
    
    func getMangas() async throws -> MangaDTO {
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
                mangaItem.sypnosis = manga.sypnosis?.removingSquareBracketContent
                mangaItem.background = manga.background
                mangaItem.startDate = manga.startDate
                mangaItem.endDate = manga.endDate
                mangaItem.volumes = manga.volumes
                mangaItem.chapters = manga.chapters
                mangaItem.status = manga.status.flatMap(MangaStatus.init(rawValue:))
                mangaItem.score = manga.score
                mangaItem.url = manga.url.flatMap(URL.init(string:))
                mangaItem.mainPicture = manga.mainPicture.flatMap(URL.init(string:))
                mangaItem.isFromMainList = true
            } else {
                mangaItem = MangaItem(id: manga.id,
                                      title: manga.title ?? "",
                                      titleJapanese: manga.titleJapanese ?? "",
                                      titleEnglish: manga.titleEnglish ?? "",
                                      sypnosis: manga.sypnosis?.removingSquareBracketContent ?? "",
                                      background: manga.background ?? "",
                                      startDate: manga.startDate ?? "",
                                      endDate: manga.endDate ?? "",
                                      volumes: manga.volumes ?? 0,
                                      chapters: manga.chapters ?? 0,
                                      status: manga.status.flatMap(MangaStatus.init(rawValue:)),
                                      score: manga.score ?? 0.0,
                                      url: manga.url.flatMap(URL.init(string:)),
                                      mainPicture: manga.mainPicture.flatMap(URL.init(string:)),
                                      isFromMainList: true)
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
    
    // Carga autores asociados a mangas (no marca isFromAuthorsList)
    func loadAuthors(_ authorsDTO: [AuthorDTO]) throws -> [Author] {
        return try loadAuthorsInternal(authorsDTO, isFromAuthorsList: false)
    }
    
    // Carga autores desde la lista completa de autores (marca isFromAuthorsList)
    private func loadAuthorsForList(_ authorsDTO: [AuthorDTO]) throws -> [Author] {
        return try loadAuthorsInternal(authorsDTO, isFromAuthorsList: true)
    }
    
    // Función interna que carga autores con el flag apropiado
    private func loadAuthorsInternal(_ authorsDTO: [AuthorDTO], isFromAuthorsList: Bool) throws -> [Author] {
        var authors: [Author] = []
        
        for authorDTO in authorsDTO {
            let authorID = authorDTO.id
            var fetch = FetchDescriptor<Author>(predicate: #Predicate { $0.id == authorID })
            fetch.fetchLimit = 1
            let queryAuthor = try modelContext.fetch(fetch)
            
            let author: Author
            if let existingAuthor = queryAuthor.first {
                // Actualizar datos del autor existente
                existingAuthor.firstName = authorDTO.firstName
                existingAuthor.lastName = authorDTO.lastName
                existingAuthor.role = authorDTO.role
                // Si se carga desde la lista, marcar el flag (pero no quitarlo si ya lo tiene)
                if isFromAuthorsList {
                    existingAuthor.isFromAuthorsList = true
                }
                author = existingAuthor
            } else {
                // Crear nuevo autor
                author = Author(id: authorDTO.id,
                                firstName: authorDTO.firstName,
                                lastName: authorDTO.lastName,
                                role: authorDTO.role,
                                isFromAuthorsList: isFromAuthorsList)
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
        
        let userMangasFetch = FetchDescriptor<MangaUser>()
        let userMangas = try modelContext.fetch(userMangasFetch)
        let userMangaIDs = Set(userMangas.map { $0.manga.id })
        
        let fetch = FetchDescriptor<MangaItem>(
            predicate: #Predicate<MangaItem> { 
                $0.isFromMainList == true 
            }
        )
        let allMangas = try modelContext.fetch(fetch)
        
        var deletedCount = 0
        for manga in allMangas {
            if !userMangaIDs.contains(manga.id) {
                modelContext.delete(manga)
                deletedCount += 1
            } else {
                manga.isFromMainList = false
            }
        }
        
        try modelContext.save()
        
        try await loadInitialData()
        try await loadCategories()
        
        for mangaID in userMangaIDs {
            var fetchManga = FetchDescriptor<MangaItem>(
                predicate: #Predicate { $0.id == mangaID }
            )
            fetchManga.fetchLimit = 1
            if let manga = try modelContext.fetch(fetchManga).first {
                manga.isFromMainList = true
            }
        }
        
        if modelContext.hasChanges {
            try modelContext.save()
        }
    }
    
    private func updatePagination(from metadata: MetadataDTO) {
        totalMangas = metadata.total
    }
    
    // MARK: - Categories
    func loadCategories(_ refresh: Bool = false) async throws {
        async let genres: [String] = repository.getGenres()
        async let demographics: [String] = repository.getDemographics()
        async let themes: [String] = repository.getThemes()
        
        do {
            let (genres, demographics, themes) = try await (genres, demographics, themes)
            
            let fetch = FetchDescriptor<MangaCategories>()
            if let oldCategories = try modelContext.fetch(fetch).first {
                modelContext.delete(oldCategories)
            }
            
            let newCategories = MangaCategories(
                id: UUID().uuidString,
                genres: genres,
                demographics: demographics,
                themes: themes
            )
            
            modelContext.insert(newCategories)
            
            try modelContext.save()
        } catch {
            print(error)
        }
    }
    
    func getCategories() throws -> (genres: [String], demographics: [String], themes: [String])? {
        let fetch = FetchDescriptor<MangaCategories>()
        guard let categories = try modelContext.fetch(fetch).first else {
            return nil
        }
        return (categories.genres, categories.demographics, categories.themes)
    }
    
    // MARK: - Authors
    func hasExistingAuthorsData() throws -> Bool {
        let authorFetch = FetchDescriptor<Author>(
            predicate: #Predicate<Author> { $0.isFromAuthorsList == true }
        )
        let authorCount = try modelContext.fetchCount(authorFetch)
        return authorCount > 0
    }
    
    func loadInitialDataAuthors() async throws {
        let authors = try await getAuthors()
        updatePaginationAuthors(from: authors.metadata)
        _ = try loadAuthorsForList(authors.items)
        
        if modelContext.hasChanges {
            try modelContext.save()
        }
    }
    
    func getAuthors() async throws -> AuthorPageDTO {
        async let getAuthors = repository.getAuthors(page: actualPageAuthors)
        return try await getAuthors
    }
    
    func loadNextPageAuthors() async throws {
        actualPageAuthors += 1
        let authors = try await repository.getAuthors(page: actualPageAuthors)
        updatePaginationAuthors(from: authors.metadata)
        _ = try loadAuthorsForList(authors.items)
        
        if modelContext.hasChanges {
            try modelContext.save()
        }
    }
    
    func refreshAllAuthors() async throws {
            actualPageAuthors = 1
            
            let fetch = FetchDescriptor<Author>()
            let allAuthors = try modelContext.fetch(fetch)
            
            for author in allAuthors {
                author.isFromAuthorsList = false
            }
            
            if modelContext.hasChanges {
                try modelContext.save()
            }
            
            do {
                let authors = try await getAuthors()
                updatePaginationAuthors(from: authors.metadata)
                _ = try loadAuthorsForList(authors.items)
                
                if modelContext.hasChanges {
                    try modelContext.save()
                }
            } catch {
                print("Error recargando autores: \(error)")
                throw error
            }

            let fetchAfter = FetchDescriptor<Author>(predicate: #Predicate<Author> {
                $0.isFromAuthorsList == false && $0.mangas.isEmpty
            })
            let authorsToDelete = try modelContext.fetch(fetchAfter)
            
            for author in authorsToDelete {
                modelContext.delete(author)
            }
            
            if modelContext.hasChanges {
                try modelContext.save()
            }
        }
    
    private func updatePaginationAuthors(from metadata: MetadataDTO) {
        totalAuthors = metadata.total
    }
}
