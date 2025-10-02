//
//  ContentView.swift
//  Touch and Gestures
//
//  Created by Aaron Lee on 10/2/25.
//
import SwiftUI

struct ContentView: View {
    @ObservedObject var userData: UserData

    @State private var videos: [String] = ["BloomBounce"]
    @State private var active: String? = nil
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            if let name = active {
                VideoPreviewPage(name: name, active: $active)
            } else {
                VideoListView(videos: videos, active: $active)
            }
        }
        .animation(.spring(), value: active)
    }
}

