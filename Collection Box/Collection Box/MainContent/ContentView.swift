import SwiftUI

struct ContentView: View {
    @StateObject private var vm = MediaVM()
    @State private var active: MediaItem? = nil
    
    var body: some View {
        ZStack {
            // Base layer: the list of videos
            if vm.items.isEmpty {
                Text("No data yet")
                    .foregroundColor(.gray)
            } else {
                VideoListView(videos: vm.items, active: $active)
            }
            
            // Overlay: the preview
            if let selected = active {
                VideoPreviewPage(item: selected, active: $active)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(1)
            }
        }
        .animation(.spring(), value: active)
        .task {
            await vm.load()
        }
    }
}

#Preview {
    ContentView()
}
