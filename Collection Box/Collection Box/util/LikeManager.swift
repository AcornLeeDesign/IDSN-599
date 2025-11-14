//
//  LikeManager.swift
//  Collection Box
//
//  Created for managing liked items
//

import Foundation

/// Manages the liked state of media items
/// Currently uses UserDefaults for local persistence
/// Can be easily extended to use Supabase for cloud sync
class LikeManager: ObservableObject {
    static let shared = LikeManager()
    
    @Published private(set) var likedItemIDs: Set<UUID> = []
    
    private let userDefaultsKey = "likedMediaItems"
    
    private init() {
        loadLikes()
    }
    
    /// Check if an item is liked
    func isLiked(_ itemID: UUID) -> Bool {
        likedItemIDs.contains(itemID)
    }
    
    /// Toggle the liked state of an item
    func toggleLike(for itemID: UUID) {
        if likedItemIDs.contains(itemID) {
            likedItemIDs.remove(itemID)
        } else {
            likedItemIDs.insert(itemID)
        }
        saveLikes()
    }
    
    /// Load likes from UserDefaults
    private func loadLikes() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode([String].self, from: data) {
            likedItemIDs = Set(decoded.compactMap { UUID(uuidString: $0) })
        }
    }
    
    /// Save likes to UserDefaults
    private func saveLikes() {
        let stringArray = likedItemIDs.map { $0.uuidString }
        if let encoded = try? JSONEncoder().encode(stringArray) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
}

