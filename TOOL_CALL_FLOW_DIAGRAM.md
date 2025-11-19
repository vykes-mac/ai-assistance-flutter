# Tool Call Flow Diagram

## Complete Tool Call Architecture

```mermaid
sequenceDiagram
    participant User
    participant ChatPage as ChatPage<br/>(UI)
    participant ChatCubit as ChatCubit<br/>(State Management)
    participant ChatRepo as ChatRepository<br/>(Serverpod Client)
    participant Server as ChatEndpoint<br/>(Serverpod Server)
    participant Gemini as GeminiService<br/>(Gemini API)
    participant ToolExec as ToolExecutor<br/>(Local)
    participant Counter as CounterCubit<br/>(App State)

    %% Initial user message
    User->>ChatPage: Types "increment counter by 3"
    ChatPage->>ChatCubit: sendMessage(text)
    
    %% ChatCubit prepares request
    activate ChatCubit
    Note over ChatCubit: Creates ChatRequestData<br/>- message: user text<br/>- currentCounterValue<br/>- history<br/>- toolResults: null
    
    ChatCubit->>ChatRepo: sendMessage(request)
    activate ChatRepo
    
    %% Repository sends to server
    ChatRepo->>Server: HTTP POST /chat<br/>ChatRequestData
    activate Server
    
    %% Server processes with Gemini
    Note over Server: Validates request<br/>Rate limiting check
    Server->>Gemini: streamChat(message, counterValue, history)
    activate Gemini
    
    %% Gemini calls AI
    Note over Gemini: Builds system instruction<br/>Attaches tool definitions:<br/>- increment_counter<br/>- decrement_counter<br/>- reset_counter<br/>- set_counter_value<br/>- get_counter_history
    
    Gemini->>Gemini: Call Gemini 2.0 Flash API
    
    %% AI responds with tool calls
    Note over Gemini: AI decides to use tool:<br/>set_counter_value(value: 3)
    
    Gemini-->>Server: Stream: tool_call<br/>{toolName: "set_counter_value", args: {value: 3}}
    deactivate Gemini
    
    Server-->>ChatRepo: ChatResponseData<br/>[{type: "tool_call", toolName: "set_counter_value", args: "value:3"}]
    deactivate Server
    
    ChatRepo-->>ChatCubit: response
    deactivate ChatRepo
    
    %% ChatCubit processes tool calls
    Note over ChatCubit: Processes responses<br/>Finds tool_call type
    
    ChatCubit->>ChatCubit: Show "Executing: set_counter_value"
    
    ChatCubit->>ToolExec: executeTool("set_counter_value", "value:3")
    activate ToolExec
    
    %% Tool executor calls counter
    ToolExec->>ToolExec: Parse args: {value: 3}
    ToolExec->>Counter: setValue(3)
    activate Counter
    Counter->>Counter: Update counter state to 3<br/>Add to history
    Counter-->>ToolExec: State updated
    deactivate Counter
    
    ToolExec-->>ChatCubit: ToolExecutionResult<br/>{message: "Counter set to 3", action: "set"}
    deactivate ToolExec
    
    %% Send tool results back to server
    Note over ChatCubit: Creates follow-up request<br/>with tool results
    
    ChatCubit->>ChatRepo: sendMessage(request)<br/>- message: ""<br/>- toolResults: [{name: "set_counter_value", response: "Counter set to 3"}]
    activate ChatRepo
    
    ChatRepo->>Server: HTTP POST /chat<br/>ChatRequestData with toolResults
    activate Server
    
    Server->>Gemini: streamChat(message: "", toolResults)
    activate Gemini
    
    Note over Gemini: Converts toolResults to<br/>FunctionResponse objects
    
    Gemini->>Gemini: Call Gemini API with<br/>function responses
    
    Note over Gemini: AI processes tool results<br/>Generates natural language response
    
    Gemini-->>Server: Stream: text<br/>"I've set the counter to 3 for you!"
    deactivate Gemini
    
    Server-->>ChatRepo: ChatResponseData<br/>[{type: "text", content: "I've set the counter to 3 for you!"}]
    deactivate Server
    
    ChatRepo-->>ChatCubit: response
    deactivate ChatRepo
    
    %% Display final response
    Note over ChatCubit: Processes response<br/>No more tool calls
    
    ChatCubit->>ChatCubit: showMessageWithTypewriter()
    deactivate ChatCubit
    
    ChatCubit->>ChatPage: Update state with AI message
    ChatPage->>User: Displays "I've set the counter to 3 for you!"<br/>(with typewriter effect)
```

## Project Structure

```
app_use/
│
├── lib/                                    # 📱 Flutter App (Client)
│   ├── main.dart                          # App entry point
│   ├── app.dart                           # Root app widget
│   │
│   ├── chat/                              # 💬 Chat Feature
│   │   ├── cubit/
│   │   │   ├── chat_cubit.dart           # Orchestrates chat flow
│   │   │   └── chat_state.dart           # Chat state definition
│   │   │
│   │   ├── repositories/
│   │   │   ├── chat_repository.dart      # Abstract repository
│   │   │   └── chat_repository_impl.dart # Serverpod client wrapper
│   │   │
│   │   ├── services/
│   │   │   ├── tool_executor.dart        # Tool executor interface
│   │   │   └── counter_tool_executor.dart # Counter tool implementation
│   │   │
│   │   ├── models/
│   │   │   ├── chat_message_model.dart   # Message models
│   │   │   └── tool_execution_result.dart # Tool result wrapper
│   │   │
│   │   ├── view/
│   │   │   └── chat_page.dart            # Main chat UI
│   │   │
│   │   └── widgets/
│   │       ├── chat_input.dart           # Message input widget
│   │       ├── chat_message_list.dart    # Message list widget
│   │       └── tool_execution_indicator.dart # Tool execution UI
│   │
│   └── counter/                           # 🔢 Counter Feature
│       ├── cubit/
│       │   ├── counter_cubit.dart        # Counter state management
│       │   └── counter_state.dart        # Counter state definition
│       ├── models/
│       │   └── counter_operation.dart    # Operation history model
│       └── view/
│           └── counter_page.dart         # Counter UI
│
├── app_use_server/                        # 🖥️ Backend (Serverpod)
│   │
│   ├── app_use_server_client/            # 📦 Generated Client SDK
│   │   └── lib/
│   │       ├── app_use_server_client.dart
│   │       └── src/
│   │           ├── protocol/             # Generated protocol classes
│   │           │   ├── chat_request_data.dart
│   │           │   ├── chat_response_data.dart
│   │           │   ├── chat_response_item.dart
│   │           │   ├── tool_result_item.dart
│   │           │   └── chat_history_item.dart
│   │           └── client.dart           # Generated client
│   │
│   └── app_use_server_server/            # 🎯 Server Implementation
│       ├── bin/
│       │   └── main.dart                 # Server entry point
│       │
│       └── lib/
│           ├── server.dart               # Server configuration
│           │
│           └── src/
│               ├── endpoints/
│               │   └── chat_endpoint.dart # HTTP endpoint for chat
│               │
│               ├── services/
│               │   └── gemini_service.dart # Gemini API integration
│               │
│               └── generated/
│                   └── protocol/         # Protocol definitions
│                       ├── chat_request_data.dart
│                       ├── chat_response_data.dart
│                       └── ... (other protocol files)
│
└── pubspec.yaml                           # Flutter dependencies
```

## Key Components

### 1. **Flutter App Layer** (`lib/`)
- **ChatPage** (`lib/chat/view/chat_page.dart`): UI that displays messages and input
- **ChatCubit** (`lib/chat/cubit/chat_cubit.dart`): State management, orchestrates the entire flow
- **CounterToolExecutor** (`lib/chat/services/counter_tool_executor.dart`): Executes tools locally in the app
- **CounterCubit** (`lib/counter/cubit/counter_cubit.dart`): Manages counter state and history

### 2. **Network Layer** (`lib/chat/repositories/`)
- **ChatRepository** (`chat_repository.dart`): Abstract interface for chat operations
- **ChatRepositoryImpl** (`chat_repository_impl.dart`): Serverpod client wrapper for HTTP communication
- Uses generated Serverpod Client for type-safe communication

### 3. **Server Layer** (`app_use_server/app_use_server_server/`)
- **ChatEndpoint** (`lib/src/endpoints/chat_endpoint.dart`): Handles incoming HTTP requests, rate limiting, validation
- **GeminiService** (`lib/src/services/gemini_service.dart`): Interfaces with Gemini API, defines tool schemas

### 4. **Generated Client SDK** (`app_use_server/app_use_server_client/`)
- Automatically generated by Serverpod
- Provides type-safe models: `ChatRequestData`, `ChatResponseData`, `ToolResultItem`, etc.
- Ensures client and server use identical data structures

### 5. **AI Layer** (External)
- **Gemini 2.0 Flash API**: Processes natural language, decides which tools to call
- Receives tool definitions and current context
- Returns text responses and/or tool call instructions

## Data Flow Summary

### Request Flow (App → Server → AI)
```
User Input 
  → ChatCubit (adds context: counter value, history)
  → ChatRepository (Serverpod client)
  → ChatEndpoint (validates, rate limits)
  → GeminiService (adds tool definitions, system instruction)
  → Gemini API (processes with tools)
```

### Response Flow (AI → Server → App)
```
Gemini API Response (text + tool_calls)
  → GeminiService (streams responses)
  → ChatEndpoint (converts to ChatResponseData)
  → ChatRepository (returns to app)
  → ChatCubit (processes responses)
  → If tool_call: Execute locally → Send results back (loop)
  → If text: Display to user
```

## Tool Call Loop

The system supports **multi-turn tool calling**:

1. **Turn 1**: User sends message → AI responds with tool call
2. **Tool Execution**: App executes tool locally, gets result
3. **Turn 2**: App sends tool results back → AI processes results → AI responds with text or more tool calls
4. **Repeat**: Loop continues until AI provides final text response (no more tool calls)

This enables complex interactions like:
- "Increment 3 times then show history" (4 tool calls in sequence)
- "Set to 10 and tell me the current value" (2 tool calls)

## Key Features

### Local Tool Execution
- Tools run **in the Flutter app**, not on server
- Direct access to app state (CounterCubit)
- Instant feedback to user

### Type-Safe Communication
- Serverpod provides generated client/server types
- ChatRequestData, ChatResponseData, ToolResultItem
- Compile-time safety across network boundary

### Streaming Responses
- Server streams AI responses in real-time
- Supports typewriter effect in UI
- Tool calls streamed as separate chunks

### State Synchronization
- Current counter value sent with each request
- AI always has latest app state
- Tool results include state changes

## Tool Definitions (in GeminiService)

```dart
- increment_counter: Increases counter by 1
- decrement_counter: Decreases counter by 1
- reset_counter: Resets counter to 0
- set_counter_value(value: int): Sets counter to specific value
- get_counter_history: Retrieves operation history
```

These tools are defined in `GeminiService._getCounterTools()` and sent to Gemini API with each request.
