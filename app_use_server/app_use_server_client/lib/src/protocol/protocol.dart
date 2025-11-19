/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'greeting.dart' as _i2;
import 'chat_history_item.dart' as _i3;
import 'chat_request_data.dart' as _i4;
import 'chat_response_data.dart' as _i5;
import 'chat_response_item.dart' as _i6;
import 'tool_result_item.dart' as _i7;
export 'greeting.dart';
export 'chat_history_item.dart';
export 'chat_request_data.dart';
export 'chat_response_data.dart';
export 'chat_response_item.dart';
export 'tool_result_item.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i2.Greeting) {
      return _i2.Greeting.fromJson(data) as T;
    }
    if (t == _i3.ChatHistoryItem) {
      return _i3.ChatHistoryItem.fromJson(data) as T;
    }
    if (t == _i4.ChatRequestData) {
      return _i4.ChatRequestData.fromJson(data) as T;
    }
    if (t == _i5.ChatResponseData) {
      return _i5.ChatResponseData.fromJson(data) as T;
    }
    if (t == _i6.ChatResponseItem) {
      return _i6.ChatResponseItem.fromJson(data) as T;
    }
    if (t == _i7.ToolResultItem) {
      return _i7.ToolResultItem.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Greeting?>()) {
      return (data != null ? _i2.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.ChatHistoryItem?>()) {
      return (data != null ? _i3.ChatHistoryItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.ChatRequestData?>()) {
      return (data != null ? _i4.ChatRequestData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.ChatResponseData?>()) {
      return (data != null ? _i5.ChatResponseData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.ChatResponseItem?>()) {
      return (data != null ? _i6.ChatResponseItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.ToolResultItem?>()) {
      return (data != null ? _i7.ToolResultItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<List<_i3.ChatHistoryItem>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i3.ChatHistoryItem>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i7.ToolResultItem>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i7.ToolResultItem>(e))
              .toList()
          : null) as T;
    }
    if (t == List<_i6.ChatResponseItem>) {
      return (data as List)
          .map((e) => deserialize<_i6.ChatResponseItem>(e))
          .toList() as T;
    }
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i2.Greeting) {
      return 'Greeting';
    }
    if (data is _i3.ChatHistoryItem) {
      return 'ChatHistoryItem';
    }
    if (data is _i4.ChatRequestData) {
      return 'ChatRequestData';
    }
    if (data is _i5.ChatResponseData) {
      return 'ChatResponseData';
    }
    if (data is _i6.ChatResponseItem) {
      return 'ChatResponseItem';
    }
    if (data is _i7.ToolResultItem) {
      return 'ToolResultItem';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i2.Greeting>(data['data']);
    }
    if (dataClassName == 'ChatHistoryItem') {
      return deserialize<_i3.ChatHistoryItem>(data['data']);
    }
    if (dataClassName == 'ChatRequestData') {
      return deserialize<_i4.ChatRequestData>(data['data']);
    }
    if (dataClassName == 'ChatResponseData') {
      return deserialize<_i5.ChatResponseData>(data['data']);
    }
    if (dataClassName == 'ChatResponseItem') {
      return deserialize<_i6.ChatResponseItem>(data['data']);
    }
    if (dataClassName == 'ToolResultItem') {
      return deserialize<_i7.ToolResultItem>(data['data']);
    }
    return super.deserializeByClassName(data);
  }
}
