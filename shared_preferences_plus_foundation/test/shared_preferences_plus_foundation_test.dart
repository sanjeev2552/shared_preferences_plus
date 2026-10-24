import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_plus_foundation/shared_preferences_plus_foundation.dart';
import 'package:shared_preferences_plus_platform_interface/shared_preferences_plus_platform_interface.dart';

void main() {
  test('registration selects the Foundation adapter', () {
    final original = SharedPreferencesPlusPlatform.instance;
    addTearDown(() {
      SharedPreferencesPlusPlatform.instance = original;
    });
    SharedPreferencesPlusFoundation.registerWith();
    expect(
      SharedPreferencesPlusPlatform.instance,
      isA<SharedPreferencesPlusFoundation>(),
    );
  });
}
