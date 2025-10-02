//
//  ContentView.swift
//  OnboardingFlow_AaronLee
//
//  Created by Aaron Lee on 9/9/25.
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
                    
                    ContinueButton(label: "Continue", destination: View1(userData: userData, bob: $bob))
                }
            }
        }
    }
}

struct View1: View {
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
                    ContinueButton(label: "Continue", destination: View2(userData: userData, bob: $bob))
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


struct View2: View {
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
                    ContinueButton(label: "Continue", destination: View3(userData: userData, bob: $bob))
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

struct View3: View {
    @ObservedObject var userData: UserData
    
    @Binding var bob: Bool
    
    @State private var dataCheck = false
    @State private var showButton = false
    @State private var skipWait = false
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                Typewriter(
                    text: [
                        "{ <_ ...... _> }",
                        "{< ..glad you're here.. >}",
                        "< welcome \(userData.firstName) >",
                        "[_this is your private space_]",
                        "<= let's get started =>"
                ],
                    size: Font.title3,
                    onComplete: {
                        showButton = true
                    }
                )
            }
            
            VStack {
                Spacer()
                
                Button(action: { showButton = true }) {
                    Text("skip >")
                        .foregroundColor(.gray)
                        .padding(8)
                        .background(Color.clear)
                        .cornerRadius(99)
                        .overlay(
                            RoundedRectangle(cornerRadius: 99)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 99)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .opacity(!showButton && skipWait ? 1 : 0)
                .offset(y: !showButton && skipWait ? 10 : 20)
                .animation(.easeOut(duration: 0.5), value: showButton)
                .disabled(!skipWait)
                
                Button("Initiate") { bob = false }
                    .primaryStyle
                    .opacity(showButton ? 1 : 0)
                    .offset(y: showButton ? 0 : 20)
                    .animation(.spring(duration: 1), value: showButton)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    skipWait = true
                }
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

