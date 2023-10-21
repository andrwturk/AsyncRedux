//
//  ChatAction.swift
//  AsyncReduxApp
//
//  Created by Andrii Turkin on 22.10.23.
//

import Foundation

enum ChatAction {
    case fetch
    case sendMessage(String)
    case addMessages([String])
    case error(Error)
}
