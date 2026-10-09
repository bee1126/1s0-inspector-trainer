import XCTest
import PDFKit
@testable import _S0_Inspector_Trainer

class TrackTestCase: XCTestCase {
    var defaults: UserDefaults!
    private var suite = ""
    override func setUp() { super.setUp(); suite = "SafetyXP.tests.\(UUID())"; defaults = UserDefaults(suiteName: suite)!; defaults.removePersistentDomain(forName: suite) }
    override func tearDown() { defaults.removePersistentDomain(forName: suite); defaults = nil; super.tearDown() }
    func fixture() throws -> [String: Any] {
        let url = try XCTUnwrap(Bundle(for: TrackMigrationTests.self).url(forResource: "v17-install", withExtension: "plist"))
        return try XCTUnwrap(PropertyListSerialization.propertyList(from: Data(contentsOf: url), format: nil) as? [String: Any])
    }
}
final class TrackMigrationTests: TrackTestCase {
    func testReal17FixturePreservesEveryLegacyKeyAndDecodedState() throws {
        let old = try fixture(); old.forEach { defaults.set($0.value, forKey: $0.key) }
        let raw = try XCTUnwrap(defaults.data(forKey: "study_state_v1"))
        let before = try JSONDecoder().decode(StudyPersistence.self, from: raw)
        let store = ProgressStore(defaults: defaults)
        XCTAssertEqual(store.selectedTrack, .airForce); XCTAssertTrue(store.showTrackBanner)
        XCTAssertEqual(store.xp, old["xpTotal"] as? Int); XCTAssertEqual(store.level, max(1, store.xp / 120 + 1))
        XCTAssertEqual(store.dailyStreak, old["dailyStreak"] as? Int)
        XCTAssertEqual(store.studyState.savedQuestionIDs, before.savedQuestionIDs)
        XCTAssertEqual(store.studyState.history.map(\.id), before.history.map(\.id))
        XCTAssertEqual(store.studyState.completedSessionIDs, before.completedSessionIDs)
        for (key, value) in old { XCTAssertEqual(defaults.object(forKey: key) as? NSObject, value as? NSObject, key) }
        XCTAssertEqual(defaults.data(forKey: "study_state_v1_backup_pre18"), raw)
        let again = ProgressStore(defaults: defaults)
        XCTAssertEqual(again.xp, store.xp); XCTAssertEqual(again.completedModules, store.completedModules)
        XCTAssertEqual(again.srCards.keys.sorted(), store.srCards.keys.sorted())
        XCTAssertEqual(defaults.data(forKey: "study_state_v1"), raw)
    }
    func testBackupIsWrittenOnlyOnce() throws {
        let raw = try JSONEncoder().encode(StudyPersistence()); defaults.set(raw, forKey: "study_state_v1")
        let first = ProgressStore(defaults: defaults); first.toggleSavedQuestion("loto-q1")
        _ = ProgressStore(defaults: defaults)
        XCTAssertEqual(defaults.data(forKey: "study_state_v1_backup_pre18"), raw)
    }
    func testFreshInstallAndRelaunchRequireExplicitSelection() {
        let first = ProgressStore(defaults: defaults); XCTAssertNil(first.selectedTrack)
        first.refreshForNewDayIfNeeded()
        XCTAssertNil(ProgressStore(defaults: defaults).selectedTrack)
        first.selectTrack(.osha); XCTAssertEqual(ProgressStore(defaults: defaults).selectedTrack, .osha)
    }
    func testCorruptLegacyBytesSurviveMutationsAndRelaunch() {
        let raw = Data("{broken".utf8); defaults.set(raw, forKey: "study_state_v1")
        let store = ProgressStore(defaults: defaults); XCTAssertNotNil(store.recoveryNotice)
        store.toggleSavedQuestion("loto-q1")
        XCTAssertEqual(defaults.data(forKey: "study_state_v1"), raw)
        XCTAssertEqual(defaults.data(forKey: "study_state_v1_backup_pre18"), raw)
        XCTAssertTrue(ProgressStore(defaults: defaults).isQuestionSaved("loto-q1"))
    }
    func testBannerDismissalPersists() throws {
        defaults.set(try JSONEncoder().encode(StudyPersistence()), forKey: "study_state_v1")
        let store = ProgressStore(defaults: defaults); XCTAssertTrue(store.showTrackBanner); store.dismissTrackBanner()
        XCTAssertFalse(ProgressStore(defaults: defaults).showTrackBanner)
    }
    func testRetiredReviewsRemainStoredButHidden() {
        let store = ProgressStore(defaults: defaults); store.selectTrack(.airForce); store.updateSRCard(questionId: "loto-q3", quality: 0)
        XCTAssertNotNil(store.srCards["loto-q3"]); XCTAssertFalse(store.overdueCards().contains { $0.questionId == "loto-q3" })
    }
}
final class TrackSwitchTests: TrackTestCase {
    func testSwitchPreservesAllProgressBytesAndHiddenBookmarks() throws {
        let store = ProgressStore(defaults: defaults); store.selectTrack(.airForce)
        store.toggleSavedQuestion("rm-q101"); store.updateSRCard(questionId: "rm-q101", quality: 0)
        store.markCompleted(moduleId: "risk-management", score: 90, scenarioPerfect: true, quizPerfect: false)
        let before = defaults.dictionaryRepresentation().filter { !["selected_track_v1", "track_picker_pending_v1"].contains($0.key) }
        store.selectTrack(.osha); XCTAssertEqual(store.hiddenBookmarkCount, 1); XCTAssertTrue(store.isQuestionSaved("rm-q101"))
        store.selectTrack(.airForce); XCTAssertEqual(store.hiddenBookmarkCount, 0)
        for (key, value) in before { XCTAssertEqual(defaults.object(forKey: key) as? NSObject, value as? NSObject, key) }
    }
    func testNewModulesEarnFirstMilestonesGlobally() {
        let store = ProgressStore(defaults: defaults); store.selectTrack(.osha)
        store.markCompleted(moduleId: "ppeha", score: 90, scenarioPerfect: false, quizPerfect: false)
        XCTAssertTrue(store.badgeMilestones.firstCompletion); XCTAssertTrue(store.badgeMilestones.firstHighScore)
        let before = store.badgeMilestones; store.selectTrack(.airForce)
        XCTAssertEqual(store.badgeMilestones, before)
    }
    func testCivilianCatalogCanEarnCompletionMilestonesWithoutHiddenModules() {
        let store = ProgressStore(defaults: defaults); store.selectTrack(.osha)
        for module in store.catalog.modules { store.markCompleted(moduleId: module.id, score: 90, scenarioPerfect: false, quizPerfect: false) }
        XCTAssertTrue(store.badgeMilestones.fullCatalog); XCTAssertTrue(store.badgeMilestones.allHighScores)
        XCTAssertFalse(store.isCompleted("risk-management"))
        let before = store.badgeMilestones; store.selectTrack(.airForce); XCTAssertEqual(store.badgeMilestones, before)
    }
    func testOriginalFourteenModuleAwardsRemainEarned() {
        let store = ProgressStore(defaults: defaults); store.selectTrack(.airForce)
        for module in store.catalog.modules where !OSHAExpansion.moduleIDs.contains(module.id) { store.markCompleted(moduleId: module.id, score: 90, scenarioPerfect: false, quizPerfect: false) }
        XCTAssertTrue(store.badgeMilestones.fullCatalog); XCTAssertTrue(store.badgeMilestones.allHighScores)
        let before = store.badgeMilestones; store.selectTrack(.osha); XCTAssertEqual(store.badgeMilestones, before)
    }
    func testExactCatalogSetsAndCounts() {
        let shared: Set<String> = ["loto", "fall-protection", "confined-space", "hearing-conservation", "ppe-decision", "hazcom", "electrical", "machine-guarding", "material-handling", "fire-hot-work", "wws", "ppeha", "rk", "eap", "resp"]
        XCTAssertEqual(ContentCatalog.visible(for: .osha).moduleIDs, shared)
        XCTAssertEqual(ContentCatalog.visible(for: .airForce).moduleIDs, shared.union(ContentCatalog.airForceOnly))
        XCTAssertEqual(ContentCatalog.visible(for: .osha).questions.count, 150)
        XCTAssertEqual(ContentCatalog.visible(for: .airForce).questions.count, 190)
    }
    func testDailyFiveAndCustomBuilderCannotReturnHiddenIDsEvenWithFullBank() {
        let store = ProgressStore(defaults: defaults); store.selectTrack(.osha)
        let bank = TrainingContent.allQuizQuestions + [OSHAExpansion.hotWorkQuestion]
        for _ in 0..<10 { XCTAssertTrue(Set(store.adaptiveRemediationPlan(from: bank).questions.map(\.id)).isSubset(of: store.catalog.questionIDs)) }
        XCTAssertTrue(Set(store.studyQuestions(for: StudyConfiguration(), from: bank).map(\.id)).isSubset(of: store.catalog.questionIDs))
        XCTAssertFalse(store.catalog.modules.contains { $0.title.localizedCaseInsensitiveContains("deployed") })
    }
    func testHiddenResumeIsPreservedUntilUserRestarts() {
        let store = ProgressStore(defaults: defaults); store.selectTrack(.airForce)
        XCTAssertTrue(store.startStudySession(configuration: StudyConfiguration(moduleIDs: ["risk-management"]), questions: store.catalog.questions))
        let id = store.activeStudySession?.id
        store.selectTrack(.osha); XCTAssertTrue(store.hasHiddenSession); XCTAssertEqual(store.activeStudySession?.id, id)
        XCTAssertFalse(store.studySessionIsValid(questions: store.catalog.questions))
        store.selectTrack(.airForce); XCTAssertFalse(store.hasHiddenSession)
        store.selectTrack(.osha); store.restartHiddenSession(); XCTAssertNil(store.activeStudySession)
    }
    func testOSHAOnboardingPathAndLibrary() {
        let catalog = ContentCatalog.visible(for: .osha)
        XCTAssertEqual(catalog.onboardingDays.compactMap { day -> String? in if case let .module(id) = day.action { return id }; return nil }, ["ppeha", "wws", "loto", "hazcom", "electrical", "eap", "rk"])
        XCTAssertFalse(catalog.showsDAFTools)
        XCTAssertTrue(Set(catalog.questions.compactMap { $0.reference?.title }).isSubset(of: Set(catalog.standards.map(\.title))))
        for section in ["1904.35", "1904.40", "1904.41", "1910.135", "1910.136"] { XCTAssertTrue(catalog.standards.contains { $0.title == "29 CFR \(section)" }) }
    }
}
final class ContentIntegrityTests: XCTestCase {
    func testUniqueBankAndEntryCoverage() {
        let bank = TrainingContent.allQuizQuestions + [OSHAExpansion.hotWorkQuestion]
        XCTAssertEqual(bank.count, 191); XCTAssertEqual(Set(bank.map(\.id)).count, bank.count)
        XCTAssertEqual(Set(QuestionExplanations.entries.keys), Set(bank.map(\.id)))
        XCTAssertTrue(Set(bank.map(\.id)).isDisjoint(with: QuestionExplanations.retiredQuestionIDs))
        let choices = bank.flatMap(\.choices); XCTAssertEqual(Set(choices.map(\.id)).count, choices.count)
        for q in bank { XCTAssertEqual(q.choices.count, 4, q.id); XCTAssertEqual(q.choices.filter(\.isCorrect).count, 1, q.id); XCTAssertEqual(q.reference?.url.scheme, "https", q.id) }
        for track in Track.allCases { for m in ContentCatalog.visible(for: track).modules { XCTAssertEqual(m.quiz.count, 10, m.id) } }
    }
    func testOSHAReferencesAndParagraphDepth() {
        for q in ContentCatalog.visible(for: .osha).questions {
            XCTAssertNotNil(q.reference?.title.range(of: #"^29 CFR (1910|1904)\."#, options: .regularExpression), q.id)
            XCTAssertEqual(q.reference?.url.host, "www.ecfr.gov", q.id)
            XCTAssertFalse(q.reference?.section.isEmpty ?? true, q.id)
        }
        for q in OSHAExpansion.decisions {
            XCTAssertNotNil(q.paragraph.range(of: #"^\([a-z]\)\(\d+\)"#, options: .regularExpression), q.id)
            XCTAssertEqual(q.entry.reference.url.fragment, "p-\(q.section)\(q.paragraph)")
        }
    }
    func testEveryOSHAContentSurfaceIsNeutral() {
        let catalog = ContentCatalog.visible(for: .osha)
        var strings = [String]()
        for m in catalog.modules {
            strings += [m.title, m.subtitle] + m.tags + m.objectives
            strings += m.lessonPages.flatMap { [$0.title] + $0.bullets }
            strings += [m.scenario.title, m.scenario.intro] + m.scenario.steps.flatMap { [$0.prompt] + $0.options.flatMap { [$0.text, $0.feedback] } }
            strings += m.quiz.flatMap { [$0.id, $0.prompt, $0.explanation] + $0.choices.map(\.text) }
        }
        strings += catalog.glossary.flatMap { [$0.displayTitle, $0.definition, $0.fieldUse, $0.sourceCitation] }
        strings += catalog.onboardingDays.flatMap { [$0.title, $0.summary] + $0.tasks }
        strings += catalog.lookupQuestions.flatMap { [$0.violationDescription, $0.correctCitation, $0.explanation] + $0.distractors }
        strings += catalog.ppeScenarios.flatMap { [$0.title, $0.location, $0.description] + $0.hazards + Array($0.debriefNotes.values) }
        for value in strings { XCTAssertFalse(ContentCatalog.containsAFText(value), value) }
    }
    func testNewPointsMatchReviewedFixture() throws {
        let url = try XCTUnwrap(Bundle(for: Self.self).url(forResource: "osha18-points", withExtension: "json"))
        let points = try XCTUnwrap(JSONSerialization.jsonObject(with: Data(contentsOf: url)) as? [[String: String]])
        XCTAssertEqual(points.count, 51)
        for item in OSHAExpansion.decisions { XCTAssertTrue(points.contains { $0["id"] == item.id && $0["section"] == item.section && $0["paragraph"] == item.paragraph && $0["point"] == item.explanation }) }
        let excluded = ["1910.28(b)(1)", "1910.29(b)(1)", "1910.29(e)", "1910.132(a)", "1910.132(d)", "1910.132(e)", "1910.132(f)", "1910.132(h)", "1910.134(d)", "1910.134(e)", "1910.134(f)", "1910.134(k)", "1910.157(c)(1)", "1910.157(e)", "1910.37(a)(3)", "1904.7(a)", "1904.7(b)", "1904.8"]
        for item in OSHAExpansion.decisions { XCTAssertFalse(excluded.contains(item.section + item.paragraph), item.id) }
    }
}
final class BrandingTests: XCTestCase {
    func testDisplayNameAndDisclaimer() {
        XCTAssertEqual(AppBrand.name, "SafetyXP")
        XCTAssertEqual(Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String, AppBrand.name)
        for term in ["Department of the Air Force", "U.S. Air Force", "Department of Defense", "OSHA", "ISO"] { XCTAssertTrue(AppBrand.disclaimer.contains(term)) }
    }
}
final class HazardReportTests: XCTestCase {
    func testAllMatrixCells() {
        let expected = [["Critical", "Critical", "High", "Medium"], ["Critical", "High", "Medium", "Low"], ["High", "Medium", "Medium", "Low"], ["Medium", "Low", "Low", "Low"]]
        for (row, severity) in ReportSeverity.allCases.enumerated() { for (col, likelihood) in HazardLikelihood.allCases.enumerated() { XCTAssertEqual(ExampleRiskMatrix.risk(severity, likelihood).rawValue, expected[row][col]) } }
    }
    func testSaveLoadDeleteAndNeutralExport() throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: directory) }
        let store = LocalHazardReportStore(directory: directory)
        var report = LocalHazardReport(); report.location = "Warehouse"; report.description = "Damaged floor"; report.controlTypes = ["Engineering"]
        try store.save(report); let reloaded = LocalHazardReportStore(directory: directory)
        XCTAssertEqual(reloaded.reports, [report]); XCTAssertFalse(ContentCatalog.containsAFText(report.exportText))
        XCTAssertTrue(report.pdfData().starts(with: Data("%PDF".utf8)))
        try reloaded.delete(report.id); XCTAssertTrue(LocalHazardReportStore(directory: directory).reports.isEmpty)
        try store.save(report); try store.deleteAll(); XCTAssertTrue(LocalHazardReportStore(directory: directory).reports.isEmpty)
    }
    func testLongReportPDFKeepsLastPage() throws {
        var report = LocalHazardReport()
        report.description = String(repeating: "Inspect, correct, and verify the stated hazard. ", count: 500)
        report.correctiveAction = "FINAL-CONTROL-MARKER"
        let pdf = try XCTUnwrap(PDFDocument(data: report.pdfData()))
        XCTAssertGreaterThan(pdf.pageCount, 1)
        XCTAssertTrue((0..<pdf.pageCount).compactMap { pdf.page(at: $0)?.string }.joined().contains("FINAL-CONTROL-MARKER"))
    }
    func testUnreadableFileIsNotOverwrittenBySave() throws {
        let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true); defer { try? FileManager.default.removeItem(at: dir) }
        let url = dir.appendingPathComponent("hazard_reports_v1.json"), bytes = Data("bad".utf8); try bytes.write(to: url)
        let store = LocalHazardReportStore(directory: dir); XCTAssertNotNil(store.errorMessage)
        XCTAssertThrowsError(try store.save(LocalHazardReport())); XCTAssertEqual(try Data(contentsOf: url), bytes)
    }
}
