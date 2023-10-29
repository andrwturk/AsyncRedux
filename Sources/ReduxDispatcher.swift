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
    private let dispatchActionRelay = AsyncThrowingRelay<ActionType>()
    
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
    
    private func mergedRecursiveActionCreatorsActions(stateObservable: AnyAsyncSequence<StateType>) -> AnyAsyncSequence<ActionType> {
        mergeAsyncSequences(recursiveActionCreators.map { creator in
            creator.observeActions(stateObservable: stateObservable)
        })
    }
    
    private func mergeActionCreators() -> AnyAsyncSequence<ActionType> {
        mergeAsyncSequences(actionCreators.map { actionCreator in
            actionCreator.observeActions()
        })
    }
    
    func observeAction(stateObservable: AnyAsyncSequence<StateType>) -> AnyAsyncSequence<ActionType> {
        mergeAsyncSequences(
            [dispatchActionRelay.stream.toAny(),
            mergedRecursiveActionCreatorsActions(stateObservable: stateObservable),
            mergeActionCreators()]
        )
    }
}
