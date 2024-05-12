// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'd_contact.freezed.dart';
part 'd_contact.g.dart';

@freezed
class DContact with _$DContact {
  @JsonSerializable()
  const factory DContact({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'avatar_url') required String? avatarUrl,
  }) = _DContact;

  factory DContact.fromJson(Map<String, dynamic> json) => _$DContactFromJson(json);
}
