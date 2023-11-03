//
//  RecursiveActionCreator.swift
//  AsyncRedux
//
//  Created by Andrii Turkin on 16.10.23.
//

import Foundation

public protocol RecursiveActionCreator {
    
    associatedtype ActionType
    associatedtype StateType
    
    /// Generate actions that are influenced by the current state.
    func observeActions(stateObservable: AsyncStream<StateType>) -> AsyncStream<ActionType>
}
