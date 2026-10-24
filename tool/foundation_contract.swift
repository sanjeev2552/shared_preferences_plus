func check(_ condition: @autoclosure () throws -> Bool, file: StaticString = #file, line: UInt = #line) rethrows {
    let passed = try condition()
    assert(passed, file: file, line: line)
}
let options = SharedPreferencesPlusPigeonOptions(name: "shared_preferences_plus_contract_\(UUID().uuidString)")
let other = SharedPreferencesPlusPigeonOptions(name: "shared_preferences_plus_contract_\(UUID().uuidString)")
let defaults = UserDefaults(suiteName: options.name)!
defer {
    defaults.removePersistentDomain(forName: options.name)
    UserDefaults(suiteName: other.name)!.removePersistentDomain(forName: other.name)
}

let handler = SharedPreferencesPlusApiHandler()
for (index, list) in [[], [""], ["only"], ["a/0001ub", "重复", "重复"]].enumerated() {
    try handler.setStringList(key: "list\(index)", value: list, options: options)
    try check(handler.getStringList(key: "list\(index)", options: options) == list)
}
for value in [1.0, 1.0000000000000002, -0.0, Double.greatestFiniteMagnitude, Double.infinity, Double.nan] {
    try handler.setDouble(key: "double", value: value, options: options)
    let recreated = SharedPreferencesPlusApiHandler()
    let actual = try recreated.getDouble(key: "double", options: options)!
    assert(actual.bitPattern == value.bitPattern)
    try check(recreated.getInt(key: "double", options: options) == nil)
    try check(recreated.getBool(key: "double", options: options) == nil)
}
try handler.setInt(key: "int", value: Int64.max, options: options)
try check(handler.getInt(key: "int", options: options) == Int64.max)
try check(handler.getDouble(key: "int", options: options) == nil)
try check(handler.getBool(key: "int", options: options) == nil)
try handler.setBool(key: "bool", value: true, options: options)
try check(handler.getBool(key: "bool", options: options) == true)
try check(handler.getInt(key: "bool", options: options) == nil)
try handler.setString(key: "string", value: "value/0001u🐦", options: options)
try check(handler.getString(key: "string", options: options) == "value/0001u🐦")
defaults.set(1.5, forKey: "legacyDouble")
defaults.set(Int64(7), forKey: "legacyInt")
defaults.register(defaults: ["inherited": "must not appear in container"])
let all = try handler.getAll(options: options)
assert(all["inherited"] == nil)
assert(all["legacyDouble"] as? Double == 1.5)
assert(all["legacyInt"] as? Int64 == 7)
assert(all["list0"] as? [String] == [])
try handler.setString(key: "key", value: "other", options: other)
try handler.clear(options: options)
try check(handler.getAll(options: options).isEmpty)
try check(handler.getString(key: "key", options: other) == "other")
print("Foundation native storage contract passed")
