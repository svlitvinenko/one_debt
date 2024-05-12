import 'package:freezed_annotation/freezed_annotation.dart';

part 'd_money.freezed.dart';

@freezed
class DMoney with _$DMoney {
  const factory DMoney({required int cents, required String isoCode}) = _DMoney;
  const DMoney._();

  @override
  String toString() {
    return '${(cents / 100).toStringAsFixed(2)} $isoCode';
  }
}
