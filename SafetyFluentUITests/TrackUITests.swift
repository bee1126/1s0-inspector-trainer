import XCTest

final class TrackUITests: XCTestCase {
    private func launch(_ track: String? = nil) -> XCUIApplication {
        let app = XCUIApplication(); app.launchEnvironment["SAFETYFLUENT_UI_TEST"] = UUID().uuidString; app.launch()
        XCTAssertTrue(app.buttons["track-continue"].waitForExistence(timeout: 20))
        XCTAssertFalse(app.buttons["track-continue"].isEnabled)
        if let track { app.buttons["track-\(track)"].tap(); app.buttons["track-continue"].tap() }
        return app
    }
    func testFirstLaunchOSHA() { let app = launch("osha"); XCTAssertTrue(app.buttons["today-track-chip"].waitForExistence(timeout: 10)); XCTAssertFalse(app.buttons["track-continue"].exists) }
    func testFirstLaunchAirForce() { let app = launch("airForce"); XCTAssertTrue(app.buttons["today-track-chip"].waitForExistence(timeout: 10)) }
    func testSettingsSwitchRequiresConfirmation() {
        let app = launch("airForce"); app.buttons["today-track-chip"].tap()
        app.segmentedControls["training-track-picker"].buttons["OSHA / Civilian"].tap()
        XCTAssertTrue(app.buttons["confirm-track-switch"].waitForExistence(timeout: 5))
        app.buttons["confirm-track-switch"].tap(); app.buttons["Done"].tap()
        XCTAssertTrue(app.buttons["today-track-chip"].label.contains("OSHA"))
    }
    func testUpgradeShowsBannerAndNoPicker() throws {
        let app = XCUIApplication(); app.launchEnvironment["SAFETYFLUENT_UI_TEST"] = UUID().uuidString
        let url = try XCTUnwrap(Bundle(for: Self.self).url(forResource: "v17-install", withExtension: "plist"))
        app.launchEnvironment["SAFETYFLUENT_LEGACY_FIXTURE"] = try Data(contentsOf: url).base64EncodedString(); app.launch()
        XCTAssertTrue(app.staticTexts["New: an OSHA / Civilian track. Switch in Settings."].waitForExistence(timeout: 20))
        XCTAssertFalse(app.buttons["track-continue"].exists)
    }
    func testPickerAndRiskSummaryAtXXLDark() throws {
        for screen in ["picker", "hazard"] {
            let app = XCUIApplication()
            app.launchEnvironment["SAFETYFLUENT_SCREENSHOT"] = screen
            app.launch()
            XCTAssertTrue(app.wait(for: .runningForeground, timeout: 20))
            // Audit custom picker typography across the full range. Native Form
            // controls report partial support at the largest accessibility sizes;
            // verify their requested XXL scaling directly below instead.
            try app.performAccessibilityAudit(for: screen == "picker" ? [.sufficientElementDescription, .dynamicType] : [.sufficientElementDescription])
            let standardLabelHeight = screen == "hazard" ? app.staticTexts["Imminent danger"].firstMatch.frame.height : 0
            app.terminate()
            app.launchEnvironment["SAFETYFLUENT_QA_DARK"] = "1"
            app.launchArguments += ["-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryXXL"]
            app.launch()
            if screen == "picker" {
                XCTAssertTrue(app.buttons["track-osha"].waitForExistence(timeout: 20))
                XCTAssertTrue(app.buttons["track-osha"].isHittable)
                XCTAssertTrue(app.buttons["track-airForce"].isHittable)
            } else {
                XCTAssertTrue(app.textFields["Location or area"].waitForExistence(timeout: 20))
                XCTAssertGreaterThan(app.staticTexts["Imminent danger"].firstMatch.frame.height, standardLabelHeight)
                app.swipeUp()
                XCTAssertTrue(app.descendants(matching: .any).matching(NSPredicate(format: "label CONTAINS %@", "Risk level: Medium")).firstMatch.exists)
            }
            let shot = XCTAttachment(screenshot: app.screenshot()); shot.name = "XXL-dark-" + screen; shot.lifetime = .keepAlways; add(shot)
            app.terminate()
        }
    }
    func testScreenshots() {
        for screen in ["today", "picker", "airforce", "builder", "debrief", "quiz", "progress", "hazard"] {
            let app = XCUIApplication(); app.launchEnvironment["SAFETYFLUENT_SCREENSHOT"] = screen; app.launch()
            if screen == "picker" { XCTAssertTrue(app.buttons["track-continue"].waitForExistence(timeout: 20)) }
            else { XCTAssertTrue(app.navigationBars.firstMatch.waitForExistence(timeout: 20)) }
            if screen == "progress" { XCTAssertFalse(app.staticTexts["Airman"].exists) }
            if screen == "hazard" {
                XCTAssertTrue(app.textFields["Location or area"].exists)
                app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.75)).press(forDuration: 0.1, thenDragTo: app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.45)))
                XCTAssertTrue(app.descendants(matching: .any).matching(NSPredicate(format: "label CONTAINS %@", "Risk level: Medium")).firstMatch.exists)
            }
            let shot = XCTAttachment(screenshot: app.screenshot()); shot.name = screen; shot.lifetime = .keepAlways; add(shot)
            app.terminate()
        }
    }
}
