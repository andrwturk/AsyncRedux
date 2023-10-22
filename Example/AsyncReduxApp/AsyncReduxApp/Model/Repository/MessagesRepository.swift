//
//  MessagesRepository.swift
//  AsyncReduxApp
//
//  Created by Andrii Turkin on 21.10.23.
//

import Foundation

class MessagesRepository {
    private let messages: [String] = ["Hey", "Hello"]
    
    func fetchMessages() async -> [String] {
        try? await Task.sleep(nanoseconds: 1_000_000_000 * 3)
        return messages
    }
}
