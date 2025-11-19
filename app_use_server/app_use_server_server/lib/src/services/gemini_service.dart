import 'dart:async';

import 'package:google_generative_ai/google_generative_ai.dart';

/// Service for interacting with Google Gemini API with function calling support
class GeminiService {
  final String apiKey;

  GeminiService({required this.apiKey});

  /// Define tool schemas for counter and navigation actions
  Tool _getCounterTools() {
    return Tool(functionDeclarations: [
      FunctionDeclaration(
          'increment_counter',
          'Increases the counter by 1',
          Schema(
            SchemaType.object,
            properties: {},
          )),
      FunctionDeclaration(
          'decrement_counter',
          'Decreases the counter by 1',
          Schema(
            SchemaType.object,
            properties: {},
          )),
      FunctionDeclaration(
          'reset_counter',
          'Resets the counter to 0',
          Schema(
            SchemaType.object,
            properties: {},
          )),
      FunctionDeclaration(
        'set_counter_value',
        'Sets the counter to a specific value',
        Schema(
          SchemaType.object,
          properties: {
            'value': Schema(
              SchemaType.integer,
              description: 'The value to set the counter to',
            ),
          },
          requiredProperties: ['value'],
        ),
      ),
      FunctionDeclaration(
        'get_counter_history',
        'Retrieves the full history of counter operations. Call this whenever the user asks to see history or past actions.',
        Schema(
          SchemaType.object,
          properties: {},
        ),
      ),
      FunctionDeclaration(
        'navigate_to_test_page',
        'Navigates the user to the test page in the app',
        Schema(
          SchemaType.object,
          properties: {},
        ),
      ),
    ]);
  }

  /// Stream chat responses with tool calling support
  Stream<ChatResponse> streamChat({
    required String message,
    required int currentCounterValue,
    List<Content>? history,
    List<FunctionResponse>? toolResults,
  }) async* {
    // Build system instruction with current counter value
    final systemInstruction = Content.system(
      'You are a helpful assistant that can control a counter and navigate in a Flutter app. '
      'The counter uses 0-based counting, where 0 is the initial value. '
      'The current counter value is exactly $currentCounterValue. '
      'When you call a counter function, the tool response will include "New value: X". '
      'ALWAYS use the exact value from the tool response when reporting the counter value - do not calculate it yourself. '
      'You can also navigate users to the test page when they ask to go there or see it. '
      'Use the available functions to help users manipulate the counter and navigate the app. '
      'If the user asks for information that can be retrieved using a tool (like history), '
      'call the tool immediately without asking for permission. '
      'Be conversational and friendly.',
    );

    // Create a new model instance with system instruction
    final model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
      tools: [_getCounterTools()],
      systemInstruction: systemInstruction,
    );

    // Build conversation history
    final conversationHistory = <Content>[
      if (history != null) ...history,
    ];

    // If we have tool results, add them to the conversation
    if (toolResults != null && toolResults.isNotEmpty) {
      conversationHistory.add(Content.functionResponses(toolResults));
    }

    // Add the user's message
    conversationHistory.add(Content.text(message));

    // Generate streaming response
    final response = model.generateContentStream(conversationHistory);

    await for (final chunk in response) {
      // Check if this chunk contains function calls
      if (chunk.functionCalls.isNotEmpty) {
        for (final functionCall in chunk.functionCalls) {
          yield ChatResponse.toolCall(
            toolName: functionCall.name,
            args: functionCall.args,
            callId: functionCall.name, // Using name as ID for simplicity
          );
        }
      }

      // Check if this chunk contains text
      if (chunk.text != null && chunk.text!.isNotEmpty) {
        yield ChatResponse.text(chunk.text!);
      }
    }
  }
}

/// Response types for chat streaming
class ChatResponse {
  final String type;
  final String? content;
  final String? toolName;
  final Map<String, dynamic>? args;
  final String? callId;

  ChatResponse._({
    required this.type,
    this.content,
    this.toolName,
    this.args,
    this.callId,
  });

  factory ChatResponse.text(String text) {
    return ChatResponse._(
      type: 'text',
      content: text,
    );
  }

  factory ChatResponse.toolCall({
    required String toolName,
    required Map<String, dynamic> args,
    required String callId,
  }) {
    return ChatResponse._(
      type: 'tool_call',
      toolName: toolName,
      args: args,
      callId: callId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      if (content != null) 'content': content,
      if (toolName != null) 'toolName': toolName,
      if (args != null) 'args': args,
      if (callId != null) 'callId': callId,
    };
  }
}
