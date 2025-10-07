//
//  TypewriterFX.swift
//  Touch and Gestures
//
//  Created by Aaron Lee on 10/2/25.
//

import SwiftUI

struct Typewriter: View {
    var text: [String]
    var color: Color = .white
    var size: Font = .title2
    var onComplete: (() -> Void)? = nil
    
    @State private var displayedText = ""
    @State private var currentIndex = 0
    @State private var typewriterTask: Task<Void, Never>? = nil
    
    var body: some View {
        Text(displayedText)
            .font(size)
            .foregroundColor(color)
            .onAppear {
                displayedText = ""
                currentIndex = 0
                typewriterTask?.cancel()
                typewriterTask = Task {
                    await runTypewriter()
                }
            }
            .onDisappear {
                typewriterTask?.cancel()
            }
    }
    
    private func runTypewriter() async {
        guard !text.isEmpty else { return }
        
        while currentIndex < text.count {
            let currentString = text[currentIndex]
            
            for char in currentString {
                guard !Task.isCancelled else { return }
                await MainActor.run {
                    displayedText.append(char)
                }
                try? await Task.sleep(nanoseconds: 80_000_000)
            }
            
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            
            if currentIndex < text.count - 1 {
                while !displayedText.isEmpty {
                    guard !Task.isCancelled else { return }
                    await MainActor.run {
                        displayedText.removeLast()
                    }
                    try? await Task.sleep(nanoseconds: 50_000_000)
                }
            }
            
            currentIndex += 1
        }
        
        await MainActor.run {
            onComplete?()
        }
    }
}
