import SwiftUI
import AVKit

// MARK: - Bare video player (no controls)
struct BareVideoView: UIViewControllerRepresentable {
    let player: AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        controller.videoGravity = .resizeAspectFill
        controller.view.clipsToBounds = true
        controller.view.layer.cornerRadius = 12
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
}

// MARK: - Video Player with natural aspect ratio
struct AspectVideoView: View {
    let name: String
    @State private var aspectRatio: CGFloat = 1.0
    @State private var player: AVPlayer? = nil
    
    var body: some View {
        Group {
            if let player = player {
                BareVideoView(player: player)
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

// MARK: - Video List (before tapping)
struct VideoListView: View {
    let videos: [String]
    @Binding var active: String?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(videos, id: \.self) { name in
                    Button(action: {
                        withAnimation(.spring()) {
                            active = name
                        }
                    }) {
                        AspectVideoView(name: name)
                            .frame(height: 300)
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
    }
}

// MARK: - Video Preview Page (after tapping)
struct VideoPreviewPage: View {
    let name: String
    @Binding var active: String?
    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Spacer()
                
                Button(action: {
                    withAnimation(.spring()) {
                        active = nil
                    }
                }) {
                    Image(systemName: "xmark")
                        .font(.title)
                        .foregroundColor(.gray)
                }
            }
            
            AspectVideoView(name: name)
                .frame(maxWidth: .infinity)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Placeholding title")
                    .font(.title)
                
                Text("Story")
                    .font(.title2)
                
                Text("Lorem Ipsum")
                    .font(.body)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 8)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .ignoresSafeArea()
        .padding(.top, 16)
        .padding(.horizontal, 24)
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .zIndex(1)
    }
}

//// MARK: - Main ContentView
//struct ContentListView: View {
//    let videos: [String] = []
//    let images: [String] = []
//    
//    var videoCount: Int { videos.count }
//    var imageCount: Int { images.count }
//    
//    var contentList: [String] {
//        var result: [String] = []
//        var isVideo = false
//        
//        // starting point
//        if (videoCount < imageCount) {
//            var video
//        }
//        
//        for i in 0..<(videos.count + images.count) {
//            if (isVideo) {
//                
//            }
//        }
//        return result
//    }
//    
//    var body: some View {
//        VStack {
//            
//        }
//    }
//}

// MARK: - Main ContentView
struct ContentView: View {
    @ObservedObject var userData: UserData

    @State private var videos: [String] = ["BloomBounce"]
    @State private var active: String? = nil
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            if let name = active {
                VideoPreviewPage(name: name, active: $active)
            } else {
                VideoListView(videos: videos, active: $active)
            }
        }
        .animation(.spring(), value: active)
    }
}

