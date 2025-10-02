import SwiftUI

struct VideoPreviewPage: View {
    let name: String
    @Binding var active: String?
    
    var body: some View {
        VStack(spacing: 24) {
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
            
            AspectVideoView(name: name, showControls: true)
                .frame(maxWidth: .infinity)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Placeholding title")
                    .font(.title)
                
                Text("Story")
                    .font(.title2)
                
                Text("Lorem Ipsum")
                    .font(.body)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 8)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .ignoresSafeArea()
        .padding(.top, 16)
        .padding(.horizontal, 24)
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .zIndex(1)
    }
}
