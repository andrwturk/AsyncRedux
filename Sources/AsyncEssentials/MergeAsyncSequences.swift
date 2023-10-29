//
//  MergeAsyncThrowingStreams.swift
//  AsyncRedux
//
//  Created by Andrii Turkin on 16.10.23.
//

import Foundation

func mergeAsyncSequences<T>(_ streams: [AnyAsyncSequence<T>]) -> AnyAsyncSequence<T> {
    AsyncThrowingStream { continuation in
        Task {
            do {
                try await withThrowingTaskGroup(of: Void.self) { group in
                    for stream in streams {
                        group.addTask {
                            do {
                                for try await item in stream {
                                    continuation.yield(item)
                                }
                            } catch {
                                continuation.finish(throwing: error)
                            }
                        }
                    }
                    
                    try await group.waitForAll()
                }
                continuation.finish()
            } catch {
                continuation.finish(throwing: error)
            }
        }
    }.toAny()
}
