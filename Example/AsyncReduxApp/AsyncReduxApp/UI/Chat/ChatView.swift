//
//  ChatView.swift
//  AsyncReduxApp
//
//  Created by Andrii Turkin on 21.10.23.
//

import Foundation
import SwiftUI

struct ChatView: View {
    
    @ObservedObject var presenter: ChatPresenter
    @State private var newMessage = ""
    
    var body: some View {
        VStack {
            switch presenter.chatStateItem {
            case .loading:
                ProgressView()
            case .ok(let chatViewItem):
                ScrollViewReader { proxy in
                    ScrollView {
                        ForEach(chatViewItem.messages) { message in
                            ChatMessageView(message: message)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding([.leading, .trailing])
                        }.padding([.bottom])
                    }
                    .scrollDismissesKeyboard(.interactively)
                    .onAppear {
                        proxy.scrollTo(chatViewItem.messages.count - 1, anchor: .bottom)
                    }
                    .onChange(of: chatViewItem.messages.count, { _, newValue in
                        proxy.scrollTo(newValue - 1, anchor: .bottom)
                    })
                }
                
                MessageInputView(action: { message in
                    presenter.addMessage(text: message)
                })
            case .error:
                HStack {}
            }   
        }.onAppear {
            presenter.bind()
        }
    }
}

#Preview {
    let chatPresenter = ChatPresenter()
    let messages = [
        ChatMessageViewItem(item: ViewItem(text: "Hey", author: ""), createdAt: Date()),
        ChatMessageViewItem(item: ViewItem(text: "Hello", author: ""), createdAt: Date())]
    chatPresenter.chatStateItem = .ok(ChatViewItem(messages: messages))
    return ChatView(presenter: chatPresenter)
}


