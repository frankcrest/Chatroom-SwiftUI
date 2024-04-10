//
//  MessageView.swift
//  Chatroom-SwiftUI
//
//  Created by Frank Chen on 2024-03-28.
//

import SwiftUI
import SDWebImageSwiftUI

struct MessageView: View {
    var message: Message
    var body: some View {
        if !message.isFromCurrentUser() {
            HStack {
                Text(message.text)
                    .foregroundStyle(.black)
                    .padding(.vertical, 6)
                    .padding(.horizontal)
                    .background(Color(uiColor: .systemMint))
                    .cornerRadius(20)
                
                if let photoURL = message.fetchPhotoURL() {
                    WebImage(url: photoURL)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.top, 8)
            .padding(.horizontal)
        } else {
            HStack {
                if let photoURL = message.fetchPhotoURL() {
                    WebImage(url: photoURL)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                }
                
                Text(message.text)
                    .padding(.vertical, 6)
                    .padding(.horizontal)
                    .background(Color(uiColor: .lightGray))
                    .cornerRadius(20)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 8)
            .padding(.horizontal)
        }
    }
}

#Preview {
    MessageView(message: Message(userUid: "123", text: "This is a message", photoURL: "", createdAt: Date()))
}
