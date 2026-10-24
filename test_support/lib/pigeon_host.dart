import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_plus_platform_interface/shared_preferences_plus_platform_interface.dart';

/// A host that traverses the real message codec, including nested dynamic lists.
void installPigeonHost({
  required MessageCodec<Object?> codec,
  required String channelPrefix,
  required String Function(Object?) containerName,
}) {
  final store = InMemorySharedPreferencesPlusPlatform();
  const methods = [
    'getAll',
    'getKeys',
    'containsKey',
    'clear',
    'remove',
    'getString',
    'getInt',
    'getDouble',
    'getBool',
    'getStringList',
    'setString',
    'setInt',
    'setDouble',
    'setBool',
    'setStringList',
  ];
  for (final method in methods) {
    final channel = BasicMessageChannel<Object?>(
      '$channelPrefix.$method',
      codec,
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockDecodedMessageHandler(channel, (message) async {
          final args = message! as List<Object?>;
          final options = SharedPreferencesPlusOptions(
            name: containerName(args.last),
          );
          final key = args.length > 1 ? args[0]! as String : '';
          final value = args.length > 2 ? args[1] : null;
          final Object? result;
          switch (method) {
            case 'getAll':
              result = await store.getAll(options: options);
            case 'getKeys':
              result = (await store.getKeys(options: options)).toList();
            case 'containsKey':
              result = await store.containsKey(key, options: options);
            case 'getString':
              result = await store.getString(key, options: options);
            case 'getInt':
              result = await store.getInt(key, options: options);
            case 'getDouble':
              result = await store.getDouble(key, options: options);
            case 'getBool':
              result = await store.getBool(key, options: options);
            case 'getStringList':
              result = await store.getStringList(key, options: options);
            case 'clear':
              await store.clear(options: options);
              result = null;
            case 'remove':
              await store.remove(key, options: options);
              result = null;
            case 'setString':
              await store.setString(key, value! as String, options: options);
              result = null;
            case 'setInt':
              await store.setInt(key, value! as int, options: options);
              result = null;
            case 'setDouble':
              await store.setDouble(key, value! as double, options: options);
              result = null;
            case 'setBool':
              await store.setBool(key, value! as bool, options: options);
              result = null;
            case 'setStringList':
              await store.setStringList(
                key,
                (value! as List).cast<String>(),
                options: options,
              );
              result = null;
            default:
              throw StateError('Unknown method');
          }
          return <Object?>[result];
        });
  }
}
