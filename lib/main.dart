import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:walletfox/model/subscription_model.dart';
import 'package:walletfox/providers/subscription_provider.dart';
import 'package:walletfox/services/notification_service.dart';
import 'package:walletfox/utils/constants/strings.dart';
import 'package:walletfox/utils/styles/app_theme.dart';
import 'package:walletfox/views/dashboard_view.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(SubscriptionModelAdapter());

  NotificationService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SubscriptionProvider()..init(),
      child: MaterialApp(
          title: APP_NAME,
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: kDebugMode,
        
          home: const DashboardView(),
        )
    );
  }
}