import 'package:app_use_server_client/app_use_server_client.dart';

/// Abstract interface for chat operations
abstract class ChatRepository {
  /// Send a chat request to the server
  Future<ChatResponseData> sendMessage(ChatRequestData request);

  /// Close the repository and clean up resources
  void dispose();
}
