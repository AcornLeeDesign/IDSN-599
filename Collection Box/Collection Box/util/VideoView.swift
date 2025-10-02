//
//  VideoControl.swift
//  Touch and Gestures
//
//  Created by Aaron Lee on 10/2/25.
//
import SwiftUI
import AVKit

struct VideoControl: UIViewControllerRepresentable {
    let player: AVPlayer
    @Binding var showControls: Bool
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = showControls
        controller.videoGravity = .resizeAspectFill
        controller.view.clipsToBounds = true
        controller.view.layer.cornerRadius = 12
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
}

struct AspectVideoView: View {
    let name: String
    @State private var aspectRatio: CGFloat = 1.0
    @State private var player: AVPlayer? = nil
    @State var showControls: Bool
    
    var body: some View {
        Group {
            if let player = player {
                VideoControl(player: player, showControls: $showControls)
                    .aspectRatio(aspectRatio, contentMode: .fit)
                    .cornerRadius(8)
                    .onAppear {
                        player.play()
                        NotificationCenter.default.addObserver(
                            forName: .AVPlayerItemDidPlayToEndTime,
                            object: player.currentItem,
                            queue: .main
                        ) { _ in
                            player.seek(to: .zero)
                            player.play()
                        }
                    }
                    .onDisappear {
                        player.pause() // stop when leaving
                    }
            } else {
                Color.gray.opacity(0.2)
                    .aspectRatio(1, contentMode: .fit)
                    .cornerRadius(16)
            }
        }
        .task { await loadPlayer() }
    }
    
    private func loadPlayer() async {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp4") else { return }
        let asset = AVURLAsset(url: url)
        do {
            let tracks = try await asset.loadTracks(withMediaType: .video)
            if let track = tracks.first {
                let size = try await track.load(.naturalSize)
                let transform = try await track.load(.preferredTransform)
                let transformedSize = size.applying(transform)
                aspectRatio = abs(transformedSize.width / transformedSize.height)
            }
        } catch {
            print("Error loading video info: \(error)")
        }
        player = AVPlayer(url: url)
    }
}
