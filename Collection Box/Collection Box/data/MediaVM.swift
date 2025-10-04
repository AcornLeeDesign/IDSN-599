// MediaVM.swift
import Foundation

@MainActor
class MediaVM: ObservableObject {
    @Published var items: [MediaItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func load() async {
        print("loading media items")
        isLoading = true
        errorMessage = nil
        do {
            let fetched = try await MediaRepository.fetchMediaItems()
            self.items = fetched
        } catch {
            self.errorMessage = error.localizedDescription
            print("MediaVM load error:", error)
        }
        isLoading = false
    }
}
