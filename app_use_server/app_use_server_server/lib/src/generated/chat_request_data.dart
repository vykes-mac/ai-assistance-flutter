/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'chat_history_item.dart' as _i2;
import 'tool_result_item.dart' as _i3;

abstract class ChatRequestData
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ChatRequestData._({
    required this.message,
    required this.currentCounterValue,
    this.history,
    this.toolResults,
  });

  factory ChatRequestData({
    required String message,
    required int currentCounterValue,
    List<_i2.ChatHistoryItem>? history,
    List<_i3.ToolResultItem>? toolResults,
  }) = _ChatRequestDataImpl;

  factory ChatRequestData.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChatRequestData(
      message: jsonSerialization['message'] as String,
      currentCounterValue: jsonSerialization['currentCounterValue'] as int,
      history: (jsonSerialization['history'] as List?)
          ?.map(
              (e) => _i2.ChatHistoryItem.fromJson((e as Map<String, dynamic>)))
          .toList(),
      toolResults: (jsonSerialization['toolResults'] as List?)
          ?.map((e) => _i3.ToolResultItem.fromJson((e as Map<String, dynamic>)))
          .toList(),
    );
  }

  String message;

  int currentCounterValue;

  List<_i2.ChatHistoryItem>? history;

  List<_i3.ToolResultItem>? toolResults;

  /// Returns a shallow copy of this [ChatRequestData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ChatRequestData copyWith({
    String? message,
    int? currentCounterValue,
    List<_i2.ChatHistoryItem>? history,
    List<_i3.ToolResultItem>? toolResults,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'currentCounterValue': currentCounterValue,
      if (history != null)
        'history': history?.toJson(valueToJson: (v) => v.toJson()),
      if (toolResults != null)
        'toolResults': toolResults?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'message': message,
      'currentCounterValue': currentCounterValue,
      if (history != null)
        'history': history?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (toolResults != null)
        'toolResults':
            toolResults?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChatRequestDataImpl extends ChatRequestData {
  _ChatRequestDataImpl({
    required String message,
    required int currentCounterValue,
    List<_i2.ChatHistoryItem>? history,
    List<_i3.ToolResultItem>? toolResults,
  }) : super._(
          message: message,
          currentCounterValue: currentCounterValue,
          history: history,
          toolResults: toolResults,
        );

  /// Returns a shallow copy of this [ChatRequestData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ChatRequestData copyWith({
    String? message,
    int? currentCounterValue,
    Object? history = _Undefined,
    Object? toolResults = _Undefined,
  }) {
    return ChatRequestData(
      message: message ?? this.message,
      currentCounterValue: currentCounterValue ?? this.currentCounterValue,
      history: history is List<_i2.ChatHistoryItem>?
          ? history
          : this.history?.map((e0) => e0.copyWith()).toList(),
      toolResults: toolResults is List<_i3.ToolResultItem>?
          ? toolResults
          : this.toolResults?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
