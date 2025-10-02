//
//  TitlePage.swift
//  Touch and Gestures
//
//  Created by Aaron Lee on 10/2/25.
//

import SwiftUI

struct TitlePage: View {
    @ObservedObject var userData: UserData

    @Binding var bob: Bool
    
    @State private var c1: Color = .black
    @State private var c2: Color = .white
    @State private var c_size: CGFloat = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                RadialGradient(
                    gradient: Gradient(stops: [
                        .init(color: c1, location: 0.0),
                        .init(color: c2, location: 1.0)
                    ]),
                    center: .center,
                    startRadius: 0,
                    endRadius: c_size
                )
                .onAppear {
                    withAnimation(.easeIn(duration: 1.5)) {
                        c_size += 2000
                        c2 = .black
                    }
                }
                .ignoresSafeArea()
                
                VStack {
                    Typewriter(text: [
                        "Oh hi!",
                        "A curious soul",
                        "I've been waiting",
                        "Let's bring out \n imagination",
                    ])
                }
                .offset(y: -40)
                
                VStack {
                    Spacer()
                    
                    ContinueButton(label: "Continue", destination: NameEmail(userData: userData, bob: $bob))
                }
            }
        }
    }
}
