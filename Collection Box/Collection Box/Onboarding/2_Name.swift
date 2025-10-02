//
//  NameEmail.swift
//  Touch and Gestures
//
//  Created by Aaron Lee on 10/2/25.
//

import SwiftUI

struct NameEmail: View {
    @ObservedObject var userData: UserData

    
    @Binding var bob: Bool
    
    @State private var showField = false
    @State private var showButton = false
    @State private var navigate = false
    
    func checkFields() {
        if !userData.firstName.isEmpty && !userData.lastName.isEmpty {
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
            Typewriter(text: [
                "who are you?",
                "to yourself?",
                "to those around you?",
                "It's nice to meet you"
            ])
            .offset(y: -100)
            
            VStack {
                Spacer()
                
                VStack(spacing: 16) {
                    if showField {
                        TextField(
                            "",
                            text: $userData.firstName,
                            prompt: Text("First Name")
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
                        
                        TextField(
                            "",
                            text: $userData.lastName,
                            prompt: Text("Last Name")
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
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation(.easeInOut(duration: 1)) {
                            showField = true
                        }
                    }
                }
                Spacer()
            }
            
            VStack {
                Spacer()
                if !userData.firstName.isEmpty && !userData.lastName.isEmpty {
                    ContinueButton(label: "Continue", destination: Email(userData: userData, bob: $bob))
                        .opacity(showButton ? 1 : 0)
                        .offset(y: showButton ? 0 : 20)
                        .animation(.spring(duration: 1), value: showButton)
                }
            }
            .onChange(of: userData.firstName) {
                checkFields()
            }
            .onChange(of: userData.lastName) {
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
