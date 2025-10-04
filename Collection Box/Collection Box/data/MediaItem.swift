import Foundation

struct MediaItem: Codable, Identifiable, Equatable {
    let id: UUID
    let title: String
    let description: String?
    let videoPath: String?
    let musicPath: String?
    let uploadDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, description
        case videoPath = "video_path"
        case musicPath = "music_path"
        case uploadDate = "upload_date"
    }
    
    // Helper
    var videoURL: URL? {
        guard let p = videoPath else { return nil }
        if p.starts(with: "http") { return URL(string: p) }
        return SupabaseService.shared.publicURL(for: p)
    }
}
