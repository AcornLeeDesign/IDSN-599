//
//  End.swift
//  Touch and Gestures
//
//  Created by Aaron Lee on 10/2/25.
//
import SwiftUI

struct End: View {
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
