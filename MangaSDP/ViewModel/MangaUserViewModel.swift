//
//  MangaViewModel.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 2/2/26.
//

import Foundation
import SwiftData

@Observable
final class MangaUserViewModel {
    private var modelContext: ModelContext?
    
    func setModelContext(_ context: ModelContext) {
        modelContext = context
    }
    
    func addUserCollection(from manga: MangaItem) {
        guard let context = modelContext else { return }
        
        let newCollection = MangaUser(
            id: manga.id,
            manga: manga)
        
        context.insert(newCollection)
        try? context.save()
    }
    
    func removeUserCollection(_ mangaID: Int) {
        guard let context = modelContext else { return }
        
        let fetch = FetchDescriptor<MangaUser>(predicate: #Predicate { $0.id == mangaID })
        if let collection = try? context.fetch(fetch).first {
            context.delete(collection)
            try? context.save()
        }
    }
    
    func isUserCollection(_ mangaID: Int) -> Bool {
        guard let context = modelContext else { return false }
        
        let fetch = FetchDescriptor<MangaUser>(predicate: #Predicate { $0.id == mangaID })
        let count = (try? context.fetchCount(fetch)) ?? 0
        return count > 0
    }
    
    func toggleCollection(_ manga: MangaItem) {
        if isUserCollection(manga.id) {
            removeUserCollection(manga.id)
        } else {
            addUserCollection(from: manga)
        }
    }
    
    func collectionCount() -> Int {
        guard let context = modelContext else { return 0 }
        
        let fetch = FetchDescriptor<MangaUser>()
        return (try? context.fetchCount(fetch)) ?? 0
    }
}
