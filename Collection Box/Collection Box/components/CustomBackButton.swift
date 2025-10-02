//
//  BackButton.swift
//  Touch and Gestures
//
//  Created by Aaron Lee on 10/2/25.
//

import SwiftUI

struct CustomBackButton: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        Button(action: { dismiss() }) {
            Image(systemName: "chevron.left")
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
                .foregroundColor(.white)
                .offset(x: 3)
                .padding(8)
        }
        .background(Color.gray.opacity(0.5))
        .cornerRadius(12)
        .padding(.top, 4)
    }
}
