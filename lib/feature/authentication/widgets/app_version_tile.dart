import 'package:flutter/material.dart';
import 'package:one_debt/core/design/theme/theme.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersionTile extends StatelessWidget {
  const AppVersionTile({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: Align(
            alignment: Alignment.center,
            child: snapshot.hasData
                ? Text(
                    '${snapshot.requireData.version} (${snapshot.requireData.buildNumber})',
                    style: context.textTheme.labelSmall,
                  )
                : const SizedBox.expand(),
          ),
        );
      },
    );
  }
}
