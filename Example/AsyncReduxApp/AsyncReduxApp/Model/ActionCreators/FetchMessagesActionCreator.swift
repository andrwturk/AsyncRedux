//
//  FetchMessagesActionCreator.swift
//  AsyncReduxApp
//
//  Created by Andrii Turkin on 21.10.23.
//

import Foundation
import AsyncRedux
import AsyncAlgorithms

class FetchMessagesActionCreator: RecursiveActionCreator {
    
    private let messagesRepository: MessagesRepository
    
    init(messagesRepository: MessagesRepository) {
        self.messagesRepository = messagesRepository
    }

    func observeActions(stateObservable: AsyncStream<ChatState>) -> AsyncStream<ChatAction> {
        stateObservable
            .removeDuplicates()
            .compactMap { state -> ChatAction? in
                
                if state.messages.isEmpty {
                    let messages = await self.messagesRepository.fetchMessages()
                    return ChatAction.addMessages(messages)
                } else {
                    return nil
                }
                
            }.toAsyncStream()
    }
}
