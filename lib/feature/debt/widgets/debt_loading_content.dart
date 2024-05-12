import 'package:flutter/material.dart';

class DebtLoadingContent extends StatelessWidget {
  const DebtLoadingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}