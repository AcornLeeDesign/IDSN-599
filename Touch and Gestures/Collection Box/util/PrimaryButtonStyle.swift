//
//  ButtonStyle.swift
//  Touch and Gestures
//
//  Created by Aaron Lee on 10/2/25.
//
import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    var backgroundColor: Color = .white
    var pressedColor: Color = Color.gray.opacity(0.65)
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? .gray : .black)
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(configuration.isPressed ? pressedColor : backgroundColor)
            .cornerRadius(99)
            .overlay(
                RoundedRectangle(cornerRadius: 99)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
    }
}

extension Button {
    var primaryStyle: some View {
        self.buttonStyle(PrimaryButtonStyle())
    }
}
