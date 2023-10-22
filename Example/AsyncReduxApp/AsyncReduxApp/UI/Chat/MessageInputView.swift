//
//  MessageInputView.swift
//  AsyncReduxApp
//
//  Created by Andrii Turkin on 22.10.23.
//

import Foundation
import SwiftUI

struct MessageInputView: View {
    
    @State private var newMessage: String = ""
    private var action: (String) -> Void
    
    init(action: @escaping (String) -> Void) {
        self.action = action
    }
    
    var body: some View {
        HStack {
            TextField("Enter message...", text: $newMessage)
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 10) // Apply a rounded rectangle shape
                                .stroke(Color.gray, lineWidth: 1)) // Set the border style
                .clipShape(RoundedRectangle(cornerRadius: 10)) // Clip to the shape
                .padding(.bottom)
            
            Button {
                action(newMessage)
                newMessage = ""
            } label: {
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(newMessage.count > 0 ? .blue : .gray)
                    .overlay(Image(systemName: "arrow.up")
                        .fontWeight(.bold)
                        .foregroundColor(.white))
            }.disabled(newMessage.count == 0)
             .padding(.bottom)
        }
        .padding([.leading, .trailing])
    }
}
