//
//  StateStorage.swift
//  AsyncRedux
//
//  Created by Andrii Turkin on 16.10.23.
//

import Foundation

@available(iOS 13.0, *)
public final class StateStorage<StateType, ActionType> {
    
    public let reduxDispatcher: ReduxDispatcher<StateType, ActionType>
    private let initialState: StateType
    private let reducer: (StateType, ActionType) -> StateType
    private var currentState: StateType
    private let currentStateRelay = AsyncRelay<StateType>()
    
    public init(
        initialState: StateType,
        reduxDispatcher: ReduxDispatcher<StateType, ActionType>,
        reducer: @escaping (StateType, ActionType) -> StateType
    ) {
        self.initialState = initialState
        self.currentState = initialState
        self.reduxDispatcher = reduxDispatcher
        self.reducer = reducer
        self.currentStateRelay.accept(initialState)
    }
    
    public func observeState() -> AsyncStream<StateType> {
        AsyncStream { continuation in
            Task {
                for try await action in self.reduxDispatcher
                    .observeAction(stateObservable: currentStateRelay.stream) {
                    let oldState = self.currentState
                    let newState = self.reducer(oldState, action)
                    self.currentState = newState
                    self.currentStateRelay.accept(currentState)
                    continuation.yield(newState)
                }
                continuation.finish()
            }
        }
    }
}
