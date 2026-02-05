import Foundation

extension TrainingModule {
    func tailored(for role: TrainingRole) -> TrainingModule {
        guard role != .oneS0 else { return self }

        let updatedLessonPages = lessonPages.enumerated().map { index, page in
            if index == 0 {
                return LessonPage(
                    id: page.id,
                    title: page.title,
                    bullets: [role.lessonContext] + page.bullets
                )
            }
            return page
        }

        let updatedScenario = Scenario(
            title: scenario.title,
            intro: role.scenarioIntroPrefix + scenario.intro,
            startStepId: scenario.startStepId,
            steps: scenario.steps
        )

        let updatedQuiz = quiz.map { question in
            QuizQuestion(
                id: question.id,
                prompt: role.quizPromptPrefix + question.prompt,
                difficulty: question.difficulty,
                imageName: question.imageName,
                choices: question.choices
            )
        }

        let updatedObjectives = [role.objectivePrefix] + objectives

        return TrainingModule(
            id: id,
            title: title,
            subtitle: "\(subtitle) • \(role.shortName) program",
            estimatedMinutes: estimatedMinutes,
            difficulty: difficulty,
            tags: tags,
            objectives: updatedObjectives,
            lessonPages: updatedLessonPages,
            scenario: updatedScenario,
            quiz: updatedQuiz
        )
    }
}
