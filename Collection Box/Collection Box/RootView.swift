//
//  ContentView.swift
//  OnboardingFlow_AaronLee
//
//  Created by Aaron Lee on 9/9/25.
//

import SwiftUI

struct RootView: View {
    @State var bob = true
    @StateObject private var userData = UserData()
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            if bob {
                TitlePage(userData: userData, bob: $bob)
                    .transition(.move(edge: .leading))
            } else {
                ContentView()
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.5), value: bob)
    }
}

#Preview {
    RootView()
}

