//
//  MangaViewModel.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 2/2/26.
//

import Foundation
import SwiftData

@Observable @MainActor
final class MangaUserViewModel {
    private var modelContext: ModelContext?
    
    private(set) var userCollectionIDs: Set<Int> = []
    
    func setModelContext(_ context: ModelContext) {
        modelContext = context
        loadUserCollectionIDs()
    }
    
    private func loadUserCollectionIDs() {
        guard let context = modelContext else { return }
        let fetch = FetchDescriptor<MangaUser>()
        if let collections = try? context.fetch(fetch) {
            userCollectionIDs = Set(collections.map { $0.id })
        }
    }
    
    func addUserCollection(from manga: MangaItem) {
        guard let context = modelContext else { return }
        
        let mangaID = manga.id
        var fetchManga = FetchDescriptor<MangaItem>(predicate: #Predicate { $0.id == mangaID })
        fetchManga.fetchLimit = 1
        
        let persistedManga: MangaItem
        
        if let existingManga = try? context.fetch(fetchManga).first {
            persistedManga = existingManga
        } else {
            let newManga = MangaItem(
                id: manga.id,
                title: manga.title,
                titleJapanese: manga.titleJapanese,
                titleEnglish: manga.titleEnglish,
                sypnosis: manga.sypnosis,
                background: manga.background,
                startDate: manga.startDate,
                endDate: manga.endDate,
                volumes: manga.volumes,
                chapters: manga.chapters,
                status: manga.status,
                score: manga.score,
                url: manga.url,
                mainPicture: manga.mainPicture
            )
            
            context.insert(newManga)
            persistedManga = newManga
        }
        
        let newCollection = MangaUser(
            id: persistedManga.id,
            manga: persistedManga)
        
        context.insert(newCollection)
        try? context.save()
        
        userCollectionIDs.insert(mangaID)
    }
    
    func removeUserCollection(_ mangaID: Int) {
        guard let context = modelContext else { return }
        
        let fetch = FetchDescriptor<MangaUser>(predicate: #Predicate { $0.id == mangaID })
        if let collection = try? context.fetch(fetch).first {
            context.delete(collection)
            try? context.save()
            
            userCollectionIDs.remove(mangaID)
        }
    }
    
    func isUserCollection(_ mangaID: Int) -> Bool {
        return userCollectionIDs.contains(mangaID)
    }
    
    func toggleCollection(_ manga: MangaItem) {
        if isUserCollection(manga.id) {
            removeUserCollection(manga.id)
        } else {
            addUserCollection(from: manga)
        }
    }
    
    func collectionCount() -> Int {
        return userCollectionIDs.count
    }
    
    func saveUserCollection() {
        guard let context = modelContext else { return }
        try? context.save()
    }
}
