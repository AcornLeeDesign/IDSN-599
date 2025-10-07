import SwiftUI

struct ContentView: View {
    @StateObject private var vm = MediaVM()
    @State private var active: MediaItem? = nil
    @State private var elementsView = true
    
    var body: some View {
        ZStack {
            // Base layer: the list of videos
            if vm.items.isEmpty {
                Color.black.edgesIgnoringSafeArea(.all)
                Text("fishing for stuff")
                    .foregroundColor(.white)
            } else {
                ElementsView(videos: vm.items, active: $active, elementsView: $elementsView)
            }
            
            // Overlay: the preview
            if let selected = active {
                VideoPreviewPage(item: selected, active: $active, elementsView: $elementsView)
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
