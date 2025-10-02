//
//  ContinueButton.swift
//  Touch and Gestures
//
//  Created by Aaron Lee on 10/2/25.
//

import SwiftUI

struct ContinueButton<Destination: View>: View {
    var label: String
    var destination: Destination
    var isOnboarding = true
    
    @State private var navigate = false

    var body: some View {
        VStack {
            Button(action: { navigate = true }) {
                Text(label)
            }
            .primaryStyle
            .navigationDestination(isPresented: $navigate) {
                destination
            }
        }
    }
}
