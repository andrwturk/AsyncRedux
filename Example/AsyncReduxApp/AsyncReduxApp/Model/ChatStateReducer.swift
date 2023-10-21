//
//  ChatStateReducer.swift
//  AsyncReduxApp
//
//  Created by Andrii Turkin on 21.10.23.
//

import Foundation

final class ChatStateReducer {
    static func invoke(state: ChatState,
                       action: ChatAction) -> ChatState {
        switch action {
        case .addMessages(let messages):
            return ChatState(messages: messages.map { ChatMessage(text: $0, createdAt: Date()) })
        case .sendMessage(let message):
            return ChatState(messages: state.messages + [ChatMessage(text: message, createdAt: Date())])
        default:
            return state
        }
    }
}
