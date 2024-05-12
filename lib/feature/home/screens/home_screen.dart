import 'dart:math';

import 'package:flutter/material.dart';
import 'package:one_debt/core/dependencies/dependencies.dart';
import 'package:one_debt/core/design/components/ds_app_bar.dart';
import 'package:one_debt/core/design/components/ds_scaffold.dart';
import 'package:one_debt/core/design/theme/theme.dart';
import 'package:one_debt/core/interactor/auth.dart';
import 'package:one_debt/core/model/d_auth_state.dart';
import 'package:one_debt/core/model/d_user.dart';
import 'package:one_debt/core/model/e_debt_type.dart';
import 'package:one_debt/feature/home/model/ui/home_tip_model.dart';
import 'package:one_debt/feature/home/section/contacts/widgets/home_contacts_section.dart';
import 'package:one_debt/feature/home/section/home_debts_section.dart';
import 'package:one_debt/feature/home/section/home_summary_section.dart';
import 'package:one_debt/feature/home/section/home_tip_section.dart';
import 'package:one_debt/routes/app_route.dart';
import 'package:one_debt/routes/routes.dart';
import 'package:staggered_grid_view_flutter/rendering/sliver_staggered_grid.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DAuthState?>(
        valueListenable: getDependency<Auth>(),
        builder: (context, bootstrapState, _) {
          if (!getDependency<Auth>().isSignedIn) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              final bool isCompact = constraints.maxWidth < 600;
              return DSScaffold(
                appBar: DSAppBar(
                  title: ValueListenableBuilder<DAuthState?>(
                      valueListenable: getDependency<Auth>().model,
                      builder: (context, state, _) {
                        final DUser? user = state?.mapOrNull(
                          authorized: (value) => value.user,
                        );
                        if (user == null) return const SizedBox.shrink();
                        return Column(
                          children: [
                            Text(
                              'Welcome, ${user.name}!',
                              style: context.textTheme.headlineSmall,
                            ),
                            Text(
                              'Remind Sergei about upcoming debt',
                              style: context.textTheme.titleSmall,
                            ),
                          ],
                        );
                      }),
                  leadingWidth: isCompact ? 56 : 192,
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: isCompact
                        ? IconButton(
                            onPressed: () {
                              routes.push(const ProfileRoute());
                            },
                            icon: Icon(
                              Icons.person_outline_sharp,
                              color: context.colorScheme.onBackground,
                            ),
                          )
                        : Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  routes.push(const ProfileRoute());
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.person_outline_sharp,
                                      color: context.colorScheme.onBackground,
                                    ),
                                    const SizedBox(width: 16),
                                    const Text('Profile'),
                                  ],
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                  ),
                  actions: [
                    if (isCompact) ...[
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.currency_exchange_sharp,
                          color: context.colorScheme.onBackground,
                        ),
                      ),
                    ] else ...[
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('Rates'),
                              const SizedBox(width: 16),
                              Icon(
                                Icons.currency_exchange_sharp,
                                color: context.colorScheme.onBackground,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(width: 16),
                  ],
                ),
                body: (context, constraints, Layout layout) {
                  final int crossAxisCount = layout.isLarge ? 4 : 2;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: crossAxisCount == 4 ? Alignment.center : Alignment.topCenter,
                          child: StaggeredGridView.builder(
                            shrinkWrap: true,
                            key: ValueKey(crossAxisCount),
                            padding: const EdgeInsets.all(16),
                            gridDelegate: SliverStaggeredGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              staggeredTileCount: 5,
                              staggeredTileBuilder: (index) {
                                if (crossAxisCount == 4) {
                                  return switch (index) {
                                    0 => const StaggeredTile.count(2, 2),
                                    1 => const StaggeredTile.count(1, 1),
                                    2 => const StaggeredTile.count(1, 2),
                                    3 => const StaggeredTile.count(1, 1),
                                    4 => const StaggeredTile.extent(4, 72),
                                    _ => throw Exception(),
                                  };
                                } else {
                                  return switch (index) {
                                    0 => const StaggeredTile.extent(2, 200),
                                    1 => const StaggeredTile.extent(1, 100),
                                    2 => const StaggeredTile.extent(1, 208),
                                    3 => const StaggeredTile.extent(1, 100),
                                    4 => const StaggeredTile.extent(2, 72),
                                    _ => throw Exception(),
                                  };
                                }
                              },
                            ),
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return switch (index) {
                                0 => const HomeSummarySection(),
                                1 => HomeDebtsSection(
                                    type: EDebtType.incoming,
                                    onTap: () {
                                      getDependency<Routes>().push(const DebtsRoute(type: EDebtType.incoming));
                                    },
                                  ),
                                2 => HomeContactsSection(
                                    onTap: () {
                                      getDependency<Routes>().push(const ContactsRoute());
                                    },
                                  ),
                                3 => HomeDebtsSection(
                                    type: EDebtType.outgoing,
                                    onTap: () {
                                      getDependency<Routes>().push(const DebtsRoute(type: EDebtType.outgoing));
                                    },
                                  ),
                                _ => const HomeTipSection(
                                    key: ValueKey('tips'),
                                    tips: [
                                      HomeTipModel(
                                        title: 'Tip Title 1',
                                        description: 'Tip Description 1',
                                        type: HomeTipType.incoming,
                                      ),
                                      HomeTipModel(
                                        title: 'Tip Title 2',
                                        description: 'Tip Description 2',
                                        type: HomeTipType.outgoing,
                                      ),
                                      HomeTipModel(
                                        title: 'Tip Title 3',
                                        description: 'Tip Description 2',
                                        type: HomeTipType.neutral,
                                      ),
                                    ],
                                  ),
                              };
                            },
                          ),
                        ),
                      ),
                      if (layout.isLarge) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Card(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.zero,
                                bottomRight: Radius.zero,
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Create debt',
                                      style: context.theme.textTheme.titleLarge,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Theme(
                                    data: context.outgoing,
                                    child: FilledButton(
                                      onPressed: () {},
                                      child: ConstrainedBox(
                                        constraints: const BoxConstraints(minWidth: 100),
                                        child: const Text(
                                          'I owe...',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Theme(
                                    data: context.incoming,
                                    child: FilledButton(
                                      onPressed: () {},
                                      child: ConstrainedBox(
                                        constraints: const BoxConstraints(minWidth: 100),
                                        child: const Text(
                                          'Someone owes...',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              );
            },
          );
        });
  }
}

enum Layout {
  verticalSmall,
  verticalLarge,
  horizontalSmall,
  horizontalLarge;

  bool get isVertical => this == Layout.verticalSmall || this == Layout.verticalLarge;
  bool get isHorizontal => this == Layout.horizontalSmall || this == Layout.horizontalLarge;
  bool get isSmall => this == Layout.horizontalSmall || this == Layout.verticalSmall;
  bool get isLarge => this == Layout.horizontalLarge || this == Layout.verticalLarge;
}

class AdaptiveBody extends StatelessWidget {
  final Widget Function(BuildContext context, BoxConstraints constraints, Layout layout) builder;
  const AdaptiveBody({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth > 1000 ? 40 : 0),
          child: Align(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 1000,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return builder.call(context, constraints, constraints.layout);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

extension BoxConstraintsExtension on BoxConstraints {
  Layout get layout {
    final bool isVertical = maxHeight > maxWidth;
    final bool isLarge = min(maxWidth, maxHeight) > 600;
    if (isVertical) {
      if (isLarge) {
        return Layout.verticalLarge;
      } else {
        return Layout.verticalSmall;
      }
    } else {
      if (isLarge) {
        return Layout.horizontalLarge;
      } else {
        return Layout.horizontalSmall;
      }
    }
  }
}
