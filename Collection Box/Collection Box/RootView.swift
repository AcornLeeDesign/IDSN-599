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
            if bob {
                TitlePage(userData: userData, bob: $bob)
                    .transition(.move(edge: .leading))
            } else {
                ContentView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: bob)
    }
}

#Preview {
    RootView()
}

