import 'package:flutter/material.dart';
import 'package:shared_preferences_plus/shared_preferences_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SharedPreferencesPlus _main, _other;

  @override
  void initState() {
    _other = SharedPreferencesPlus(options: const SharedPreferencesPlusOptions(name: 'other'));
    _main = SharedPreferencesPlus(options: const SharedPreferencesPlusOptions(name: 'main'));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint(
        'SharedPreferencesPlusPlatform: ${SharedPreferencesPlusPlatform.instance.runtimeType}',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _main.setString('key_main', 'value_main');
                },
                child: const Text('Set Main String'),
              ),
              ElevatedButton(
                onPressed: () {
                  _other.setString('key_other', 'value_other');
                },
                child: const Text('Set Other String'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final value = await _main.getString('key_main');
                  print(value);
                },
                child: const Text('Get Main String'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final value = await _other.getString('key_other');
                  print(value);
                },
                child: const Text('Get Other String'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
