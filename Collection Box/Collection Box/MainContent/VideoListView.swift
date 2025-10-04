import SwiftUI

struct DefaultElementsView: View {
    let videos: [MediaItem]
    @Binding var active: MediaItem?

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(videos) { item in
                        Button {
                            withAnimation(.spring()) { active = item }
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
                .padding(.vertical)
            }
        }
    }
}
