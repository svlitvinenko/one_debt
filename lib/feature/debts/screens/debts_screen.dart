import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_debt/core/dependencies/dependencies.dart';
import 'package:one_debt/core/design/components/ds_app_bar.dart';
import 'package:one_debt/core/design/components/ds_debt_type_theme.dart';
import 'package:one_debt/core/design/components/ds_scaffold.dart';
import 'package:one_debt/core/localization/generated/app_localizations.dart';
import 'package:one_debt/core/model/d_debt_summary.dart';
import 'package:one_debt/core/model/e_debt_type.dart';
import 'package:one_debt/feature/debts/bloc/debts_bloc.dart';
import 'package:one_debt/feature/debts/widgets/debts_debt_tile.dart';
import 'package:one_debt/feature/home/screens/home_screen.dart';
import 'package:one_debt/routes/app_route.dart';
import 'package:one_debt/routes/routes.dart';
import 'package:staggered_grid_view_flutter/rendering/sliver_staggered_grid.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class DebtsScreen extends StatefulWidget {
  final EDebtType type;
  const DebtsScreen({
    super.key,
    required this.type,
  });

  @override
  State<DebtsScreen> createState() => _DebtsScreenState();
}

class _DebtsScreenState extends State<DebtsScreen> {
  late final ValueNotifier<bool> isLoadingController;
  late final ValueNotifier<List<DDebtSummary>?> summaryController;

  @override
  void initState() {
    isLoadingController = ValueNotifier(true);
    summaryController = ValueNotifier(null);
    super.initState();
  }

  @override
  void dispose() {
    isLoadingController.dispose();
    summaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    return BlocProvider(
      create: (context) => DebtsBloc(type: widget.type)..add(const DebtsEvent.initialize()),
      child: BlocConsumer<DebtsBloc, DebtsState>(
        listener: (context, state) {
          state.map(
            loading: (_) {
              isLoadingController.value = true;
            },
            idle: (state) {
              isLoadingController.value = state.isLoading;
            },
            setSummary: (state) {
              summaryController.value = state.summary;
            },
          );
        },
        builder: (context, state) {
          return DSDebtTypeTheme(
            type: widget.type,
            builder: (context) {
              return DSScaffold(
                appBar: DSAppBar(
                  title: Text(
                    switch (widget.type) {
                      EDebtType.incoming => localizations.incomingDebtsTitle,
                      EDebtType.outgoing => localizations.outgoingDebtsTitle,
                    },
                  ),
                ),
                body: (context, constraints, layout) {
                  return ValueListenableBuilder<List<DDebtSummary>?>(
                    valueListenable: summaryController,
                    builder: (context, summaries, _) {
                      if (summaries == null) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (summaries.isEmpty) {
                        return const Center(
                          child: Text('No debts'),
                        );
                      } else {
                        final int crossAxisCount = switch (layout) {
                          Layout.verticalSmall => 1,
                          _ => constraints.maxWidth ~/ 350,
                        };
                        return StaggeredGridView.builder(
                          key: ValueKey(crossAxisCount),
                          padding: const EdgeInsets.all(16),
                          itemCount: summaries.length,
                          gridDelegate: SliverStaggeredGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            staggeredTileCount: summaries.length,
                            staggeredTileBuilder: (index) {
                              return const StaggeredTile.extent(1, 90);
                            },
                          ),
                          itemBuilder: (context, index) {
                            final DDebtSummary summary = summaries[index];
                            return DebtsDebtTile(
                              summary: summary,
                              progressDelay: Duration(milliseconds: 200 * (index + 1)),
                              onPressed: () {
                                getDependency<Routes>().push(DebtRoute(type: widget.type, id: summary.debt.id));
                              },
                            );
                          },
                        );
                      }
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  double? fontSizeOf(TextStyle? style) => style?.fontSize;
}
