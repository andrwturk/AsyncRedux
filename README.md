# AsyncRedux — Asynchronous Redux Framework for Swift

## Introduction
AsyncRedux is a lightweight, asynchronous Redux framework for Swift. It simplifies state management in your Swift applications. Whether you are using SwiftUI or UIKit, AsyncRedux offers built-in support for action creators, allowing for a clean, easy-to-understand data flow.

## Usage Example
Here's a complete example that uses AsyncRedux in a SwiftUI application to manage a simple chat view:

```swift
import AsyncRedux

struct ChatView: View {
    
    // obtain state storage from the environment
    @EnvironmentObject var stateStorage: StateStorage
    @State private var newMessage: String = ""
    @State private var messages: [String] = []
    
    var body: some View {
        VStack {
            // display messages
            LazyVStack {
                ForEach(messages) { message in
                    Text(message)
                }
            }
            TextField("Enter message...", text: $newMessage)
            Button {
                // dispatch `sendMessage` action
                stateStorage.reduxDispatcher.dispatch(action: .sendMessage(newMessage))
                newMessage = ""
            } label: {
                Text("Send")
            }
        }.task {
            // observe state change in Redux stack and update 
            for await state in stateStorage.observeState()  {
                messages = state.messages
            }
        }
    }
}
```

## Installation
To install AsyncRedux, you can use Swift Package Manager.
Add the following line to your Package.swift file:

```swift
dependencies: [
    .package(url: "hhttps://github.com/andrwturk/AsyncRedux.git", .upToNextMajor(from: "1.0.0"))
]
```

## Setting up core Redux components

After you've installed AsyncRedux, you can quickly get started by importing it:

```swift
import AsyncRedux
```

Set up your state and actions:

```swift
// Create feature state
struct State {
    // define feature state fields
    let messages: [String]
}

// Create actions
struct Action {
    case fetchMessages([String])
    case sendMessage(String)
}
```

Then create action creators and state reducer:

```swift
class FetchMessagesActionCreator: RecursiveActionCreator {
    
    // implement effect which depends on state and returns action
    func observeActions(stateObservable: AsyncStream<State>) -> AsyncStream<Action> {
            stateObservable
            .compactMap { state -> ChatAction? in
                // define effect for specific state — no messages
                if state.messages.isEmpty { 
                    // fetch messages from repository
                    return .addMessages([MESSAGES])
                    
                // skip when messages already loaded
                } else {
                    return nil
                }
            }.toAsyncStream()
    }
}

// add reducer
final class StateReducer {
    static func invoke(state: State,
                       action: Action) -> State {
        switch action {
        case .fetchMessages(let messages):
            return ChatState(messages: messages)
        case .sendMessage(let message):
            return ChatState(messages: state.messages + [message])
        }
    }
}
```

Finally, set up dispatcher and state storage:

```swift
// add dispatcher
var dispatcher = ReduxDispatcher<State, Action>(
        recursiveActionCreators: [FetchMessagesActionCreator().toAny()],
        actionCreators: [])
        
// add dispatcher to the storage
var storage = StateStorage(
        initialState: State(),
        reduxDispatcher: dispatcher,
        reducer: StateReducer.invoke(state:action:))


``` 

## Example App: Building a Chat Application
In this repository, you will find a complete example application that demonstrates how to build a real-time chat application using the AsyncRedux framework. The example aims to showcase the core features and usage patterns of AsyncRedux in a more complex use-case.

## Contributing
Your contributions are welcome! Feel free to open issues for feature requests or bug reports, and submit pull requests for new features or fixes. For major changes, it's always good to open an issue first to discuss what you would like to change.
