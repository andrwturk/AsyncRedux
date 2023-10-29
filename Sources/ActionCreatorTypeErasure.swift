//
//  ActionCreatorTypeErasure.swift
//  AsyncRedux
//
//  Created by Andrii Turkin on 16.10.23.
//

import Foundation

public extension ActionCreator {
    
    func toAny<ErasedActionType>() -> AnyActionCreator<ErasedActionType> where ErasedActionType == ActionType {
        return AnyActionCreator<ActionType>(wrappedActionCreator: self)
    }
}

public extension RecursiveActionCreator {
    func toAny<ErasedStateType, ErasedActionType>() -> AnyRecursiveActionCreator<ErasedStateType, ErasedActionType> where ErasedActionType == ActionType,                                                                           ErasedStateType == StateType {
        return AnyRecursiveActionCreator<StateType, ActionType>(wrappedActionCreator: self)
    }
}

public final class AnyActionCreator<WrappedActionType>: ActionCreator {
   
    public typealias ActionType = WrappedActionType
    
    private let wrappedObserveActions: () -> AnyAsyncSequence<WrappedActionType>
    
    init<WrappedActionCreator: ActionCreator>(wrappedActionCreator: WrappedActionCreator)
        where WrappedActionCreator.ActionType == WrappedActionType {
            wrappedObserveActions = { wrappedActionCreator.observeActions() }
    }
    
    public func observeActions() -> AnyAsyncSequence<ActionType> {
        return wrappedObserveActions()
    }
}

public final class AnyRecursiveActionCreator<WrappedStateType, WrappedActionType>: RecursiveActionCreator {
   
    public typealias StateType = WrappedStateType
    public typealias ActionType = WrappedActionType
    
    private let wrappedObserveActions: (AnyAsyncSequence<WrappedStateType>) -> AnyAsyncSequence<WrappedActionType>
    
    init<WrappedActionCreator: RecursiveActionCreator>(wrappedActionCreator: WrappedActionCreator)
        where WrappedActionCreator.ActionType == WrappedActionType, WrappedStateType == WrappedActionCreator.StateType {
            wrappedObserveActions = { wrappedActionCreator.observeActions(stateObservable: $0) }
    }
    
    public func observeActions(stateObservable: AnyAsyncSequence<StateType>) -> AnyAsyncSequence<ActionType> {
        return wrappedObserveActions(stateObservable)
    }
    
}
