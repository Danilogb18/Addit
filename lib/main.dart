import 'package:addit/config/router/app_router.dart';
import 'package:addit/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('es');

  runApp(
    const ProviderScope(child: MainApp())
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme().getTheme(),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
