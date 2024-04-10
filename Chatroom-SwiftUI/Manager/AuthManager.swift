//
//  AuthManager.swift
//  Chatroom-SwiftUI
//
//  Created by Frank Chen on 2024-03-28.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth

enum GoogleSignInError: Error {
    case unableToGetTopVC
    case signInPresentationError
    case authSignInError
}

enum AppleSignInError: Error {
    case unableToGetTopVC
    case authSignInError
    case appleIDTokenError
}

struct ChatRoomUser {
    let uid: String
    let name: String
    let email: String?
    let photoURL: String?
}

class AuthManager {
    
    static let shared = AuthManager()
    
    let auth = Auth.auth()
    
    let signInApple = SignInApple()
    
    func getCurrentUser() -> ChatRoomUser? {
        guard let authUser = auth.currentUser else {
            return nil
        }
        
        return ChatRoomUser(uid: authUser.uid, name: authUser.displayName ?? "Unknown", email: authUser.email, photoURL: authUser.photoURL?.absoluteString)
    }
    
    func signInWithApple(completion: @escaping (Result<ChatRoomUser, AppleSignInError>) -> Void) {
        signInApple.signInWithApple { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let appleResult):
                let credential = OAuthProvider.appleCredential(withIDToken: appleResult.idToken,
                                                               rawNonce: appleResult.nonce,
                                                               fullName: appleResult.fullname)
                
                strongSelf.auth.signIn(with: credential) { (authResult, error) in
                    guard let authResult = authResult, error == nil else {
                        completion(.failure(.authSignInError))
                        return
                    }
                    
                    let user = ChatRoomUser(uid: authResult.user.uid, name: authResult.user.displayName ?? "Unknown", email: authResult.user.email, photoURL: authResult.user.photoURL?.absoluteString)
                    
                    completion(.success(user))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func signInWithGoogle(completion: @escaping (Result<ChatRoomUser, GoogleSignInError>) -> Void) {
        let clientID = "595285660945-ii0fi7qtj4srriqqrdla5naqn3a5339t.apps.googleusercontent.com"
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let topVC = UIApplication.getTopViewController() else {
            completion(.failure(.unableToGetTopVC))
            
            return
        }
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: topVC) { [unowned self] result, error in
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString,
                  error == nil
            else {
                completion(.failure(.signInPresentationError))
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            auth.signIn(with: credential) { result, error in
                guard let result = result, error == nil else {
                    completion(.failure(.authSignInError))
                    return
                }
                
                let user = ChatRoomUser(uid: result.user.uid, name: result.user.displayName ?? "Unknown", email: result.user.email, photoURL: result.user.photoURL?.absoluteString)
                
                completion(.success(user))
            }
        }
    }
    
    func signOut() throws {
        try auth.signOut()
    }
}
