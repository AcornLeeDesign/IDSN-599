import SwiftUI
import AVFoundation

struct VideoPreviewPage: View {
    let item: MediaItem
    @Binding var active: MediaItem?
    @Binding var elementsView: Bool
    @State private var audioPlayer: AVPlayer?

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring()) {
                        audioPlayer?.pause()
                        audioPlayer = nil
                        active = nil
                        elementsView = true
                    }
                }
            VStack {
                Spacer()
                
                VStack(spacing: 24) {
                    // Close handle
                    Capsule()
                        .fill(Color.white.opacity(0.5))
                        .frame(width: 60, height: 4)
                        .padding(.top, 2)

                    // Video preview
                    if let videoURL = item.videoURL {
                        AspectVideoView(url: videoURL, showControls: true)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(12)
                            .shadow(radius: 4)
                    } else {
                        Color.gray.opacity(0.2)
                            .frame(height: 200)
                            .cornerRadius(12)
                    }

                    VStack(alignment: .leading, spacing: 16) {
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

                        Text("About")
                            .font(.title2)
                            .foregroundColor(.white)

                        Text(item.description ?? "No description available")
                            .font(.body)
                            .foregroundColor(.white)

                        Text("Uploaded: \(item.uploadDate ?? "Unknown")")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)
                .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.9)
                .background(Color.gray.opacity(0.5))
                .cornerRadius(20, corners: [.topLeft, .topRight])
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
