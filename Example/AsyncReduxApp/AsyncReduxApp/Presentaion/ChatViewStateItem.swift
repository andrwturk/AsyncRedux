//
//  ChatViewStateItem.swift
//  AsyncReduxApp
//
//  Created by Andrii Turkin on 22.10.23.
//

import Foundation

enum ChatViewStateItem {
    case loading
    case ok(ChatViewItem)
    case error
}

struct ChatViewItem {
    let messages: [ChatMessageViewItem]
}

struct ChatMessageViewItem: Identifiable {
    let item: ViewItem
    let createdAt: Date
    var id: Date { createdAt }
}

struct ViewItem {
    let text: String
    let author: String
}

