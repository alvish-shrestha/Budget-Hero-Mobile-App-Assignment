import 'package:budgethero/app/service_locator/service_locator.dart';
import 'package:budgethero/app/theme/theme_data.dart';
import 'package:budgethero/features/splash_screen/presentation/view/splash_screen.dart';
import 'package:budgethero/features/splash_screen/presentation/view_model/splash_screen_view_model.dart';
import 'package:budgethero/features/transaction/data/sync/sync_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_flutter/adapters.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await initDependencies();
  setupConnectivityListener();

  runApp(
    MaterialApp(
      theme: myApplicationTheme(),
      home: BlocProvider(
        create: (_) => serviceLocator<SplashScreenViewModel>(),
        child: const SplashScreen(),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}

void setupConnectivityListener() {
  Connectivity().onConnectivityChanged.listen((result) {
    if (!result.contains(ConnectivityResult.none)) {
      serviceLocator<SyncService>().syncPendingTransactions();
    }
  });
}