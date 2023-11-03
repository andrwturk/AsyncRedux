//
//  ReduxDispatcher.swift
//  AsyncRedux
//
//  Created by Andrii Turkin on 16.10.23.
//

import Foundation

/// Dispatch actions to modify state
public class ReduxDispatcher<StateType, ActionType> {
    
    private let recursiveActionCreators: [AnyRecursiveActionCreator<StateType, ActionType>]
    private let actionCreators: [AnyActionCreator<ActionType>]
    private let dispatchActionRelay = AsyncRelay<ActionType>()
    
    public init(
        recursiveActionCreators: [AnyRecursiveActionCreator<StateType, ActionType>],
        actionCreators: [AnyActionCreator<ActionType>]
    ) {
        self.recursiveActionCreators = recursiveActionCreators
        self.actionCreators = actionCreators
    }
    
    public func dispatch(action: ActionType) {
        dispatchActionRelay.accept(action)
    }
    
    private func mergedRecursiveActionCreatorsActions(stateObservable: AsyncStream<StateType>) -> AsyncStream<ActionType> {
        mergeAsyncSequences(recursiveActionCreators.map { creator in
            creator.observeActions(stateObservable: stateObservable)
        })
    }
    
    private func mergeActionCreators() -> AsyncStream<ActionType> {
        mergeAsyncSequences(actionCreators.map { actionCreator in
            actionCreator.observeActions()
        })
    }
    
    func observeAction(stateObservable: AsyncStream<StateType>) -> AsyncStream<ActionType> {
        mergeAsyncSequences(
            [dispatchActionRelay.stream,
            mergedRecursiveActionCreatorsActions(stateObservable: stateObservable),
            mergeActionCreators()]
        )
    }
}
