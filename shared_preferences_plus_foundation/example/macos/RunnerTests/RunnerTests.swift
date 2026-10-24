import XCTest
@testable import shared_preferences_plus_foundation

class RunnerTests: XCTestCase {
    func testStoredTypesSurviveHandlerRecreation() throws {
        let options = SharedPreferencesPlusPigeonOptions(name: "native_test_\(UUID().uuidString)")
        let handler = SharedPreferencesPlusApiHandler()
        defer { try? handler.clear(options: options) }
        try handler.setDouble(key: "double", value: 1.0, options: options)
        try handler.setInt(key: "int", value: Int64.max, options: options)
        try handler.setStringList(key: "list", value: ["", "a/0001ub"], options: options)
        let recreated = SharedPreferencesPlusApiHandler()
        XCTAssertEqual(try recreated.getDouble(key: "double", options: options), 1.0)
        XCTAssertNil(try recreated.getInt(key: "double", options: options))
        XCTAssertEqual(try recreated.getInt(key: "int", options: options), Int64.max)
        XCTAssertEqual(try recreated.getStringList(key: "list", options: options), ["", "a/0001ub"])
    }
}
