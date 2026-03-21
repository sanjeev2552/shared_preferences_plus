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
  String? _mainValue;
  String? _otherValue;
  int _mainKeys = 0;
  int _otherKeys = 0;

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
    _refreshValues();
    if (mounted) {
      setState(() {
        _ready = true;
      });
    }
  }

  void _refreshValues() {
    _mainValue = _main.getString('key_main');
    _otherValue = _other.getString('key_other');
    _mainKeys = _main.getKeys().length;
    _otherKeys = _other.getKeys().length;
  }

  void _setMain() async {
    await _main.setString('key_main', 'value_main');
    setState(_refreshValues);
  }

  void _setOther() async {
    await _other.setString('key_other', 'value_other');
    setState(_refreshValues);
  }

  void _removeMain() async {
    await _main.remove('key_main');
    setState(_refreshValues);
  }

  void _clearMain() async {
    await _main.clear();
    setState(_refreshValues);
  }

  void _reloadMain() async {
    await _main.reload();
    setState(_refreshValues);
  }

  void _reloadOther() async {
    await _other.reload();
    setState(_refreshValues);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Main container: ${_ready ? "main" : "loading..."}'),
                Text('key_main: ${_mainValue ?? "(null)"}'),
                Text('keys in main: $_mainKeys'),
                const SizedBox(height: 12),
                Text('Other container: ${_ready ? "other" : "loading..."}'),
                Text('key_other: ${_otherValue ?? "(null)"}'),
                Text('keys in other: $_otherKeys'),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _ready ? _setMain : null,
                  child: const Text('Set Main String'),
                ),
                ElevatedButton(
                  onPressed: _ready ? _setOther : null,
                  child: const Text('Set Other String'),
                ),
                ElevatedButton(
                  onPressed: _ready ? _removeMain : null,
                  child: const Text('Remove Main String'),
                ),
                ElevatedButton(
                  onPressed: _ready ? _clearMain : null,
                  child: const Text('Clear Main'),
                ),
                ElevatedButton(
                  onPressed: _ready ? _reloadMain : null,
                  child: const Text('Reload Main'),
                ),
                ElevatedButton(
                  onPressed: _ready ? _reloadOther : null,
                  child: const Text('Reload Other'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
