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

abstract class ToolResultItem
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ToolResultItem._({
    required this.name,
    required this.response,
  });

  factory ToolResultItem({
    required String name,
    required String response,
  }) = _ToolResultItemImpl;

  factory ToolResultItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return ToolResultItem(
      name: jsonSerialization['name'] as String,
      response: jsonSerialization['response'] as String,
    );
  }

  String name;

  String response;

  /// Returns a shallow copy of this [ToolResultItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ToolResultItem copyWith({
    String? name,
    String? response,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'response': response,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'name': name,
      'response': response,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ToolResultItemImpl extends ToolResultItem {
  _ToolResultItemImpl({
    required String name,
    required String response,
  }) : super._(
          name: name,
          response: response,
        );

  /// Returns a shallow copy of this [ToolResultItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ToolResultItem copyWith({
    String? name,
    String? response,
  }) {
    return ToolResultItem(
      name: name ?? this.name,
      response: response ?? this.response,
    );
  }
}
