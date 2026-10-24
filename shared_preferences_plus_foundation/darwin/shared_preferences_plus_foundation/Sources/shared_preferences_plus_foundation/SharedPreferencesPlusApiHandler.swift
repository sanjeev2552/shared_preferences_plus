import Foundation
import CoreFoundation

class SharedPreferencesPlusApiHandler: NSObject, SharedPreferencesPlusApi {
    private let doubleTag = "shared_preferences_plus/double/1"

    private func defaults(_ options: SharedPreferencesPlusPigeonOptions) throws -> UserDefaults {
        guard let defaults = UserDefaults(suiteName: options.name) else {
            throw NSError(domain: "shared_preferences_plus", code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "Unable to open preferences container"])
        }
        return defaults
    }

    private func decode(_ value: Any) -> Any? {
        if let envelope = value as? [String: String], envelope["type"] == doubleTag,
           let text = envelope["value"], let double = Double(text) {
            return double
        }
        if let number = value as? NSNumber {
            if CFGetTypeID(number) == CFBooleanGetTypeID() { return number.boolValue }
            let type = String(cString: number.objCType)
            return type == "f" || type == "d" ? number.doubleValue as Any : number.int64Value as Any
        }
        if let string = value as? String { return string }
        if let list = value as? [String] { return list }
        return nil
    }

    private func value(_ key: String, _ options: SharedPreferencesPlusPigeonOptions) throws -> Any? {
        guard let raw = try defaults(options).persistentDomain(forName: options.name)?[key] else { return nil }
        return decode(raw)
    }

    func setString(key: String, value: String, options: SharedPreferencesPlusPigeonOptions) throws {
        try defaults(options).set(value, forKey: key)
    }
    func getString(key: String, options: SharedPreferencesPlusPigeonOptions) throws -> String? {
        return try value(key, options) as? String
    }
    func setInt(key: String, value: Int64, options: SharedPreferencesPlusPigeonOptions) throws {
        try defaults(options).set(value, forKey: key)
    }
    func getInt(key: String, options: SharedPreferencesPlusPigeonOptions) throws -> Int64? {
        return try value(key, options) as? Int64
    }
    func setDouble(key: String, value: Double, options: SharedPreferencesPlusPigeonOptions) throws {
        try defaults(options).set(["type": doubleTag, "value": String(value)], forKey: key)
    }
    func getDouble(key: String, options: SharedPreferencesPlusPigeonOptions) throws -> Double? {
        return try value(key, options) as? Double
    }
    func setBool(key: String, value: Bool, options: SharedPreferencesPlusPigeonOptions) throws {
        try defaults(options).set(value, forKey: key)
    }
    func getBool(key: String, options: SharedPreferencesPlusPigeonOptions) throws -> Bool? {
        return try value(key, options) as? Bool
    }
    func setStringList(key: String, value: [String], options: SharedPreferencesPlusPigeonOptions) throws {
        try defaults(options).set(value, forKey: key)
    }
    func getStringList(key: String, options: SharedPreferencesPlusPigeonOptions) throws -> [String]? {
        return try value(key, options) as? [String]
    }
    func remove(key: String, options: SharedPreferencesPlusPigeonOptions) throws {
        try defaults(options).removeObject(forKey: key)
    }
    func clear(options: SharedPreferencesPlusPigeonOptions) throws {
        try defaults(options).removePersistentDomain(forName: options.name)
    }
    func containsKey(key: String, options: SharedPreferencesPlusPigeonOptions) throws -> Bool {
        return try defaults(options).persistentDomain(forName: options.name)?[key] != nil
    }
    func getKeys(options: SharedPreferencesPlusPigeonOptions) throws -> [String] {
        return Array(try getAll(options: options).keys)
    }
    func getAll(options: SharedPreferencesPlusPigeonOptions) throws -> [String: Any?] {
        let stored = try defaults(options).persistentDomain(forName: options.name) ?? [:]
        var result: [String: Any?] = [:]
        for (key, raw) in stored {
            if let decoded = decode(raw) { result[key] = decoded }
        }
        return result
    }
}
