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
    
    func observeActions(stateObservable: AnyAsyncSequence<StateType>) -> AnyAsyncSequence<ActionType>
}
