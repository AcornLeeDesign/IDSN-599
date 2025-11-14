import SwiftUI
import AVFoundation

struct VideoPreviewPage: View {
    let item: MediaItem
    @Binding var active: MediaItem?
    @Binding var elementsView: Bool
    @ObservedObject private var likeManager = LikeManager.shared
    @State private var audioPlayer: AVPlayer?

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                VStack(spacing: 24) {
                    HStack {
                        if let musicURL = item.musicURL {
                            Text(item.title)
                                .foregroundColor(.white)
                                .bold()
                                .font(.title)
                                .padding(.bottom, 8)
                                .onAppear {
                                    audioPlayer = playMusic(from: musicURL)
                                }
                                .onDisappear {
                                    audioPlayer?.pause()
                                    audioPlayer = nil
                                }
                        }
                        
                        Spacer()
                        // x
                        VStack {
                            Image(systemName: "xmark")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 12, height: 12)
                                .foregroundColor(.white)
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        audioPlayer?.pause()
                                        audioPlayer = nil
                                        active = nil
                                        elementsView = true
                                    }
                                }
                                .padding(12)
                        }
                        .background(Color.white.opacity(0.4))
                        .cornerRadius(12)
                    }

                    // Video preview
                    if let videoURL = item.videoURL {
                        AspectVideoView(url: videoURL, shouldAutoPlay: true, showControls: true)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(12)
                            .shadow(radius: 4)
                    } else {
                        Color.gray.opacity(0.2)
                            .frame(height: 200)
                            .cornerRadius(12)
                    }

                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("About")
                                .font(.title2)
                                .foregroundColor(.white)

                            Text(item.description ?? "No description available")
                                .font(.body)
                                .foregroundColor(.white)

                            Text("Uploaded: \(item.uploadDate ?? "Unknown")")
                                .font(.body)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Heart button
                        Button {
                            // Trigger haptic feedback
                            let generator = UIImpactFeedbackGenerator(style: .light)
                            generator.impactOccurred()
                            // Play a small tap sound
                            playTapSound()
                            
                            // Toggle like state
                            likeManager.toggleLike(for: item.id)
                        } label: {
                            if likeManager.isLiked(item.id) {
                                // Liked: solid white fill, no border
                                Image(systemName: "heart.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                            } else {
                                // Not liked: gray border, no fill
                                Image(systemName: "heart")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.leading, 16)
                    }

                    Spacer()
                }
                .padding(24)
                .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.9)
                .background(Color.gray.opacity(0.5))
                .cornerRadius(24, corners: [.topLeft, .topRight])
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(1)
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = 0.0
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
