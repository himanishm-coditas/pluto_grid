import 'package:example/core/constants/app_colors.dart';
import 'package:example/core/di/app_injector.dart';
import 'package:example/core/services/storage/shared_prefs_service.dart';
import 'package:example/feature/watchlist/presentation/bloc/watchlist_bloc.dart';
import 'package:example/feature/watchlist/presentation/screens/pluto_grid_watchlist_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInjector.setupLocator();
  await AppInjector.getIt<SharedPrefsService>().initSharedPreferences();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(final BuildContext context) => BlocProvider<WatchlistBloc>(
        create: (final BuildContext context) =>
            AppInjector.getIt<WatchlistBloc>()..add(const LoadWatchlistEvent()),
        child: BlocBuilder<WatchlistBloc, WatchlistState>(
          builder: (final BuildContext context, final WatchlistState state) {
            bool isDark = false;
            final WatchlistState currentState=state;

            if (currentState is WatchlistLoaded) {
              isDark = currentState.isDarkTheme;
            }
            return MaterialApp(
              title: 'Stock Watchlist',
              debugShowCheckedModeBanner: false,
              themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
              darkTheme: ThemeData(
                appBarTheme: const AppBarTheme(
                  color: AppColors.black
                ,)
              ,),
              home: const WatchlistPage(),
            );
          },
        ),
      );
}
