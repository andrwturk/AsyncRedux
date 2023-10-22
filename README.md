# AsyncRedux
Lightweight Redux implementation using AsyncSequence

## Usage
If we were to develop the business logic for a messaging application.

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
                    return ChatAction.addMessages([MESSAGES])
                    
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

// observe state
for try await state in storage.observeState()  {
    // update UI
}        

``` 
