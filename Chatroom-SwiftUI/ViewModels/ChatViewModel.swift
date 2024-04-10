//
//  ChatViewModel.swift
//  Chatroom-SwiftUI
//
//  Created by Frank Chen on 2024-03-28.
//

import Foundation
import Combine

class ChatViewModel: ObservableObject {
    @Published var messages = [Message]()
    var subscribers: Set<AnyCancellable> = []
    
    @Published var mockData: [Message] = [
        Message(userUid: "1", text: "Hello!", photoURL: "https://example.com/photo1.jpg", createdAt: Date()),
        Message(userUid: "2", text: "Hi there!", photoURL: "https://example.com/photo2.jpg", createdAt: Date()),
        Message(userUid: "3", text: "How are you?", photoURL: "https://example.com/photo3.jpg", createdAt: Date()),
        Message(userUid: "4", text: "I'm good, thanks!", photoURL: "https://example.com/photo4.jpg", createdAt: Date()),
        Message(userUid: "5", text: "What's up?", photoURL: "https://example.com/photo5.jpg", createdAt: Date())
    ]
    
    init() {
        DatabaseManager.shared.fetchMessages { [weak self] result in
            switch result {
            case .success(let msgs):
                self?.messages = msgs
            case .failure(let error):
                print(error)
            }
        }
        
        subscribeToMessagesPublisher()
    }
    
    func sendMessage(text: String, completion: @escaping (Bool) -> Void) {
        guard let user = AuthManager.shared.getCurrentUser() else {
            return
        }
        let msg = Message(userUid: user.uid, text: text, photoURL: user.photoURL, createdAt: Date())
        DatabaseManager.shared.sendMessageToDatabase(message: msg) { success in
            if success {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    private func subscribeToMessagesPublisher() {
        DatabaseManager.shared.messagesPublisher.receive(on: DispatchQueue.main)
            .sink { completion in
                print(completion)
            } receiveValue: { [weak self] messages in
                self?.messages = messages
            }
            .store(in: &subscribers)

    }
}
