import Foundation

#if os(iOS)
    import Flutter
#elseif os(macOS)
    import FlutterMacOS
#endif

public class SharedPreferencesPlusFoundationPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        var preferencesHandler = SharedPreferencesPlusApiHandler()
        
        #if os(iOS)
            let messenger = registrar.messenger()
        #else
            let messenger = registrar.messenger
        #endif
        
        SharedPreferencesPlusApiSetup.setUp(binaryMessenger: messenger, api: preferencesHandler, messageChannelSuffix: "shared_preferences_plus_foundation")
    }
}
