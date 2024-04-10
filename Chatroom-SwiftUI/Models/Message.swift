//
//  Message.swift
//  Chatroom-SwiftUI
//
//  Created by Frank Chen on 2024-03-28.
//

import Foundation

struct Message: Decodable, Identifiable, Equatable, Hashable {
    
    enum MessageError: Error {
        case noPhotoURL
    }
    var id = UUID()
    let userUid: String
    let text: String
    let photoURL: String?
    let createdAt: Date
    
    func isFromCurrentUser() -> Bool {
        guard let currentUser = AuthManager.shared.getCurrentUser() else {
            return false
        }
        
        if currentUser.uid == userUid {
            return true
        } else {
            return false
        }
    }
    
    func fetchPhotoURL() -> URL? {
        guard let photoURLString = photoURL, let url = URL(string: photoURLString) else {
            return nil
        }
        
        return url
    }
}
