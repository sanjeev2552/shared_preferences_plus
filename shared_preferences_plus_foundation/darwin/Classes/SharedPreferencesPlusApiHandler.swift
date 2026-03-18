import Foundation

class SharedPreferencesPlusApiHandler: NSObject, SharedPreferencesPlusApi {
    private func getUserDefaults(options: SharedPreferencesPlusPigeonOptions) -> UserDefaults? {
        return UserDefaults.init(suiteName: options.name)
    }
    
    func getString(key: String, options: SharedPreferencesPlusPigeonOptions) throws -> String? {
        return getUserDefaults(options: options)?.string(forKey: key)
    }
    
    func setString(key: String, value: String, options: SharedPreferencesPlusPigeonOptions) throws {
        getUserDefaults(options: options)?.set(value, forKey: key)
    }
}
