//
//  MergeAsyncThrowingStreams.swift
//  AsyncRedux
//
//  Created by Andrii Turkin on 16.10.23.
//

import Foundation

func mergeAsyncSequences<T>(_ streams: [AsyncStream<T>]) -> AsyncStream<T> {
    AsyncStream { continuation in
        Task {
            await withTaskGroup(of: Void.self) { group in
                for stream in streams {
                    group.addTask {
                        for await item in stream {
                            continuation.yield(item)
                        }
                    }
                }
                
                await group.waitForAll()
                continuation.finish()
            }
        }
    }
}
