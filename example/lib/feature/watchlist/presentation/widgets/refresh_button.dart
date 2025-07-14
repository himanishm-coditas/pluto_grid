import 'package:example/core/constants/app_strings.dart';
import 'package:flutter/material.dart';

class RefreshButton extends StatelessWidget {
  const RefreshButton({required this.onPressed, super.key});

  ///responsible for onPressed o refresh button
  final VoidCallback onPressed;

  @override
  Widget build(final BuildContext context) => IconButton(
        onPressed: () => onPressed,
        tooltip: AppStrings.refreshTooltip,
        icon: const Icon(Icons.refresh),
      );
}
