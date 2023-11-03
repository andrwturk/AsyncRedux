//
//  AsyncRelay.swift
//  AsyncRedux
//
//  Created by Andrii Turkin on 03.11.23.
//

import Foundation

class AsyncRelay<T> {
    private var continuation: AsyncStream<T>.Continuation?
    private var _stream: AsyncStream<T>!
    
    init() {
        _stream = AsyncStream { continuation in
            self.continuation = continuation
        }
    }
    
    var stream: AsyncStream<T> {
        _stream
    }

    func accept(_ value: T) {
        continuation?.yield(value)
    }

    func finish() {
        continuation?.finish()
    }
}
