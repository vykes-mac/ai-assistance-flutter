import 'dart:async';
import 'dart:io';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/gemini_service.dart';

/// Endpoint for handling chat interactions with AI
class ChatEndpoint extends Endpoint {
  static GeminiService? _geminiService;
  static final Map<String, RateLimiter> _rateLimiters = {};

  GeminiService _getGeminiService() {
    if (_geminiService == null) {
      final apiKey = Platform.environment['GEMINI_API_KEY'];

      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('GEMINI_API_KEY environment variable not set');
      }

      _geminiService = GeminiService(apiKey: apiKey);
    }
    return _geminiService!;
  }

  /// Send a chat message and get response with potential tool calls
  Future<ChatResponseData> chat(
    Session session,
    ChatRequestData request,
  ) async {
    // Rate limiting check
    final clientId = session.sessionId.toString();
    final rateLimiter = _getRateLimiter(clientId);

    if (!rateLimiter.allowRequest()) {
      throw Exception(
          'Rate limit exceeded. Please wait before sending another message.');
    }

    // Validate message (allow empty if tool results are present)
    if (request.message.trim().isEmpty &&
        (request.toolResults == null || request.toolResults!.isEmpty)) {
      throw Exception('Message cannot be empty');
    }

    if (request.message.length > 5000) {
      throw Exception('Message too long (max 5000 characters)');
    }

    // Log the request
    session.log(
        'Chat request: ${request.message} (counter: ${request.currentCounterValue})');

    // Convert history to Content objects
    List<Content>? contentHistory;
    if (request.history != null && request.history!.isNotEmpty) {
      contentHistory = _convertHistoryToContent(request.history!);
    }

    // Convert tool results to FunctionResponse objects
    List<FunctionResponse>? functionResponses;
    if (request.toolResults != null && request.toolResults!.isNotEmpty) {
      functionResponses =
          _convertToolResultsToFunctionResponses(request.toolResults!);
    }

    // Collect responses from stream
    final responses = <ChatResponseItem>[];
    final geminiService = _getGeminiService();

    try {
      await for (final response in geminiService.streamChat(
        message: request.message,
        currentCounterValue: request.currentCounterValue,
        history: contentHistory,
        toolResults: functionResponses,
      )) {
        // Log tool calls
        if (response.type == 'tool_call') {
          session.log('Tool call: ${response.toolName}');
        } else if (response.type == 'text') {
          // Log text preview (first 50 chars)
          final textPreview =
              response.content != null && response.content!.length > 50
                  ? '${response.content!.substring(0, 50)}...'
                  : response.content;
          session.log('AI Response: $textPreview');
        }

        // Convert to ChatResponseItem
        responses.add(ChatResponseItem(
          type: response.type,
          content: response.content,
          toolName: response.toolName,
          args: response.args != null ? _encodeArgs(response.args!) : null,
          callId: response.callId,
        ));
      }
    } catch (e) {
      session.log('Error in chat: $e', level: LogLevel.error);
      throw Exception('Failed to generate response: $e');
    }

    return ChatResponseData(responses: responses);
  }

  /// Encode args map to JSON string
  String _encodeArgs(Map<String, dynamic> args) {
    return args.entries.map((e) => '${e.key}:${e.value}').join(',');
  }

  /// Convert history items to Content objects
  List<Content> _convertHistoryToContent(List<ChatHistoryItem> history) {
    return history.map((item) {
      if (item.role == 'user') {
        return Content.text(item.text);
      } else {
        return Content.model([TextPart(item.text)]);
      }
    }).toList();
  }

  /// Convert tool results to FunctionResponse objects
  List<FunctionResponse> _convertToolResultsToFunctionResponses(
    List<ToolResultItem> toolResults,
  ) {
    return toolResults.map((result) {
      // Parse JSON string response back to Map
      final responseMap = <String, dynamic>{'result': result.response};
      return FunctionResponse(result.name, responseMap);
    }).toList();
  }

  /// Get or create rate limiter for a client
  RateLimiter _getRateLimiter(String clientId) {
    if (!_rateLimiters.containsKey(clientId)) {
      _rateLimiters[clientId] = RateLimiter(
        maxRequests: 20,
        windowDuration: Duration(minutes: 1),
      );
    }

    // Clean up old rate limiters periodically
    if (_rateLimiters.length > 1000) {
      _cleanupRateLimiters();
    }

    return _rateLimiters[clientId]!;
  }

  /// Remove inactive rate limiters
  void _cleanupRateLimiters() {
    final now = DateTime.now();
    _rateLimiters.removeWhere((key, limiter) {
      return now.difference(limiter.lastRequestTime) > Duration(hours: 1);
    });
  }
}

/// Simple rate limiter implementation
class RateLimiter {
  final int maxRequests;
  final Duration windowDuration;
  final List<DateTime> _requestTimes = [];
  DateTime lastRequestTime = DateTime.now();

  RateLimiter({
    required this.maxRequests,
    required this.windowDuration,
  });

  bool allowRequest() {
    final now = DateTime.now();
    lastRequestTime = now;

    // Remove old requests outside the window
    _requestTimes.removeWhere((time) {
      return now.difference(time) > windowDuration;
    });

    // Check if we're under the limit
    if (_requestTimes.length < maxRequests) {
      _requestTimes.add(now);
      return true;
    }

    return false;
  }
}
