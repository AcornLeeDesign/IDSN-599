//
//  MediaRepository.swift
//  Collection Box
//
//  Created by Aaron Lee on 10/4/25.
//
import Foundation

struct MediaRepository {
    static func fetchMediaItems() async throws -> [MediaItem] {
        let items: [MediaItem] = try await SupabaseService.shared.client
            .from("media_items")
            .select()
            .order("upload_date", ascending: false)
            .execute()
            .value

        return items
    }
}
