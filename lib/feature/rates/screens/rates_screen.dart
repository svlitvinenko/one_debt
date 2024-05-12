import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_debt/core/design/components/ds_app_bar.dart';
import 'package:one_debt/core/design/components/ds_scaffold.dart';
import 'package:one_debt/core/model/d_money.dart';
import 'package:one_debt/feature/rates/bloc/rates_bloc.dart';

class RatesScreen extends StatelessWidget {
  const RatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RatesBloc()..add(const RatesEvent.initialized()),
      child: DSScaffold(
        appBar: const DSAppBar(
          title: Text('Currency rates'),
        ),
        body: (context, constraints, layout) {
          return BlocBuilder<RatesBloc, RatesState>(
            builder: (context, state) {
              return state.map(
                loading: (state) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
                idle: (state) {
                  return ListView.builder(
                    itemCount: state.convertedRates.length,
                    itemBuilder: (context, index) {
                      final DMoney rate = state.convertedRates[index];
                      return ListTile(
                        title: Text(rate.isoCode),
                        subtitle: Text(rate.toString()),
                      );
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
}
