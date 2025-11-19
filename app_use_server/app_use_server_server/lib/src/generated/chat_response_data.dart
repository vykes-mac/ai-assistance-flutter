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
import 'chat_response_item.dart' as _i2;

abstract class ChatResponseData
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ChatResponseData._({required this.responses});

  factory ChatResponseData({required List<_i2.ChatResponseItem> responses}) =
      _ChatResponseDataImpl;

  factory ChatResponseData.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChatResponseData(
        responses: (jsonSerialization['responses'] as List)
            .map((e) =>
                _i2.ChatResponseItem.fromJson((e as Map<String, dynamic>)))
            .toList());
  }

  List<_i2.ChatResponseItem> responses;

  /// Returns a shallow copy of this [ChatResponseData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ChatResponseData copyWith({List<_i2.ChatResponseItem>? responses});
  @override
  Map<String, dynamic> toJson() {
    return {'responses': responses.toJson(valueToJson: (v) => v.toJson())};
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'responses': responses.toJson(valueToJson: (v) => v.toJsonForProtocol())
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ChatResponseDataImpl extends ChatResponseData {
  _ChatResponseDataImpl({required List<_i2.ChatResponseItem> responses})
      : super._(responses: responses);

  /// Returns a shallow copy of this [ChatResponseData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ChatResponseData copyWith({List<_i2.ChatResponseItem>? responses}) {
    return ChatResponseData(
        responses:
            responses ?? this.responses.map((e0) => e0.copyWith()).toList());
  }
}
