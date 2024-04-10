//
//  DatabaseManager.swift
//  Chatroom-SwiftUI
//
//  Created by Frank Chen on 2024-03-28.
//

import Combine
import Foundation
import FirebaseFirestore

enum FetchMessagesError: Error {
    case snapshotError
}

final class DatabaseManager {
    
    var messagesPublisher = PassthroughSubject<[Message], Error>()
    
    static let shared = DatabaseManager()
    
    let messageRef = Firestore.firestore().collection("messages")
    
    func fetchMessages(completion: @escaping (Result<[Message], FetchMessagesError>) -> Void) {
        messageRef.order(by: "createdAt").limit(to: 25).getDocuments { [weak self] snapshot, error in
            guard let snapshot = snapshot, let strongSelf = self, error == nil else {
                completion(.failure(.snapshotError))
                return
            }
            
            strongSelf.listenForNewMessageInDataBase()
            let messages = strongSelf.createMessagesFromFirebaseSnapshot(snapshot: snapshot)
            
            completion(.success(messages))
        }
    }
    
    func sendMessageToDatabase(message: Message, completion: @escaping (Bool) -> Void) {
        
        let data = [
            "text": message.text,
            "userUid": message.userUid,
            "photoURL": message.photoURL ?? "",
            "createdAt": Timestamp(date: message.createdAt)
        ] as [String : Any]
        
        messageRef.addDocument(data: data) { error in
            guard error == nil else {
                completion(false)
                return
            }
            
            completion(true)
        }
    }
    
    func listenForNewMessageInDataBase() {
        messageRef.order(by: "createdAt").limit(to: 25).addSnapshotListener { [weak self] snapshot, error in
            guard let snapshot = snapshot, let strongSelf = self, error == nil else {
                return
            }
            
            let messages = strongSelf.createMessagesFromFirebaseSnapshot(snapshot: snapshot)
            strongSelf.messagesPublisher.send(messages)
        }
    }
    
    func createMessagesFromFirebaseSnapshot(snapshot: QuerySnapshot) -> [Message] {
        let docs = snapshot.documents
        
        var messages = [Message]()
        
        for doc in docs {
            let data = doc.data()
            let text = data["text"] as? String ?? "Error"
            let userUid = data["userUid"] as? String ?? "Error"
            let photoURL = data["photoURL"] as? String ?? "Error"
            let createdAt = data["createdAt"] as? Timestamp ?? Timestamp()
            
            let msg = Message(userUid: userUid, text: text, photoURL: photoURL, createdAt: createdAt.dateValue())
            messages.append(msg)
        }
        
        return messages
    }
}
