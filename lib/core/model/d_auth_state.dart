import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_debt/core/model/d_user.dart';

part 'd_auth_state.freezed.dart';

@freezed
class DAuthState with _$DAuthState {
  const factory DAuthState.unauthorized() = Unauthorized;
  const factory DAuthState.authorized({required DUser user}) = Authorized;
}
