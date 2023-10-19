import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:coincap/models/app_config.dart';
import 'package:coincap/models/http_service.dart';
import 'package:coincap/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _loadConfig();
  _registerHttpService();
  runApp(const MyApp());
}

Future<void> _loadConfig() async {
  String configContent = await rootBundle.loadString('config/main.json');
  Map configData = jsonDecode(configContent);
  GetIt.instance.registerSingleton<AppConfig>(
    AppConfig(coinApiBaseUrl: configData['COIN_API_BASE_URL']),
  );
}

void _registerHttpService() {
  GetIt.instance.registerSingleton<HttpService>(HttpService());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(context) {
    return MaterialApp(
      title: 'CoinCap',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color.fromRGBO(88, 60, 197, 1.0),
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
