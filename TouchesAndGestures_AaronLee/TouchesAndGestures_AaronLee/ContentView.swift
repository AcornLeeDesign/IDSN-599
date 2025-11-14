import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var images: [DraggableImage] = []
    @State private var showingPicker = false
    
    @State private var selectedItems: [PhotosPickerItem] = []
    
    // Tracks highest z-index assigned so far
    @State private var currentTopZ: Double = 0

    var body: some View {
        VStack {
            
            // Instructions
            if !images.isEmpty {
                VStack(spacing: 4) {
                    Text("Hold and drag to move an image")
                    Text("Pinch to resize")
                }
                .padding(.top, 16)
                .zIndex(10)
            } else {
                VStack() {
                    Text("This is your whiteboard")
                }
                .padding(.top, 40)
            }
            
            // Canvas
            GeometryReader { geo in
                ZStack {
                    ForEach($images) { $img in
                        DraggableImageView(
                            image: $img,
                            bringToFront: {
                                bringImageToFront(img.id)
                            }
                        )
                        .zIndex(img.zIndex)
                    }
                }
            }

            // Upload Button
            Button(action: { showingPicker = true }) {
                Text("Upload Images")
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray, lineWidth: 2)
                    )
                    .font(.title3)
                    .foregroundColor(.black)
                    .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 4)
            }
            .padding(.bottom, 20)
            .photosPicker(
                isPresented: $showingPicker,
                selection: $selectedItems,
                maxSelectionCount: 20,
                matching: .images
            )
            .onChange(of: selectedItems) { _ in loadImages() }
        }
    }
    
    // Users can add multiple images
    private func loadImages() {
        Task {
            for item in selectedItems {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    images.append(DraggableImage(uiImage: uiImage))
                }
            }
            selectedItems.removeAll()
        }
    }
    
    // Moves selected image to the top of the stack
    private func bringImageToFront(_ id: UUID) {
        currentTopZ += 1
        if let index = images.firstIndex(where: { $0.id == id }) {
            images[index].zIndex = currentTopZ
        }
    }
}


// Draggable Element Structure
struct DraggableImage: Identifiable {
    let id = UUID()
    var uiImage: UIImage
    
    var scale: CGFloat = 1
    var lastScale: CGFloat = 1
    
    var offset: CGSize = .zero
    var lastOffset: CGSize = .zero
    
    var isDragging = false
    
    var zIndex: Double = 0
}

struct DraggableImageView: View {
    // Create each element with same styling
    @Binding var image: DraggableImage
    let bringToFront: () -> Void

    var body: some View {
        Image(uiImage: image.uiImage)
            .resizable()
            .scaledToFit()
            .scaleEffect(image.isDragging ? image.scale * 0.95 : image.scale)
            .opacity(image.isDragging ? 0.7 : 1.0)
            .offset(image.offset)
            .gesture(gestureCombined)
            .animation(.easeInOut(duration: 0.15), value: image.isDragging)
    }
    
    // Gestures
    private var gestureCombined: some Gesture {

        let pinch = MagnificationGesture()
            .onChanged { value in
                image.scale = image.lastScale * value
            }
            .onEnded { _ in
                image.lastScale = image.scale
            }

        let drag = LongPressGesture(minimumDuration: 0.3)
            .onEnded { _ in
                bringToFront()
            }
            .sequenced(before: DragGesture()
                .onChanged { value in
                    image.isDragging = true
                    
                    image.offset = CGSize(
                        width: image.lastOffset.width + value.translation.width,
                        height: image.lastOffset.height + value.translation.height
                    )
                }
                .onEnded { _ in
                    image.lastOffset = image.offset
                    image.isDragging = false
                }
            )

        return pinch.simultaneously(with: drag)
    }
}

#Preview {
    ContentView()
}
