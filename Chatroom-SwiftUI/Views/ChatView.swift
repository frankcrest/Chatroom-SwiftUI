//
//  ChatView.swift
//  Chatroom-SwiftUI
//
//  Created by Frank Chen on 2024-03-28.
//

import SwiftUI

struct ChatView: View {
    
    @StateObject var chatViewModel = ChatViewModel()
    @State var text = ""
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 4) {
                        ForEach(Array(chatViewModel.messages.enumerated()), id: \.element) { idx, message in
                            MessageView(message: message)
                                .id(idx)
                        }
                        .onChange(of: chatViewModel.messages) { newValue in
                            proxy.scrollTo(chatViewModel.messages.count - 1, anchor: .bottom)
                        }
                    }
                }
            }
            
            HStack {
                TextField("Hello there", text: $text, axis: .vertical)
                    .padding()

                Button(action: {
                    if text.count > 2 {
                        chatViewModel.sendMessage(text: text) { success in
                            if success {
                                
                            } else {
                                print("Error sending message")
                            }
                        }
                        text = ""
                    }
                }, label: {
                    Text("Send")
                        .foregroundColor(Color(uiColor: .systemBackground))
                        .padding(.vertical, 6)
                        .padding(.horizontal)
                        .background(.mint)
                        .cornerRadius(50)
                        .padding(.trailing)
                })
            }
            .background(Color.init(uiColor: .systemGray6))
            .cornerRadius(25)
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
    }
}

#Preview {
    ChatView()
}
