import SwiftUI

struct VideoPreviewPage: View {
    let item: MediaItem
    @Binding var active: MediaItem?
    
    var body: some View {
        ZStack {
            Color.gray.edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack(spacing: 24) {
                    // Close button
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
                    
                    // Video preview
                    if let url = item.videoURL {
                        AspectVideoView(url: url, showControls: true)
                            .frame(maxWidth: .infinity)
                    } else {
                        Color.gray.opacity(0.2)
                            .frame(height: 200)
                            .cornerRadius(12)
                    }
                    
                    // Info panel
                    VStack(alignment: .leading, spacing: 16) {
                        Text(item.title)
                            .font(.title)
                        
                        Text("Story")
                            .font(.title2)
                        
                        Text(item.description ?? "No description available")
                            .font(.body)
                        
                        Text("Uploaded: \(item.uploadDate ?? "Unknown")")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 16)
                    
                    Spacer()
                }
            }
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .zIndex(1)
        }
        }
}
