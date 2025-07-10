import 'package:example/core/constants/app_colors.dart';
import 'package:example/core/controller/theme_controller.dart';
import 'package:example/core/di/app_injector.dart';
import 'package:example/core/services/storage/local_storage_service.dart';
import 'package:example/feature/watchlist/presentation/screens/pluto_grid_watchlist_page.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInjector.setupLocator();
  await AppInjector.getIt<SharedPrefsService>().initSharedPreferences();
  // Initialize theme controller to load saved preference
  await AppInjector.getIt<ThemeController>().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(final BuildContext context) => ValueListenableBuilder<ThemeMode>(
        valueListenable: AppInjector.getIt<ThemeController>(),
        builder:
            (final BuildContext context, final ThemeMode themeMode, final _) =>
                MaterialApp(
          title: 'Stock Watchlist',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
              color: AppColors.white,
            ),
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            appBarTheme: const AppBarTheme(
              color: AppColors.black,
            ),
            brightness: Brightness.dark,
          ),
          themeMode: themeMode,
          home: const WatchlistPage(),
        ),
      );
}
