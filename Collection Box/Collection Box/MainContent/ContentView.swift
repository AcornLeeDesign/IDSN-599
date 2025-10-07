import SwiftUI

struct ContentView: View {
    @StateObject private var vm = MediaVM()
    @State private var active: MediaItem? = nil
    @State private var elementsView = true
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            if vm.items.isEmpty {
                Text("fishing for stuff")
                    .foregroundColor(.white)
            } else if elementsView {
                ElementsView(videos: vm.items, active: $active, elementsView: $elementsView)
                    .transition(.scale(scale: 0.95).combined(with: .opacity))
            }
            
            // preview
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
