import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_debt/core/dependencies/dependencies.dart';
import 'package:one_debt/core/design/components/ds_adaptive_body.dart';
import 'package:one_debt/core/design/components/ds_bottom_safe_inset.dart';
import 'package:one_debt/core/design/components/ds_card.dart';
import 'package:one_debt/core/design/theme/theme.dart';
import 'package:one_debt/core/interactor/auth.dart';
import 'package:one_debt/core/interactor/rates.dart';
import 'package:one_debt/core/model/d_money.dart';
import 'package:one_debt/feature/rates/bloc/rates_bloc.dart';
import 'package:one_debt/feature/rates/widgets/rates_amount_field.dart';
import 'package:staggered_grid_view_flutter/rendering/sliver_staggered_grid.dart';
import 'package:staggered_grid_view_flutter/widgets/sliver.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class RatesScreen extends StatefulWidget {
  const RatesScreen({super.key});

  @override
  State<RatesScreen> createState() => _RatesScreenState();
}

class _RatesScreenState extends State<RatesScreen> {
  late final ValueNotifier<DMoney> typedCentsController;

  @override
  void initState() {
    typedCentsController = ValueNotifier(DMoney(cents: 100, isoCode: getDependency<Auth>().user?.currency ?? 'USD'));
    getDependency<Auth>().addListener(onUserChanged);
    super.initState();
  }

  @override
  void dispose() {
    typedCentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RatesBloc()..add(const RatesEvent.initialized()),
      child: BlocBuilder<RatesBloc, RatesState>(
        builder: (context, state) {
          return Material(
            child: state.map(
              loading: (state) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              idle: (state) {
                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      floating: true,
                      elevation: 0,
                      backgroundColor: context.colorScheme.background,
                      title: const Text('Currency rates'),
                    ),
                    SliverToBoxAdapter(
                      child: DSAdaptiveBody(
                        builder: (context, constraints, layout) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Currency rates are provided with ',
                                    style: context.textTheme.bodyMedium,
                                  ),
                                  TextSpan(
                                    text: 'this third-party API',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        launchUrl(Uri.parse('https://github.com/fawazahmed0/exchange-api'));
                                      },
                                    style: context.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: context.colorScheme.primary,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' and may not be up to date.',
                                    style: context.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SliverPersistentHeader(
                      delegate: RatesAmountFieldDelegate(
                        typedCentsController: typedCentsController,
                      ),
                      pinned: true,
                    ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: max(16, (MediaQuery.of(context).size.width - 1000) / 2 + 16),
                      ),
                      sliver: SliverLayoutBuilder(
                        builder: (context, constraints) {
                          return SliverStaggeredGrid(
                            gridDelegate: SliverStaggeredGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: constraints.crossAxisExtent ~/ 220,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              staggeredTileCount: state.convertedRates.length,
                              staggeredTileBuilder: (index) {
                                return const StaggeredTile.extent(1, 80);
                              },
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final DMoney rate = state.convertedRates[index];
                                return DSAdaptiveBody(
                                  builder: (context, constraints, layout) {
                                    return SizedBox(
                                      height: 80,
                                      child: DSCard(
                                        background: AnimatedContainer(
                                          duration: context.times.fastest,
                                          color: context.colorScheme.primaryContainer.withOpacity(
                                              getDependency<Auth>().user?.currency == rate.isoCode ? 1.00 : 00),
                                        ),
                                        onTap: getDependency<Auth>().user?.currency == rate.isoCode
                                            ? null
                                            : () {
                                                getDependency<Auth>().setCurrency(rate.isoCode);
                                              },
                                        title: Text(rate.isoCode),
                                        child: ValueListenableBuilder<DMoney>(
                                            valueListenable: typedCentsController,
                                            builder: (context, amount, _) {
                                              return Expanded(
                                                child: Align(
                                                  alignment: Alignment.bottomLeft,
                                                  child: Text(getDependency<Rates>()
                                                          .convert(amount, rate.isoCode)
                                                          ?.formattedNumber ??
                                                      ''),
                                                ),
                                              );
                                            }),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: DSBottomSafeInset(),
                    )
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  void onUserChanged() {
    typedCentsController.value =
        typedCentsController.value.copyWith(isoCode: getDependency<Auth>().user?.currency ?? 'USD');
  }
}
