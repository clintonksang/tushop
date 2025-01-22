import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:async';

import 'package:provider/provider.dart';
import 'package:tushop/application/router/router.dart';
import 'package:tushop/application/utils/colors.dart';
import 'package:tushop/firebase_options.dart';

import 'domains/models/task_model.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();

    await Hive.initFlutter();
    Hive.registerAdapter(TaskModelAdapter());

    await Hive.openBox<TaskModel>('tasks');

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    runApp(EasyLocalization(
        path: 'assets/lang',
        supportedLocales: const [
          Locale('en'),
        ],
        fallbackLocale: const Locale('en'),
        useFallbackTranslations: true,
        child: MyApp()));
  }, (dynamic error, dynamic stack) {});
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AppRouter.initial,
      onGenerateRoute: AppRouter.onGenerateRoute,
      title: 'Acme Solutions,',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        primaryColor: primaryColor,
        fontFamily: 'Poppins',
      ),
    );
  }
}
