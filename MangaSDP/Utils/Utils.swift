//
//  Utils.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 13/2/26.
//

import Foundation

final class Utils {
    static func mapDTOsToMangaItems(_ dtos: [MangaItemDTO]) -> [MangaItem] {
        dtos.map { dto in
            let mangaItem = MangaItem(id: dto.id,
                                      title: dto.title,
                                      titleJapanese: dto.titleJapanese,
                                      titleEnglish: dto.titleEnglish,
                                      sypnosis: dto.sypnosis?.removingSquareBracketContent,
                                      background: dto.background,
                                      startDate: dto.startDate,
                                      endDate: dto.endDate,
                                      volumes: dto.volumes ?? 0,
                                      chapters: dto.chapters ?? 0,
                                      status: dto.status.flatMap(MangaStatus.init(rawValue:)),
                                      score: dto.score ?? 0.0,
                                      url: dto.url.flatMap(URL.init(string:)),
                                      mainPicture: dto.mainPicture.flatMap(URL.init(string:)),
                                      isFromMainList: false)
            
            // Crear las relaciones (sin insertar en SwiftData)
            mangaItem.genres = dto.genres.map { genreDTO in
                Genre(id: genreDTO.id, genre: genreDTO.genre)
            }
            
            mangaItem.themes = dto.themes.map { themeDTO in
                Theme(id: themeDTO.id, theme: themeDTO.theme)
            }
            
            mangaItem.demographics = dto.demographics.map { demographicDTO in
                Demographic(id: demographicDTO.id, demographic: demographicDTO.demographic)
            }
            
            mangaItem.authors = dto.authors.map { authorDTO in
                Author(id: authorDTO.id,
                       firstName: authorDTO.firstName,
                       lastName: authorDTO.lastName,
                       role: authorDTO.role)
            }
            
            return mangaItem
        }
    }
    
    static func mapDTOsToAuthors(_ dtos: [AuthorDTO]) -> [Author] {
        dtos.map { dto in
            let author = Author(id: dto.id,
                                firstName: dto.firstName,
                                lastName: dto.lastName,
                                role: dto.role,
                                isFromAuthorsList: false)
            return author
        }
    }
}
