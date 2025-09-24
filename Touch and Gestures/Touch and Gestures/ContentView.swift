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

// MARK: - Looping video wrapper
struct VideoLoop: View {
    var video: String
    private let player: AVPlayer
    
    init(video: String) {
        self.video = video
        if let url = Bundle.main.url(forResource: video, withExtension: "mp4") {
            player = AVPlayer(url: url)
        } else {
            player = AVPlayer()
        }
    }
    
    var body: some View {
        BareVideoView(player: player)
            .padding(4)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
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
    }
}

// MARK: - Model
struct VideoItem: Identifiable {
    let id = UUID()
    let name: String
}

// MARK: - Thumbnail
struct VideoThumbnail: View {
    let video: VideoItem
    @Binding var thumbnailFrame: CGRect
    @Binding var active: VideoItem?
    @GestureState private var isPressing = false
    
    var body: some View {
        GeometryReader { geo in
            VideoLoop(video: video.name)
                .scaleEffect(isPressing ? 1.05 : 1.0)
                .opacity(active?.id == video.id ? 0 : 1)
                .animation(.easeInOut(duration: 0.2), value: isPressing)
                .animation(.easeInOut(duration: 0.8), value: active?.id)
                .gesture(
                    LongPressGesture(minimumDuration: 1.0)
                        .updating($isPressing) { value, state, _ in
                            state = value
                        }
                        .onEnded { _ in
                            active = video
                        }
                )
        }
        .frame(height: 200)
    }
}

// MARK: - Main view
struct ContentView: View {
    @State private var videos: [VideoItem] = [
        VideoItem(name: "BloomBounce"),
        VideoItem(name: "card"),
        VideoItem(name: "Hot type"),
        VideoItem(name: "Lines morphing")
    ]
    @State private var active: VideoItem? = nil
    @State private var thumbnailFrame: CGRect = .zero
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(videos) { video in
                        VideoThumbnail(
                            video: video,
                            thumbnailFrame: $thumbnailFrame,
                            active: $active
                        )
                    }
                }
                .padding(16)
            }
            .blur(radius: active != nil ? 20 : 0)
            .animation(.spring(duration: 0.5), value: active != nil)
            
            if let video = active {
                ZStack {
                    // Background overlay for tap-to-dismiss
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.spring()) {
                                active = nil
                            }
                        }
                    
                    // Enlarged video + button
                    VStack {
                        Spacer()
                        
                        HStack(spacing: 20) {
                            VideoLoop(video: video.name)
                                .frame(width: 350, height: 350)
                                .cornerRadius(20)
                                .shadow(radius: 10)
                                .transition(.scale.combined(with: .opacity))
                        }
                        
                        Spacer()
                    }
                }
                .transition(.opacity)
                .zIndex(1)
            }
        }
    }
}

#Preview {
    ContentView()
}
