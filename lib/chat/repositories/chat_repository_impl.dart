import 'package:app_use_server_client/app_use_server_client.dart';

import 'chat_repository.dart';

/// Implementation of ChatRepository using Serverpod client
class ChatRepositoryImpl implements ChatRepository {
  final Client _client;

  ChatRepositoryImpl({
    required String serverUrl,
  }) : _client = Client(serverUrl);

  @override
  Future<ChatResponseData> sendMessage(ChatRequestData request) async {
    try {
      return await _client.chat.chat(request);
    } catch (e) {
      rethrow;
    }
  }

  @override
  void dispose() {
    _client.close();
  }
}
