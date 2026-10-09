#!/usr/bin/env python3
"""Execute core test bodies with Apple's macOS Swift when XCTest/iOS SDK is absent.

Uses exact model sources and tests, a minimal assertion adapter, and only the
palette portion of AppTheme. This is NOT an iOS build, XCTest, or UI validation.
All generated sources and executables live in a temporary directory.
"""
import pathlib
import re
import subprocess
import tempfile

root = pathlib.Path(__file__).resolve().parents[1]
with tempfile.TemporaryDirectory(prefix="inspector-core-") as scratch:
    out = pathlib.Path(scratch)
    sources = []
    for model in (root / "1S0 Inspector Trainer/Models").glob("*.swift"):
        if model.name == "AppFeedback.swift":
            continue
        sources.append(str(model))
    palette = (root / "1S0 Inspector Trainer/Views/AppTheme.swift").read_text().split("enum AppSpacing")[0].replace("import UIKit", "")
    (out / "Palette.swift").write_text(palette)
    sources.append(str(out / "Palette.swift"))
    adapter = r'''
import Foundation
class XCTestCase { func setUp() {}; func tearDown() {} }
var failures = 0
func XCTFail(_ message: String = "", file: StaticString = #filePath, line: UInt = #line) {
    failures += 1; print("FAIL \(file):\(line): \(message)")
}
func XCTAssertTrue(_ value: @autoclosure () -> Bool, _ message: String = "", file: StaticString = #filePath, line: UInt = #line) {
    if !value() { XCTFail(message, file: file, line: line) }
}
func XCTAssertFalse(_ value: @autoclosure () -> Bool, _ message: String = "", file: StaticString = #filePath, line: UInt = #line) {
    if value() { XCTFail(message, file: file, line: line) }
}
func XCTAssertEqual<T: Equatable>(_ a: @autoclosure () -> T, _ b: @autoclosure () -> T, _ message: String = "", file: StaticString = #filePath, line: UInt = #line) {
    let left = a(), right = b(); if left != right { XCTFail("\(left) != \(right). \(message)", file: file, line: line) }
}
func XCTAssertEqual(_ a: Double, _ b: Double, accuracy: Double, file: StaticString = #filePath, line: UInt = #line) {
    if abs(a - b) > accuracy { XCTFail("Outside tolerance", file: file, line: line) }
}
func XCTAssertNil<T>(_ value: @autoclosure () -> T?, _ message: String = "", file: StaticString = #filePath, line: UInt = #line) {
    if value() != nil { XCTFail(message, file: file, line: line) }
}
func XCTAssertNotNil<T>(_ value: @autoclosure () -> T?, _ message: String = "", file: StaticString = #filePath, line: UInt = #line) {
    if value() == nil { XCTFail(message, file: file, line: line) }
}
func XCTAssertGreaterThan<T: Comparable>(_ a: T, _ b: T, _ message: String = "", file: StaticString = #filePath, line: UInt = #line) {
    if !(a > b) { XCTFail(message, file: file, line: line) }
}
func XCTAssertGreaterThanOrEqual<T: Comparable>(_ a: T, _ b: T, _ message: String = "", file: StaticString = #filePath, line: UInt = #line) {
    if !(a >= b) { XCTFail(message, file: file, line: line) }
}
struct UnwrapFailure: Error {}
func XCTUnwrap<T>(_ value: T?, _ message: String = "", file: StaticString = #filePath, line: UInt = #line) throws -> T {
    guard let value else { XCTFail(message, file: file, line: line); throw UnwrapFailure() }; return value
}
'''
    (out / "Assertions.swift").write_text(adapter)
    sources.append(str(out / "Assertions.swift"))
    calls = []
    count = 0
    for test in sorted((root / "1S0 Inspector TrainerTests").glob("*.swift")):
        text = test.read_text().replace("import XCTest", "import Foundation").replace("@testable import _S0_Inspector_Trainer", "")
        target = out / test.name
        target.write_text(text)
        sources.append(str(target))
        class_name = re.search(r"final class (\w+): XCTestCase", text)[1]
        for name, throws in re.findall(r"func (test\w+)\(\)( throws)?", text):
            count += 1
            call = ("try " if throws else "") + "test." + name + "()"
            if throws:
                call = "do { " + call + " } catch { XCTFail(String(describing: error)) }"
            calls.append("do { let test = " + class_name + "(); test.setUp(); " + call + "; test.tearDown() }")
    (out / "main.swift").write_text("import Foundation\n" + "\n".join(calls) + f'\nprint("Core test bodies: {count}; assertion failures: \\(failures)")\nexit(failures == 0 ? 0 : 1)\n')
    sources.append(str(out / "main.swift"))
    executable = out / "core-check"
    subprocess.run(["swiftc", "-swift-version", "5", "-target", "arm64-apple-macosx14.0", *sources, "-o", str(executable)], check=True)
    subprocess.run([str(executable)], check=True)
