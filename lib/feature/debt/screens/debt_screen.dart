import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_debt/core/design/components/ds_app_bar.dart';
import 'package:one_debt/core/design/components/ds_debt_type_theme.dart';
import 'package:one_debt/core/design/components/ds_scaffold.dart';
import 'package:one_debt/core/design/theme/theme.dart';
import 'package:one_debt/core/model/d_debt_summary.dart';
import 'package:one_debt/core/model/e_debt_type.dart';
import 'package:one_debt/feature/debt/bloc/debt_bloc.dart';
import 'package:one_debt/feature/debt/widgets/debt_loaded_content.dart';
import 'package:one_debt/feature/debt/widgets/debt_loading_content.dart';

class DebtScreen extends StatefulWidget {
  final EDebtType type;
  final String id;
  const DebtScreen({
    super.key,
    required this.type,
    required this.id,
  });

  @override
  State<DebtScreen> createState() => _DebtScreenState();
}

class _DebtScreenState extends State<DebtScreen> {
  late final ValueNotifier<DDebtSummary?> debtController;
  late final ValueNotifier<bool> isLoadingController;

  @override
  void initState() {
    isLoadingController = ValueNotifier(true);
    debtController = ValueNotifier(null);
    super.initState();
  }

  @override
  void dispose() {
    isLoadingController.dispose();
    debtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DebtBloc(id: widget.id, type: widget.type)..add(const DebtEvent.initialized()),
      child: BlocListener<DebtBloc, DebtState>(
        listener: (context, state) {
          state.map(
            loading: (state) {
              isLoadingController.value = true;
              debtController.value = null;
            },
            idle: (state) {
              isLoadingController.value = state.isLoading;
            },
            setDebtSummary: (state) {
              debtController.value = state.debt;
            },
          );
        },
        child: ValueListenableBuilder<bool>(
          valueListenable: isLoadingController,
          builder: (context, isLoading, _) {
            return DSDebtTypeTheme(
              type: widget.type,
              builder: (_) {
                return DSScaffold(
                  appBar: const DSAppBar(),
                  body: (_, __, ___) {
                    return ValueListenableBuilder<DDebtSummary?>(
                      valueListenable: debtController,
                      builder: (context, summary, _) {
                        return AnimatedSwitcher(
                          duration: context.times.fast,
                          child: summary != null
                              ? DebtLoadedContent(
                                  key: const ValueKey('loaded'),
                                  debt: summary,
                                  isLoadingController: isLoadingController,
                                )
                              : const DebtLoadingContent(
                                  key: ValueKey('loading'),
                                ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
