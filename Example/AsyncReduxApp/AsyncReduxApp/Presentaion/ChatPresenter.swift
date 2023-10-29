//
//  ChatPresenter.swift
//  AsyncReduxApp
//
//  Created by Andrii Turkin on 21.10.23.
//

import Foundation
import AsyncRedux

class ChatPresenter: ObservableObject {
    @Published var chatStateItem: ChatViewStateItem = .loading
    
    lazy var fetchMessagesActionCreator = FetchMessagesActionCreator(messagesRepository: MessagesRepository())
    
    lazy var dispatcher = ReduxDispatcher<ChatState, ChatAction>(
        recursiveActionCreators: [fetchMessagesActionCreator.toAny()],
        actionCreators: [])
    
    lazy var storage = StateStorage(
        initialState: ChatState(),
        reduxDispatcher: dispatcher,
        reducer: ChatStateReducer.invoke(state:action:))

    @MainActor func bind() {
        Task {
            for try await state in self.storage
                .observeState()  {
                if state.messages.isEmpty {
                    self.chatStateItem = .loading
                } else {
                    let messageItems = state.messages.map { message in
                        ChatMessageViewItem(item: ViewItem(text: message.text, author: ""), createdAt: message.createdAt)
                    }
                    self.chatStateItem = .ok(ChatViewItem(messages: messageItems))
                }
            }
        }
    }
    
    func addMessage(text: String) {
        storage.reduxDispatcher.dispatch(action: .sendMessage(text))
    }
    
}
