# AI Counter Assistant

A Flutter application with an AI-powered chat assistant that can control a counter through natural language commands. The app uses Google Gemini for AI capabilities and Serverpod as the backend.

## Features

- **Natural Language Control**: Ask the AI to increment, decrement, reset, or set the counter to specific values
- **Function Calling**: AI assistant executes counter actions locally through tool calls
- **Chat Interface**: Beautiful chat UI with typewriter effect for AI responses
- **Real-time Updates**: Counter updates immediately when AI performs actions
- **Tool Execution Feedback**: Visual feedback when tools are being executed
- **Rate Limiting**: Built-in rate limiting and validation on the server

## Architecture

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│   Flutter   │────▶│  Serverpod   │────▶│   Gemini    │
│     App     │◀────│   Backend    │◀────│     API     │
└─────────────┘     └──────────────┘     └─────────────┘
       │
       ▼
  Tool Handler
  (Local Actions)
```

1. User sends message via Flutter app
2. App forwards to Serverpod backend
3. Backend calls Gemini API with tool schemas
4. Gemini returns response with tool calls
5. Flutter executes tools locally and sends results back
6. Backend continues conversation with tool results
7. Final response displayed with typewriter effect

## Setup Instructions

### Prerequisites

- Flutter SDK (3.10.0 or higher)
- Dart SDK (3.5.0 or higher)
- Google Gemini API key ([Get one here](https://makersuite.google.com/app/apikey))

### 1. Install Dependencies

```bash
# Install Serverpod CLI
dart pub global activate serverpod_cli

# Get Flutter dependencies
cd /path/to/app_use
flutter pub get

# Get Server dependencies
cd app_use_server/app_use_server_server
dart pub get
```

### 2. Configure Gemini API Key

Set your Gemini API key as an environment variable:

**macOS/Linux:**

```bash
export GEMINI_API_KEY="your-api-key-here"
```

**Windows (PowerShell):**

```powershell
$env:GEMINI_API_KEY="your-api-key-here"
```

**Or add to your shell profile (~/.zshrc or ~/.bashrc):**

```bash
echo 'export GEMINI_API_KEY="your-api-key-here"' >> ~/.zshrc
source ~/.zshrc
```

### 3. Start the Serverpod Server

```bash
cd app_use_server/app_use_server_server
dart bin/main.dart
```

The server will start on `http://localhost:8080`

### 4. Run the Flutter App

In a new terminal:

```bash
cd /path/to/app_use
flutter run
```

## Usage

1. **Launch the app**: The main screen shows a counter with a button to increment it
2. **Open AI Chat**: Click the chat icon in the app bar or the "Ask AI to Control Counter" button
3. **Chat with AI**: Try commands like:
   - "Increment the counter"
   - "Decrease it by 1"
   - "Reset the counter to zero"
   - "Set the counter to 42"
   - "Show me the counter history"
4. **Watch it work**: The AI will execute actions and the counter updates in real-time

## Available Tools

The AI assistant has access to these counter operations:

- `increment_counter`: Increases the counter by 1
- `decrement_counter`: Decreases the counter by 1
- `reset_counter`: Resets the counter to 0
- `set_counter_value`: Sets the counter to a specific value
- `get_counter_history`: Retrieves the history of counter operations

## Project Structure

```
app_use/
```

lib/
├── main.dart
├── app.dart
├── core/
│ ├── constants/
│ ├── theme/
│ └── utils/
├── counter/
│ ├── cubit/
│ │ ├── counter_cubit.dart
│ │ └── counter_state.dart
│ ├── models/
│ │ └── counter_operation.dart
│ ├── widgets/
│ │ ├── counter_display.dart
│ │ └── counter_actions.dart
│ └── view/
│ └── counter_page.dart
└── chat/
├── cubit/
│ ├── chat_cubit.dart
│ └── chat_state.dart
├── models/
│ ├── chat_message_model.dart
│ └── tool_execution_result.dart
├── repositories/
│ ├── chat_repository.dart
│ └── chat_repository_impl.dart
├── services/
│ ├── tool_executor.dart
│ └── counter_tool_executor.dart
├── widgets/
│ ├── chat_message_list.dart
│ ├── chat_input.dart
│ └── tool_execution_indicator.dart
└── view/
└── chat_page.dart
├── app_use_server/
│ ├── app_use_server_client/ # Generated client SDK
│ └── app_use_server_server/ # Backend server
│ ├── lib/
│ │ └── src/
│ │ ├── endpoints/
│ │ │ └── chat_endpoint.dart # Chat API endpoint
│ │ ├── services/
│ │ │ └── gemini_service.dart # Gemini integration
│ │ └── protocol/ # Data models (YAML)
│ └── bin/
│ └── main.dart # Server entry point

````

## Troubleshooting

### Server won't start
- Ensure GEMINI_API_KEY is set: `echo $GEMINI_API_KEY`
- Check if port 8080 is available
- Check server logs for errors

### App can't connect to server
- Verify server is running on `http://localhost:8080`
- Check `lib/screens/chat_screen.dart` has correct server URL
- For iOS simulator, use `http://localhost:8080`
- For Android emulator, use `http://10.0.2.2:8080`

### AI not responding
- Verify Gemini API key is valid
- Check server logs for API errors
- Ensure you have internet connection

### Counter not updating
- Check that ToolHandler is properly initialized in main.dart
- Verify tool execution feedback appears in chat
- Check Flutter console for errors

## Rate Limiting

The server implements rate limiting:
- Maximum 20 requests per minute per client
- Automatic cleanup of inactive rate limiters
- Error message returned when limit exceeded

## Extending the App

### Adding New Tools

1. **Define tool schema in `gemini_service.dart`**:
```dart
FunctionDeclaration(
  name: 'your_tool_name',
  description: 'What your tool does',
  parameters: Schema(
    SchemaType.object,
    properties: {
      'param': Schema(SchemaType.string, description: 'Parameter description'),
    },
  ),
),
````

2. **Implement tool in `tool_handler.dart`**:

```dart
case 'your_tool_name':
  return _yourToolImplementation(args);
```

3. **Test**: Ask the AI to use your new tool!

## Technologies Used

- **Flutter**: Cross-platform UI framework
- **Serverpod**: Dart backend framework
- **Google Gemini**: AI model with function calling
- **DashChat2**: Chat UI components

## License

This project is part of a Flutter tutorial series.

## Support

For issues or questions:

1. Check the troubleshooting section above
2. Review Serverpod docs: https://docs.serverpod.dev
3. Review Gemini docs: https://ai.google.dev/docs

---

**Note**: This is a demonstration app showing AI function calling patterns. For production use, consider:

- Adding authentication
- Implementing persistent storage
- Adding more comprehensive error handling
- Setting up proper environment configuration
- Adding tests
