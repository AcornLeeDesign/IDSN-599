//
//  ContentView.swift
//  ClickerGame_AaronLee
//
//  Created by Aaron Lee on 9/4/25.
//

import SwiftUI

struct Eyes: View {
    let initial_size: CGFloat = 80
    
    @State private var size: CGSize = CGSize(width: 80, height: 40)
    @State var count : Int = 0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private var currentImage: Image {
        switch count {
        case 0..<20: return Image("eyePaint")
        case 20..<40: return Image("eyeClosed")
        case 40..<80: return Image("eyePaint")
        default: return Image("eyePaint")
        }
    }
    
    private var currentCaption: String {
        switch count {
        case 0..<20: return ""
        case 20..<40: return "blink"
        case 40..<60: return ""
        default: return "Intriguing"
        }
    }
    
    var body: some View {
        VStack {
            Text(currentCaption)
                .bold()
                .font(.system(size: 20))
                .foregroundColor(.black)
            
            currentImage
                .resizable()
                .scaledToFill()
                .frame(width: size.width, height: size.height)
                .onTapGesture {
                    grow()
                }
            
            Text("\(count)")
                .padding(.top, 4)
                .font(.system(size: 16))
                .foregroundColor(.black)
        }
        .onReceive(timer) { _ in
                decay()
        }
    }
    private func grow(_ rate: CGFloat = 5) {
        size = CGSize(width: size.width + rate, height: size.height + rate)
        count += 1
    }
    
    private func decay(_ rate: CGFloat = 5, _ end: Bool = false) {
        if count > 0 && count < 80 {
            size = CGSize(width: size.width - rate, height: size.height - rate)
            count -= 1
        }
        else if count > 60 {
            size = size
        }
    }
}

struct ContentView: View {
    let max_spawn = 6
    @State private var eyePositions: [CGPoint] = []
    
    var body: some View {
        ZStack {
            ForEach(0..<max_spawn, id: \.self) { i in
                Eyes()
                    .position(eyePositions.indices.contains(i) ? eyePositions[i] : CGPoint(x: 100, y: 100))
            }
        }
        .onAppear {
            eyePositions = (0..<max_spawn).map { _ in
                CGPoint(x: CGFloat.random(in: 50...300),
                        y: CGFloat.random(in: 50...600))
            }
        }
    }
    
}

#Preview {
    ContentView()
}
