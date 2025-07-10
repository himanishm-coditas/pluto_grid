import 'package:example/feature/watchlist/presentation/bloc/watchlist_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToggleThemeButton extends StatelessWidget {
  const ToggleThemeButton({super.key,required this.onPressed});
  ///responsible for toggling theme onPressed
  final VoidCallback onPressed;
  @override
  Widget build(final BuildContext context) => IconButton(
        icon: const Icon(Icons.brightness_6),
        onPressed:onPressed,
      );
}
