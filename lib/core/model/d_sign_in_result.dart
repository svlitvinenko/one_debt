sealed class DSignInResult {}

final class SuccessSignInResult extends DSignInResult {}

final class FailureSignInResult extends DSignInResult {}

final class InvalidEmailSignInResult extends DSignInResult {}

final class WrongCredentialsSignInResult extends DSignInResult {}
