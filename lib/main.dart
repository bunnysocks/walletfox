import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:walletfox/model/subscription_model.dart';
import 'package:walletfox/utils/constants/strings.dart';
import 'package:walletfox/utils/styles/app_theme.dart';
import 'package:walletfox/views/dashboard_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(SubscriptionModelAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_NAME,
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,

      home: const DashboardView(),
    );
  }
}