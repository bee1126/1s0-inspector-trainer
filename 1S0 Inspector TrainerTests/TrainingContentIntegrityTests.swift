import XCTest
@testable import _S0_Inspector_Trainer

final class TrainingContentIntegrityTests: XCTestCase {
    private let expectedOneS0ModuleCount = 14
    private let expectedQuestionsPerModule = 10

    func testOneS0ModuleCountMatchesExpected() {
        XCTAssertEqual(TrainingContent.modules(for: .oneS0).count, expectedOneS0ModuleCount)
    }

    func testDefaultModulesMatchOneS0Modules() {
        XCTAssertEqual(TrainingContent.modules(for: nil).count, expectedOneS0ModuleCount)
    }

    func testStarterProgramCoversSevenDaysAndEndsWithDailyFive() {
        let starterPath = PracticeContent.onboardingDays(for: .oneS0)

        XCTAssertEqual(starterPath.count, 7)
        XCTAssertEqual(starterPath.map(\.id), Array(1...7))

        guard let finalAction = starterPath.last?.action else {
            return XCTFail("Expected a final onboarding action.")
        }

        switch finalAction {
        case .dailyFive:
            break
        case .module(let moduleID):
            XCTFail("Expected Daily Five as the final onboarding action, got module \(moduleID).")
        }
    }

    func testEveryModuleHasExpectedQuestionDepth() {
        let oneS0Modules = TrainingContent.modules(for: .oneS0)

        XCTAssertTrue(
            oneS0Modules.allSatisfy { $0.quiz.count == expectedQuestionsPerModule },
            "OneS0 modules with unexpected quiz depth: \(moduleDepthSummary(oneS0Modules))"
        )

        XCTAssertEqual(
            TrainingContent.allQuizQuestions(for: .oneS0).count,
            expectedOneS0ModuleCount * expectedQuestionsPerModule
        )
    }

    func testAllModulesHaveValidIntegrity() {
        let allModules = allModulesByRole.flatMap(\.modules)
        let invalidModules = allModules.filter { !$0.isIntegrityValid }

        XCTAssertTrue(
            invalidModules.isEmpty,
            "Invalid modules: \(invalidModules.map(\.id).joined(separator: ", "))"
        )
    }

    func testModuleIDsAreUniqueWithinEachRole() {
        for roleModules in allModulesByRole {
            let moduleIds = roleModules.modules.map(\.id)
            XCTAssertEqual(
                Set(moduleIds).count,
                moduleIds.count,
                "Duplicate module IDs in \(roleModules.roleName)."
            )
        }
    }

    func testQuizQuestionIDsAreUniqueAndWellFormed() {
        let oneS0Questions = TrainingContent.allQuizQuestions(for: .oneS0)

        XCTAssertEqual(Set(oneS0Questions.map(\.id)).count, oneS0Questions.count, "Duplicate OneS0 quiz IDs found.")

        for question in oneS0Questions {
            XCTAssertFalse(question.prompt.trimmed.isEmpty, "Question \(question.id) has an empty prompt.")
            XCTAssertEqual(question.choices.count, 4, "Question \(question.id) should have exactly 4 choices.")
            XCTAssertEqual(
                question.choices.filter(\.isCorrect).count,
                1,
                "Question \(question.id) should have exactly one correct choice."
            )
            XCTAssertEqual(
                Set(question.choices.map(\.id)).count,
                question.choices.count,
                "Question \(question.id) has duplicate choice IDs."
            )
            for choice in question.choices {
                XCTAssertFalse(choice.text.trimmed.isEmpty, "Choice \(choice.id) has empty text.")
            }

            let components = question.id.split(separator: "-")
            guard let last = components.last else {
                XCTFail("Question \(question.id) has malformed ID.")
                continue
            }
            let suffix = String(last)
            XCTAssertTrue(suffix.hasPrefix("q"), "Question \(question.id) should end with q<number>.")
            XCTAssertNotNil(Int(suffix.dropFirst()), "Question \(question.id) has invalid numeric suffix.")
        }
    }

    func testRequiredFieldsArePresentAndScenarioLinksAreValid() {
        for roleModules in allModulesByRole {
            for module in roleModules.modules {
                let prefix = "[\(roleModules.roleName):\(module.id)]"

                XCTAssertFalse(module.title.trimmed.isEmpty, "\(prefix) title is empty.")
                XCTAssertFalse(module.subtitle.trimmed.isEmpty, "\(prefix) subtitle is empty.")
                XCTAssertFalse(module.difficulty.trimmed.isEmpty, "\(prefix) difficulty is empty.")
                XCTAssertFalse(module.tags.isEmpty, "\(prefix) tags are empty.")
                XCTAssertTrue(module.tags.allSatisfy { !$0.trimmed.isEmpty }, "\(prefix) has blank tag values.")
                XCTAssertFalse(module.objectives.isEmpty, "\(prefix) objectives are empty.")
                XCTAssertTrue(module.objectives.allSatisfy { !$0.trimmed.isEmpty }, "\(prefix) has blank objective values.")

                XCTAssertFalse(module.lessonPages.isEmpty, "\(prefix) has no lesson pages.")
                XCTAssertEqual(
                    Set(module.lessonPages.map(\.id)).count,
                    module.lessonPages.count,
                    "\(prefix) has duplicate lesson page IDs."
                )
                for page in module.lessonPages {
                    XCTAssertFalse(page.id.trimmed.isEmpty, "\(prefix) lesson page has empty id.")
                    XCTAssertFalse(page.title.trimmed.isEmpty, "\(prefix) lesson page \(page.id) has empty title.")
                    XCTAssertFalse(page.bullets.isEmpty, "\(prefix) lesson page \(page.id) has no bullets.")
                    XCTAssertTrue(
                        page.bullets.allSatisfy { !$0.trimmed.isEmpty },
                        "\(prefix) lesson page \(page.id) contains blank bullet text."
                    )
                }

                XCTAssertFalse(module.scenario.title.trimmed.isEmpty, "\(prefix) scenario title is empty.")
                XCTAssertFalse(module.scenario.intro.trimmed.isEmpty, "\(prefix) scenario intro is empty.")
                XCTAssertFalse(module.scenario.startStepId.trimmed.isEmpty, "\(prefix) scenario start step is empty.")
                XCTAssertFalse(module.scenario.steps.isEmpty, "\(prefix) scenario has no steps.")

                let stepIds = module.scenario.steps.map(\.id)
                let stepIdSet = Set(stepIds)
                XCTAssertEqual(stepIdSet.count, stepIds.count, "\(prefix) has duplicate scenario step IDs.")
                XCTAssertTrue(stepIdSet.contains(module.scenario.startStepId), "\(prefix) startStepId is not present in steps.")

                for step in module.scenario.steps {
                    XCTAssertFalse(step.id.trimmed.isEmpty, "\(prefix) contains a scenario step with empty id.")
                    XCTAssertFalse(step.prompt.trimmed.isEmpty, "\(prefix) step \(step.id) has empty prompt.")
                    XCTAssertFalse(step.options.isEmpty, "\(prefix) step \(step.id) has no options.")
                    XCTAssertEqual(
                        step.options.filter(\.isCorrect).count,
                        1,
                        "\(prefix) step \(step.id) must have exactly one correct option."
                    )

                    let optionIds = step.options.map(\.id)
                    XCTAssertEqual(
                        Set(optionIds).count,
                        optionIds.count,
                        "\(prefix) step \(step.id) has duplicate option IDs."
                    )

                    for option in step.options {
                        XCTAssertFalse(option.id.trimmed.isEmpty, "\(prefix) step \(step.id) has option with empty id.")
                        XCTAssertFalse(option.text.trimmed.isEmpty, "\(prefix) step \(step.id) has option with empty text.")
                        XCTAssertFalse(option.feedback.trimmed.isEmpty, "\(prefix) step \(step.id) has option with empty feedback.")
                        if let nextStepId = option.nextStepId {
                            XCTAssertTrue(
                                stepIdSet.contains(nextStepId),
                                "\(prefix) step \(step.id) references missing nextStepId \(nextStepId)."
                            )
                        }
                    }
                }

                XCTAssertEqual(module.quiz.count, expectedQuestionsPerModule, "\(prefix) quiz depth mismatch.")
                XCTAssertEqual(
                    Set(module.quiz.map(\.id)).count,
                    module.quiz.count,
                    "\(prefix) has duplicate quiz IDs in module quiz set."
                )
            }
        }
    }

    private var allModulesByRole: [(roleName: String, modules: [TrainingModule])] {
        [
            (roleName: "OneS0", modules: TrainingContent.modules(for: .oneS0))
        ]
    }

    private func moduleDepthSummary(_ modules: [TrainingModule]) -> String {
        modules
            .filter { $0.quiz.count != expectedQuestionsPerModule }
            .map { "\($0.id)=\($0.quiz.count)" }
            .joined(separator: ", ")
    }
}

private extension String {
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
