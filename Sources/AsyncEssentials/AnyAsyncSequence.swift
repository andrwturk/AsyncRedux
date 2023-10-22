//
//  AnyAsyncSequence.swift
//  AsyncTest
//
//  Created by Alexander Leontev on 09.07.23.
//

import Foundation

public struct AnyAsyncSequence<ElementType> : AsyncSequence {
    
    public typealias AsyncIterator = AnyAsyncIterator<ElementType>
    public typealias Element = ElementType
    
    private let makeAsyncIteratorClosure: () -> AnyAsyncIterator<ElementType>
    
    init<ActualSequenceType : AsyncSequence>(
        _ underlyingSequence: ActualSequenceType
    ) where ActualSequenceType.Element == ElementType {
        makeAsyncIteratorClosure = {
            AnyAsyncIterator(underlyingSequence.makeAsyncIterator())
        }
    }
    
    public func makeAsyncIterator() -> AnyAsyncIterator<ElementType> {
        return makeAsyncIteratorClosure()
    }
    
}

public struct AnyAsyncIterator<IteratorElementType>: AsyncIteratorProtocol {
    
    public typealias Element = IteratorElementType
    
    private let nextClosure: () async throws -> IteratorElementType?
    
    init<ActualIteratorType : AsyncIteratorProtocol>(
        _ underlyingIterator: ActualIteratorType
    ) where ActualIteratorType.Element == Element {
        var mutableUnderlyingIterator = underlyingIterator
        nextClosure = {
            try await mutableUnderlyingIterator.next()
        }
    }
    
    public mutating func next() async throws -> IteratorElementType? {
        return try await nextClosure()
    }
    
}

public extension AsyncSequence {
    func typeErased() -> AnyAsyncSequence<Element> {
        return AnyAsyncSequence(self)
    }
}
