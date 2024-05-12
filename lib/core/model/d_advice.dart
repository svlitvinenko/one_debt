import 'package:one_debt/core/model/d_contact_summary.dart';
import 'package:one_debt/core/model/d_debt_summary.dart';

sealed class DAdvice {}

sealed class DDebtAdvice extends DAdvice {
  final DDebtSummary debt;
  DDebtAdvice({required this.debt});
}

sealed class DContactAdvice extends DAdvice {
  final DContactSummary contact;
  DContactAdvice({required this.contact});
}

final class ReturnSoonDebtAdvice extends DDebtAdvice {
  ReturnSoonDebtAdvice({required super.debt});
}

final class OverdueDebtAdvice extends DDebtAdvice {

  OverdueDebtAdvice({required super.debt});
}

final class NotTrustedContactAdvice extends DContactAdvice {
  NotTrustedContactAdvice({required super.contact});
}

final class NotFilledContactAdvice extends DContactAdvice {
  NotFilledContactAdvice({required super.contact});
}
