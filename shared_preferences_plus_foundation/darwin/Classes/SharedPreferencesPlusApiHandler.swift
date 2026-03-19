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

    func setInt(key: String, value: Int64, options: SharedPreferencesPlusPigeonOptions) throws {
        getUserDefaults(options: options)?.set(value, forKey: key)
    }

    func getInt(key: String, options: SharedPreferencesPlusPigeonOptions) throws -> Int64? {
        guard let stored = getUserDefaults(options: options)?.object(forKey: key) else {
            return nil
        }
        if let intValue = stored as? Int64 {
            return intValue
        }
        if let intValue = stored as? Int {
            return Int64(intValue)
        }
        return nil
    }

    func setDouble(key: String, value: Double, options: SharedPreferencesPlusPigeonOptions) throws {
        getUserDefaults(options: options)?.set(value, forKey: key)
    }

    func getDouble(key: String, options: SharedPreferencesPlusPigeonOptions) throws -> Double? {
        guard let stored = getUserDefaults(options: options)?.object(forKey: key) else {
            return nil
        }
        return stored as? Double
    }

    func setBool(key: String, value: Bool, options: SharedPreferencesPlusPigeonOptions) throws {
        getUserDefaults(options: options)?.set(value, forKey: key)
    }

    func getBool(key: String, options: SharedPreferencesPlusPigeonOptions) throws -> Bool? {
        guard let stored = getUserDefaults(options: options)?.object(forKey: key) else {
            return nil
        }
        return stored as? Bool
    }

    func setStringList(key: String, value: [String], options: SharedPreferencesPlusPigeonOptions) throws {
        getUserDefaults(options: options)?.set(value, forKey: key)
    }

    func getStringList(key: String, options: SharedPreferencesPlusPigeonOptions) throws -> [String]? {
        return getUserDefaults(options: options)?.stringArray(forKey: key)
    }

    func remove(key: String, options: SharedPreferencesPlusPigeonOptions) throws {
        getUserDefaults(options: options)?.removeObject(forKey: key)
    }

    func clear(options: SharedPreferencesPlusPigeonOptions) throws {
        guard let userDefaults = getUserDefaults(options: options) else {
            return
        }
        for key in userDefaults.dictionaryRepresentation().keys {
            userDefaults.removeObject(forKey: key)
        }
    }

    func containsKey(key: String, options: SharedPreferencesPlusPigeonOptions) throws -> Bool {
        return getUserDefaults(options: options)?.object(forKey: key) != nil
    }

    func getKeys(options: SharedPreferencesPlusPigeonOptions) throws -> [String] {
        guard let userDefaults = getUserDefaults(options: options) else {
            return []
        }
        return Array(userDefaults.dictionaryRepresentation().keys)
    }
}
