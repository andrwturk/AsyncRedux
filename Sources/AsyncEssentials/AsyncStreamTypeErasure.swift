//
//  AsyncStreamTypeErasure.swift
//  AsyncRedux
//
//  Created by Andrii Turkin on 02.11.23.
//

import Foundation

public extension AsyncSequence {
    
    func toAsyncThrowingStream() -> AsyncThrowingStream<Element, Error> {
        var asyncIterator = self.makeAsyncIterator()
        
        return AsyncThrowingStream<Element, Error> {
            try await asyncIterator.next()
        }
    }
    
    func toAsyncStream() -> AsyncStream<Element> {
        var asyncIterator = self.makeAsyncIterator()
        return AsyncStream<Element> {
            try? await asyncIterator.next()
        }
    }
}
