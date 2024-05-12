import 'package:freezed_annotation/freezed_annotation.dart';

part 'd_contact.freezed.dart';

@freezed
class DContact with _$DContact {
  const factory DContact({
    required String id,
    required String name,
    required String avatarUrl,
  }) = _DContact;
}
