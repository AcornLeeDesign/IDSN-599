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
        if bob == true {
            TitlePage(userData: userData, bob: $bob)
        }
        else {
            ContentView(userData: userData)
        }
    }
}

#Preview {
    RootView()
}

