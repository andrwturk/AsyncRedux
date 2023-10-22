//
//  ActionCreator.swift
//  AsyncRedux
//
//  Created by Andrii Turkin on 16.10.23.
//

import Foundation

public protocol ActionCreator {
    associatedtype ActionType
    
    /// Generate an actions that is not tied to the current state.
    ///
    ///     func observeActions() -> AnyAsyncSequence<ActionType> {
    ///         // fetch data
    ///         return .action(DATA)
    ///     }
    ///
    func observeActions() -> AnyAsyncSequence<ActionType>
}
