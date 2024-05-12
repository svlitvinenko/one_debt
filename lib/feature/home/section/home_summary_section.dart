import 'package:flutter/material.dart';
import 'package:one_debt/core/design/components/ds_card.dart';

class HomeSummarySection extends StatelessWidget {
  const HomeSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return const DSCard(
      title: Text('Summary'),
    );
  }
}
