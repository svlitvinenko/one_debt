import 'package:flutter/material.dart';

final ColorScheme defaultLightColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.amber,
  background: Colors.grey.shade50,
);

final ColorScheme defaultDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: Colors.amber,
  background: Colors.grey.shade900,
);

final ColorScheme incomingLightColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.green,
  background: Colors.grey.shade50,
);

final ColorScheme incomingDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: Colors.green,
  background: Colors.grey.shade900,
);

final ColorScheme outgoingLightColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.blue,
  background: Colors.grey.shade50,
);

final ColorScheme outgoingDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: Colors.blue,
  background: Colors.grey.shade900,
);
