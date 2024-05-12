sealed class DSignUpResult {}

final class SuccessSignUpResult extends DSignUpResult {}

final class EmailAlreadyInUseSignUpResult extends DSignUpResult {}

final class WeakPasswordSignUpResult extends DSignUpResult {}

final class FailureSignUpResult extends DSignUpResult {}

final class InvalidEmailSignUpResult extends DSignUpResult {}
