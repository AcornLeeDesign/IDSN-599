import SwiftUI

struct ElementsView: View {
    let videos: [MediaItem]
    @Binding var active: MediaItem?
    
    @Binding var elementsView: Bool

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack(spacing: 16) {
                    if elementsView {
                        ForEach(videos) { item in
                            Button {
                                // trigger haptic
                                let generator = UIImpactFeedbackGenerator(style: .light)
                                    generator.impactOccurred()
                                
                                withAnimation(.spring()) {
                                    active = item
                                    elementsView = false
                                }
                            } label: {
                                if let url = item.videoURL {
                                    AspectVideoView(url: url, showControls: false)
                                        .frame(height: 300)
                                        .padding(.horizontal)
                                } else {
                                    ZStack {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(height: 300)
                                            .cornerRadius(12)
                                        Text("No video")
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
        }
    }
}
