//
//  Email.swift
//  Touch and Gestures
//
//  Created by Aaron Lee on 10/2/25.
//

import SwiftUI

struct Email: View {
    @ObservedObject var userData: UserData
    
    @Binding var bob: Bool
    
    @State private var showButton = false
    
    func checkFields() {
        if !userData.email.isEmpty {
            withAnimation {
                showButton = true
            }
        } else {
            withAnimation {
                showButton = false
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            ZStack {
                Typewriter(text: [
                    "What a pleasant surprise, \(userData.firstName)",
                    "How might I reach you?"
                ])
                .offset(y: -60)
            }
            
            VStack {
                TextField(
                    "",
                    text: $userData.email,
                    prompt: Text("Email")
                        .foregroundColor(.white.opacity(0.6))
                )
                .accentColor(.white)
                .padding(16)
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .background(Color.gray.opacity(0.5))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray, lineWidth: 1.5)
                )
                .padding(.horizontal, 24)
            }
            
            VStack {
                Spacer()
                
                if !userData.email.isEmpty {
                    ContinueButton(label: "Continue", destination: End(userData: userData, bob: $bob))
                        .opacity(showButton ? 1 : 0)
                        .offset(y: showButton ? 0 : 20)
                        .animation(.spring(duration: 1), value: showButton)
                }
                
            }
            .onChange(of: userData.email) {
                checkFields()
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                CustomBackButton()
            }
        }
    }
}

