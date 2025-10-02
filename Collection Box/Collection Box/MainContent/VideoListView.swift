//
//  VideoListView.swift
//  Touch and Gestures
//
//  Created by Aaron Lee on 10/2/25.
//
import SwiftUI

struct VideoListView: View {
    let videos: [String]
    @Binding var active: String?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(videos, id: \.self) { name in
                    Button(action: {
                        withAnimation(.spring()) {
                            active = name
                        }
                    }) {
                        AspectVideoView(name: name, showControls: false)
                            .frame(height: 300)
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
    }
}
