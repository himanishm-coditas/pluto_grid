import 'package:example/core/di/app_injector.dart';
import 'package:example/feature/watchlist/presentation/screens/pluto_grid_watchlist_page.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await AppInjector.setupLocator();   runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Watchlist',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const WatchlistPage(),
    );
  }
}
