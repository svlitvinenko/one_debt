import 'dart:math';

import 'package:flutter/widgets.dart';

class DSBottomSafeInset extends StatelessWidget {
  const DSBottomSafeInset({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: max(16, MediaQuery.of(context).viewInsets.bottom),
    );
  }
}
