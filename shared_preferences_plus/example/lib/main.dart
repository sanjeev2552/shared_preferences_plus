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
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _other = await SharedPreferencesPlus.getInstance(
      options: const SharedPreferencesPlusOptions(name: 'other'),
    );
    _main = await SharedPreferencesPlus.getInstance(
      options: const SharedPreferencesPlusOptions(name: 'main'),
    );
    if (mounted) {
      setState(() {
        _ready = true;
      });
    }
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
                onPressed: _ready
                    ? () {
                  _main.setString('key_main', 'value_main');
                }
                    : null,
                child: const Text('Set Main String'),
              ),
              ElevatedButton(
                onPressed: _ready
                    ? () {
                  _other.setString('key_other', 'value_other');
                }
                    : null,
                child: const Text('Set Other String'),
              ),
              ElevatedButton(
                onPressed: _ready
                    ? () {
                  final value = _main.getString('key_main');
                  print(value);
                }
                    : null,
                child: const Text('Get Main String'),
              ),
              ElevatedButton(
                onPressed: _ready
                    ? () {
                  final value = _other.getString('key_other');
                  print(value);
                }
                    : null,
                child: const Text('Get Other String'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
