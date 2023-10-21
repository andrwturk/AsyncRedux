//
//  ActionCreator.swift
//  AsyncRedux
//
//  Created by Andrii Turkin on 16.10.23.
//

import Foundation

public protocol ActionCreator {
    associatedtype ActionType
    func observeActions() -> AnyAsyncSequence<ActionType>
}
