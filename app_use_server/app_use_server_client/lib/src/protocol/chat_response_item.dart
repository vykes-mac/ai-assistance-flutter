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

abstract class ChatResponseItem implements _i1.SerializableModel {
  ChatResponseItem._({
    required this.type,
    this.content,
    this.toolName,
    this.args,
    this.callId,
  });

  factory ChatResponseItem({
    required String type,
    String? content,
    String? toolName,
    String? args,
    String? callId,
  }) = _ChatResponseItemImpl;

  factory ChatResponseItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChatResponseItem(
      type: jsonSerialization['type'] as String,
      content: jsonSerialization['content'] as String?,
      toolName: jsonSerialization['toolName'] as String?,
      args: jsonSerialization['args'] as String?,
      callId: jsonSerialization['callId'] as String?,
    );
  }

  String type;

  String? content;

  String? toolName;

  String? args;

  String? callId;

  /// Returns a shallow copy of this [ChatResponseItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ChatResponseItem copyWith({
    String? type,
    String? content,
    String? toolName,
    String? args,
    String? callId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      if (content != null) 'content': content,
      if (toolName != null) 'toolName': toolName,
      if (args != null) 'args': args,
      if (callId != null) 'callId': callId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChatResponseItemImpl extends ChatResponseItem {
  _ChatResponseItemImpl({
    required String type,
    String? content,
    String? toolName,
    String? args,
    String? callId,
  }) : super._(
          type: type,
          content: content,
          toolName: toolName,
          args: args,
          callId: callId,
        );

  /// Returns a shallow copy of this [ChatResponseItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ChatResponseItem copyWith({
    String? type,
    Object? content = _Undefined,
    Object? toolName = _Undefined,
    Object? args = _Undefined,
    Object? callId = _Undefined,
  }) {
    return ChatResponseItem(
      type: type ?? this.type,
      content: content is String? ? content : this.content,
      toolName: toolName is String? ? toolName : this.toolName,
      args: args is String? ? args : this.args,
      callId: callId is String? ? callId : this.callId,
    );
  }
}
