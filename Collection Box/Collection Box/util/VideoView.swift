import SwiftUI
import AVKit

struct VideoPlayerController: UIViewControllerRepresentable {
    let player: AVPlayer
    @Binding var showsControls: Bool

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let vc = AVPlayerViewController()
        vc.player = player
        vc.showsPlaybackControls = showsControls
        vc.videoGravity = .resizeAspect
        vc.view.clipsToBounds = true
        vc.view.layer.cornerRadius = 12
        return vc
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        uiViewController.showsPlaybackControls = showsControls
        if uiViewController.player !== player {
            uiViewController.player = player
        }
    }
}

struct AspectVideoView: View {
    let url: URL?
    @State private var aspectRatio: CGFloat = 16.0 / 9.0
    @State private var player: AVPlayer? = nil
    @State private var playbackObserver: Any?
    @State var showControls: Bool = false
    
    var body: some View {
        Group {
            if let player = player {
                VideoPlayerController(player: player, showsControls: $showControls)
                    .aspectRatio(aspectRatio, contentMode: .fit)
                    .cornerRadius(8)
                    .onAppear {
                        player.play()
                        // add observer once, to loop the item
                        if playbackObserver == nil {
                            playbackObserver = NotificationCenter.default.addObserver(
                                forName: .AVPlayerItemDidPlayToEndTime,
                                object: player.currentItem,
                                queue: .main
                            ) { _ in
                                player.seek(to: .zero)
                                player.play()
                            }
                        }
                    }
                    .onDisappear {
                        player.pause()
                        if let obs = playbackObserver {
                            NotificationCenter.default.removeObserver(obs)
                            playbackObserver = nil
                        }
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
        guard let url = url else { return }
        let asset = AVURLAsset(url: url)
        
        do {
            // Load video tracks asynchronously
            let tracks = try await asset.loadTracks(withMediaType: .video)
            if let track = tracks.first {
                // Load properties asynchronously
                let size = try await track.load(.naturalSize)
                let transform = try await track.load(.preferredTransform)
                let transformedSize = size.applying(transform)
                
                if transformedSize.height != 0 {
                    aspectRatio = abs(transformedSize.width / transformedSize.height)
                }
            }
            
            let item = AVPlayerItem(asset: asset)
            await MainActor.run {
                player = AVPlayer(playerItem: item)
                player?.actionAtItemEnd = .none
            }
        } catch {
            print("Error loading video info: \(error)")
        }
    }
}
