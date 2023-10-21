//
//  AsyncThrowingRelay.swift
//  AsyncRedux
//
//  Created by Andrii Turkin on 16.10.23.
//

import Foundation

class AsyncThrowingRelay<T> {
    private var continuation: AsyncThrowingStream<T, Error>.Continuation?
    private var _stream: AsyncThrowingStream<T, Error>!
    
    init() {
        _stream = AsyncThrowingStream { continuation in
            self.continuation = continuation
        }
    }
    
    var stream: AsyncThrowingStream<T, Error> {
        _stream
    }

    func accept(_ value: T) {
        continuation?.yield(value)
    }

    func throwError(_ error: Error) {
        continuation?.finish(throwing: error)
    }

    func finish() {
        continuation?.finish()
    }
}
