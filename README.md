# AsyncRedux
Lightweight Redux implementation using AsyncSequence.

## Usage
If we were to develop the business logic for a messaging application. 

```swift
struct ChatView: View {
    
    // add Redux stack
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

## Setup Redux stack



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

class FetchMessagesActionCreator: RecursiveActionCreator {
    
    // implement effect which depends on state and returns action
    func observeActions(stateObservable: AnyAsyncSequence<State>) -> AnyAsyncSequence<Action> {
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
            }.toAny()
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
