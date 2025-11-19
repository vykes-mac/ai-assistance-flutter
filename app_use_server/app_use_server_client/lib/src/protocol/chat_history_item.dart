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

abstract class ChatHistoryItem implements _i1.SerializableModel {
  ChatHistoryItem._({
    required this.role,
    required this.text,
  });

  factory ChatHistoryItem({
    required String role,
    required String text,
  }) = _ChatHistoryItemImpl;

  factory ChatHistoryItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChatHistoryItem(
      role: jsonSerialization['role'] as String,
      text: jsonSerialization['text'] as String,
    );
  }

  String role;

  String text;

  /// Returns a shallow copy of this [ChatHistoryItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ChatHistoryItem copyWith({
    String? role,
    String? text,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'text': text,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ChatHistoryItemImpl extends ChatHistoryItem {
  _ChatHistoryItemImpl({
    required String role,
    required String text,
  }) : super._(
          role: role,
          text: text,
        );

  /// Returns a shallow copy of this [ChatHistoryItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ChatHistoryItem copyWith({
    String? role,
    String? text,
  }) {
    return ChatHistoryItem(
      role: role ?? this.role,
      text: text ?? this.text,
    );
  }
}
