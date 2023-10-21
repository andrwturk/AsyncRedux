//
//  ChatMessageView.swift
//  CoyoteChat
//
//  Created by Andrii Turkin on 22.08.23.
//

import Foundation
import SwiftUI

struct ChatMessageView: View {
    var message: ChatMessageViewItem

    var body: some View {
        HStack(alignment: .bottom) {
            Text(message.item.text)
            
            Text(message.createdAt, style: .time)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(.thinMaterial)
        .cornerRadius(10)
    }
}

struct ChatMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessageView(message: ChatMessageViewItem(item: ViewItem(text: "Hello",
                                                                    author: ""),
                                                     createdAt: Date()))
    }
}
