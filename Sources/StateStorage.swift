//
//  StateStorage.swift
//  AsyncRedux
//
//  Created by Andrii Turkin on 16.10.23.
//

import Foundation

public final class StateStorage<StateType, ActionType> {
    
    public let reduxDispatcher: ReduxDispatcher<StateType, ActionType>
    
    private let initialState: StateType
    private let reducer: (StateType, ActionType) -> StateType
    private var currentState: StateType
    
    public init(
        initialState: StateType,
        reduxDispatcher: ReduxDispatcher<StateType, ActionType>,
        reducer: @escaping (StateType, ActionType) -> StateType
    ) {
        self.initialState = initialState
        self.currentState = initialState
        self.reduxDispatcher = reduxDispatcher
        self.reducer = reducer
    }
    
    public func observeState() -> AnyAsyncSequence<StateType> {
        return AsyncThrowingStream { continuation in
            Task {
                do {
                    for try await action in self.reduxDispatcher
                                                .observeAction(stateObservable: AsyncThrowingStream<StateType, Error> { cont in
                                                    cont.yield(self.currentState)}.toAny()) {
                        let oldState = self.currentState
                        let newState = self.reducer(oldState, action)
                        self.currentState = newState
                        continuation.yield(newState)
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }.toAny()
    }
}
