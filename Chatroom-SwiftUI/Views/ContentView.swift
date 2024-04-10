//
//  ContentView.swift
//  Chatroom-SwiftUI
//
//  Created by Frank Chen on 2024-03-28.
//

import SwiftUI

struct ContentView: View {
    
    @State var showSignIn: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                ChatView()
                    .navigationTitle("Chatroom")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(action: {
                                do {
                                    try AuthManager.shared.signOut()
                                    showSignIn = true
                                } catch {
                                    print("Error signing out")
                                }
                            }, label: {
                                Text("Sign Out")
                                    .foregroundStyle(.red)
                            })
                        }
                    }
                    .onAppear {
                        showSignIn = AuthManager.shared.getCurrentUser() == nil
                    }
                    .fullScreenCover(isPresented: $showSignIn, content: {
                        SignInView(showSignIn: $showSignIn)
                    })
            }
        }
    }
}

#Preview {
    ChatView()
}
