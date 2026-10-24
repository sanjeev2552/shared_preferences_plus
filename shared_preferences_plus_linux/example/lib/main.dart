import 'package:flutter/material.dart';
import 'package:shared_preferences_plus_linux/shared_preferences_plus_linux.dart';

void main() => runApp(const PreferencesExample());

/// Minimal native-backend example. For the cached public API and named
/// containers, see the app-facing package's example application.
class PreferencesExample extends StatefulWidget {
  const PreferencesExample({super.key});
  @override
  State<PreferencesExample> createState() => _PreferencesExampleState();
}

class _PreferencesExampleState extends State<PreferencesExample> {
  late final Future<int> _launchCount = _load();

  Future<int> _load() async {
    final preferences = SharedPreferencesPlusLinux();
    final count = (await preferences.getInt('example_launch_count') ?? 0) + 1;
    await preferences.setInt('example_launch_count', count);
    return count;
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: const Text('Preferences example')),
      body: Center(
        child: FutureBuilder<int>(
          future: _launchCount,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Unable to load preferences.');
            }
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            return Text('Saved launch count: ${snapshot.data}');
          },
        ),
      ),
    ),
  );
}
