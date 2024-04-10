//
//  SignInView.swift
//  Chatroom-SwiftUI
//
//  Created by Frank Chen on 2024-03-28.
//

import SwiftUI

struct SignInView: View {
    
    @Binding var showSignIn: Bool
    
    var body: some View {
        VStack {
            Image("stevejobs")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: 400, maxHeight: 450, alignment: .top)
            
            Text("Welcome Please Sign In")
                .font(.largeTitle)
            
            VStack(spacing: 20) {
                Button(action: {
                    AuthManager.shared.signInWithApple { result in
                        switch result {
                        case .success(_):
                            showSignIn = false
                        case .failure(let failure):
                            print("Failed to sign in with google: \(failure)")
                        }
                    }
                }, label: {
                    Text("Sign in with Apple")
                        .padding()
                        .foregroundColor(.primary)
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke()
                                .foregroundColor(.primary)
                                .frame(width: 300)
                        }
                })
                
                Button(action: {
                    AuthManager.shared.signInWithGoogle { result in
                        switch result {
                        case .success(_):
                            showSignIn = false
                        case .failure(let failure):
                            print("Failed to sign in with google: \(failure)")
                        }
                    }
                }, label: {
                    Text("Sign in with Google")
                        .padding()
                        .foregroundColor(.primary)
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke()
                                .foregroundColor(.primary)
                                .frame(width: 300)
                        }
                })
            }
            
            Spacer()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SignInView(showSignIn: .constant(false))
}
