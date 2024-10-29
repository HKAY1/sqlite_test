// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/db/db.dart';
import 'package:test_app/models/user_model.dart';
import 'package:test_app/service/bio_auth_service.dart';
import 'package:test_app/service/internet_service.dart';
import 'package:test_app/service/isolate_service.dart';
import 'package:test_app/ui/auth/login.dart';
import 'package:test_app/ui/notes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'locale.dart';
import 'provider/app_locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatabase.instance.database;
  final instance = await SharedPreferences.getInstance();
  final user = await AppDatabase.instance.readUser1();
  AppLanguageProvider appLanguage = AppLanguageProvider();
  InternetConnectivity.instance.initialize();
  await BioAuthService.instance.initialize();
  IsolateService.instance.initialize();
  await appLanguage.fetchLocale();
  runApp(ProviderScope(
    child: MyApp(
      instance: instance,
      user: user.isEmpty ? null : UserModel.fromMap(user.first),
      appLanguage: appLanguage,
    ),
  ));
}

class MyApp extends StatefulWidget {
  final SharedPreferences instance;
  final UserModel? user;
  final AppLanguageProvider appLanguage;
  const MyApp({
    super.key,
    required this.instance,
    this.user,
    required this.appLanguage,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(appLocalProvider.notifier);
      return MaterialApp(
        title: 'SQFlite Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: widget.instance.getBool("isLogin") == true
            ? NotesView(user: widget.user!)
            : const LoginScreen(),
        locale: state.appLocal,
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('hi', 'IN'),
        ],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
      );
    });
  }
}
