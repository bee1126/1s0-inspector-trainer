import Foundation

enum AppBrand {
    static let name = "SafetyXP" // One-line fallback: "InspectXP".
    static let storeName = "\(name): Inspector Training"
    static let about = "\(storeName). Built by Abdoul Bah, independent developer."
    static let disclaimer = "\(name) is an independent study aid made by an individual developer. It is not affiliated with, endorsed by, or an official product of the Department of the Air Force, the U.S. Air Force, the Department of Defense, OSHA or the U.S. Department of Labor, or ISO. It is not an OSHA Outreach Training Program course and does not issue OSHA 10/30 cards or any certification. Content paraphrases public standards and publications; always follow your employer's or unit's procedures and the most current official text."
}

enum Track: String, Codable, CaseIterable, Identifiable {
    case osha, airForce
    var id: String { rawValue }
    var title: String { self == .osha ? "OSHA / Civilian" : "Air Force (1S0)" }
    var detail: String { self == .osha ? "General industry, 29 CFR 1910 and 1904." : "OSHA plus DAF instructions." }
}

/// The only track visibility boundary. Source banks and stored progress are never pruned.
struct ContentCatalog {
    let track: Track
    let modules: [TrainingModule]
    var questions: [QuizQuestion] { modules.flatMap(\.quiz) }
    var questionIDs: Set<String> { Set(questions.map(\.id)) }
    var moduleIDs: Set<String> { Set(modules.map(\.id)) }
    static let airForceOnly: Set<String> = ["risk-management", "roles-responsibilities", "mishap-reporting", "deployed-orm"]
    static let bannedPattern = #"\b(DAF|DAFI|DAFMAN|DAFPAM|AFI|AFMAN|USAF|Air Force|AFSEC|SAFEREP|457|RAC|ORM|MAJCOM|squadron|commander|deployed|Airman|e-Pubs|1S0)\b"#
    static func containsAFText(_ text: String) -> Bool { text.range(of: bannedPattern, options: [.regularExpression, .caseInsensitive]) != nil }

    static func visible(for track: Track) -> ContentCatalog {
        let modules = TrainingContent.modules.filter { $0.tracks.contains(track) }.map { source in
            var module = source
            var bank = source.quiz
            if source.id == "fire-hot-work" { bank += [OSHAExpansion.hotWorkQuestion] }
            module = TrainingModule(id: source.id, title: source.title, subtitle: source.subtitle,
                estimatedMinutes: source.estimatedMinutes, difficulty: source.difficulty, tags: source.tags,
                objectives: source.objectives, lessonPages: source.lessonPages, scenario: source.scenario,
                quiz: bank.filter { ($0.tracks ?? source.tracks).contains(track) }.map { question in
                    guard track == .osha else { return question }
                    var result = QuizQuestion(id: question.id, prompt: QuizBank.oshaTextOverrides[question.id] ?? question.prompt,
                        difficulty: question.difficulty, imageName: question.imageName,
                        choices: question.choices.map { QuizChoice(id: $0.id, text: QuizBank.oshaTextOverrides[$0.id] ?? $0.text, isCorrect: $0.isCorrect) })
                    result.tracks = question.tracks
                    return result
                }, tracks: source.tracks)
            // The legacy lessons/scenarios include DAF citations even in shared modules.
            // OSHA editions use the same reviewed, neutral decision points as their quizzes.
            if track == .osha && !OSHAExpansion.moduleIDs.contains(module.id) {
                module = neutralModule(module)
            }
            return module
        }
        return ContentCatalog(track: track, modules: modules)
    }
    private static func neutralModule(_ m: TrainingModule) -> TrainingModule {
        let pages = stride(from: 0, to: m.quiz.count, by: 2).map { index in
            LessonPage(id: "\(m.id)-osha-\(index)", title: index == 0 ? "Decisions in context" : "Apply the standard",
                       bullets: Array(m.quiz[index..<min(index + 2, m.quiz.count)]).map { $0.explanation })
        }
        let q = m.quiz[0]
        let scenario = Scenario(title: "\(m.title): inspection decision", intro: "Use the facts provided and check the cited standard before applying the decision at work.", startStepId: "decision", steps: [ScenarioStep(id: "decision", prompt: q.prompt, options: q.choices.map { ScenarioOption(id: $0.id, text: $0.text, feedback: q.explanation, isCorrect: $0.isCorrect, nextStepId: nil) })])
        return TrainingModule(id: m.id, title: m.title, subtitle: m.subtitle, estimatedMinutes: m.estimatedMinutes, difficulty: m.difficulty,
            tags: Array(Set(m.quiz.compactMap { $0.reference?.title })).sorted(), objectives: ["Recognize the relevant hazard", "Choose controls for the actual conditions", "Check the applicable general-industry standard"], lessonPages: pages, scenario: scenario, quiz: m.quiz, tracks: m.tracks)
    }
    var onboardingDays: [OnboardingDay] {
        guard track == .osha else { return PracticeContent.onboardingDays(for: .oneS0) }
        return ["ppeha", "wws", "loto", "hazcom", "electrical", "eap", "rk"].enumerated().compactMap { index, id in
            guard let module = modules.first(where: { $0.id == id }) else { return nil }
            return OnboardingDay(id: index + 1, title: module.title, summary: index == 6 ? "Complete Recordkeeping, then run a mixed Daily Five review." : module.subtitle,
                tasks: ["Read the lesson and work through its decisions", index == 6 ? "Finish with a mixed Daily Five review" : "Review explanations and references"], action: .module(id))
        }
    }
    var glossary: [GlossaryTerm] {
        GlossaryContent.terms.filter { term in
            track == .airForce || (!Self.containsAFText([term.displayTitle, term.definition, term.fieldUse, term.sourceCitation, term.category.rawValue].joined(separator: " ")) && (term.sourceCitation.contains("1910") || term.sourceCitation.contains("1904")))
        }
    }
    var lookupQuestions: [CodeLookupQuestion] {
        guard track == .osha else { return CodeLookupContent.questions }
        return questions.compactMap { q in
            guard let reference = q.reference else { return nil }
            let alternatives = standards.filter { $0.title != reference.title }.prefix(3).map(\.title)
            return CodeLookupQuestion(id: "lookup-\(q.id)", violationDescription: q.prompt + " Which section governs this decision?", category: ModuleHelper.moduleID(for: q.id), correctCitation: reference.title, correctTitle: reference.section, distractors: alternatives, explanation: q.explanation)
        }
    }
    var standards: [QuestionReference] {
        // Include citations in lessons, glossary and field tools, not just the quiz bank.
        let text = (modules.flatMap { $0.lessonPages.flatMap(\.bullets) } + glossary.map(\.sourceCitation)
            + ppeScenarios.flatMap { Array($0.debriefNotes.values) }).joined(separator: " ")
        let regex = try! NSRegularExpression(pattern: #"\b(?:1910|1904)\.\d+\b"#)
        var sections = Set(questions.compactMap { $0.reference?.title.replacingOccurrences(of: "29 CFR ", with: "") }.filter { $0.hasPrefix("1910.") || $0.hasPrefix("1904.") })
        for match in regex.matches(in: text, range: NSRange(text.startIndex..., in: text)) {
            if let range = Range(match.range, in: text) { sections.insert(String(text[range])) }
        }
        if track == .osha { sections.formUnion(["1910.135", "1910.136", "1910.138"]) }
        return sections.sorted { $0.localizedStandardCompare($1) == .orderedAscending }.map {
            QuestionReference(title: "29 CFR \($0)", section: "Full section", url: URL(string: "https://www.ecfr.gov/current/title-29/section-\($0)")!)
        }
    }
    func dailyLesson(on date: Date = Date(), calendar: Calendar = .current) -> DailyLesson {
        if track == .airForce { return DailyLessonBank.lessonForToday() }
        let question = questions[(calendar.ordinality(of: .day, in: .era, for: date) ?? 0) % questions.count]
        return DailyLesson(id: "osha-daily-\(question.id)", moduleTag: modules.first { $0.quiz.contains(question) }?.title ?? "Daily review", title: "A decision worth reviewing", subtitle: question.prompt, icon: "book", keyPoints: [question.explanation], regulation: question.reference.map { "\($0.title) \($0.section)" }, proTip: "Check current requirements and your employer's procedures before use.")
    }
    func progressStage(for completed: Int) -> String {
        switch completed {
        case 0: return "Trainee"
        case 1...2: return track == .airForce ? "Airman" : "Learner"
        case 3...5: return "Inspector"
        case 6...8: return "Lead Inspector"
        default: return "Safety Advisor"
        }
    }
    var ppeScenarios: [PPEScenario] { track == .airForce ? PPELoadoutBank.allScenarios : Self.civilianPPE }
    var showsDAFTools: Bool { track == .airForce }
    static let civilianPPE = [
        PPEScenario(id: "osha-ppe-splash", title: "Transfer a cleaning solution", location: "Maintenance room", description: "A trained employee transfers a nonvolatile corrosive solution. The assessment identifies hand and eye splash exposure, with possible face splash. Ventilation controls airborne exposure; there is no assessed respiratory, foot, head, or noise hazard.", hazards: ["Corrosive splash to hands, eyes, and face"], requiredItemIds: ["chemical-gloves", "chemical-goggles", "face-shield"], availableItemIds: ["chemical-gloves", "chemical-goggles", "face-shield", "respirator", "hard-hat", "earplugs"], debriefNotes: ["chemical-gloves": "29 CFR 1910.138(b): select chemical-resistant gloves for the solution, contact time, and task.", "chemical-goggles": "29 CFR 1910.133(a)(1): suitable eye protection must address the assessed splash.", "face-shield": "29 CFR 1910.132(d)(1): use the assessed face protection over splash goggles; a shield alone does not provide the selected eye protection."]),
        PPEScenario(id: "osha-ppe-warehouse", title: "Inspect an active loading area", location: "Warehouse", description: "The task assessment identifies falling objects above the inspection path, heavy stock that could strike feet, and flying particles from adjacent work. Employees have an established baseline audiogram and no threshold shift, but exposure is 95 dBA TWA after feasible controls; the hearing assessment selects properly fitted earplugs with adequate attenuation.", hazards: ["Falling objects", "Foot impact", "Flying particles", "Noise"], requiredItemIds: ["hard-hat", "steel-toe-boots", "safety-glasses", "earplugs"], availableItemIds: ["hard-hat", "steel-toe-boots", "safety-glasses", "earplugs", "scba", "chemical-gloves"], debriefNotes: ["hard-hat": "29 CFR 1910.135(a)(1): use head protection for the stated falling-object hazard.", "steel-toe-boots": "29 CFR 1910.136(a): protective footwear addresses the assessed foot impact hazard.", "safety-glasses": "29 CFR 1910.133(a)(1): eye protection addresses flying particles.", "earplugs": "29 CFR 1910.95(b)(1), (i)(2), and (j): required hearing protection must provide suitable attenuation; verify fit and exposure."])
    ]
}

extension QuizBank {
    static let oshaTextOverrides: [String: String] = [
        "fire-hot-work-q101-a": "Maintain a fire watch during work and for at least 30 minutes afterward; applicable fire-code or local requirements may require longer."
    ]
}
