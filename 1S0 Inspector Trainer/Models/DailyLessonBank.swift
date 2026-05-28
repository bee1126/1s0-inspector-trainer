import Foundation

struct DailyLesson: Identifiable {
    let id: String
    let moduleTag: String
    let title: String
    let subtitle: String
    let icon: String
    let keyPoints: [String]
    let regulation: String?
    let proTip: String
}

enum DailyLessonBank {

    static let lessons: [DailyLesson] = [

        // MARK: - LOTO

        DailyLesson(
            id: "dl-loto-01",
            moduleTag: "Lockout / Tagout",
            title: "Tags Are Warnings, Not Barriers",
            subtitle: "Why a tag alone may not be enough",
            icon: "tag.fill",
            keyPoints: [
                "A tag is a warning device — it does not physically prevent re-energization.",
                "Tags must be supplemented with at least one additional safety measure when locks cannot be used.",
                "Always try to use a lock first. Tags are a last resort, not a convenience."
            ],
            regulation: "OSHA 1910.147(c)(3)",
            proTip: "If you see a tag without a lock, ask 'why?' — the answer should reference a documented exception, not habit."
        ),

        DailyLesson(
            id: "dl-loto-02",
            moduleTag: "Lockout / Tagout",
            title: "The Try-Out Step",
            subtitle: "Verification is the most skipped step",
            icon: "bolt.slash.fill",
            keyPoints: [
                "After applying locks and releasing stored energy, you must verify zero energy before starting work.",
                "Try the normal operating controls — they should not activate the equipment.",
                "Return controls to the off position after verification to prevent unexpected start-up."
            ],
            regulation: "OSHA 1910.147(d)(6)",
            proTip: "Think of the try-out as a 10-second insurance policy. It costs nothing and catches everything."
        ),

        DailyLesson(
            id: "dl-loto-03",
            moduleTag: "Lockout / Tagout",
            title: "Group Lockout Pitfalls",
            subtitle: "Multiple workers, one procedure",
            icon: "person.3.fill",
            keyPoints: [
                "Each authorized worker must attach their own personal lock to maintain individual control.",
                "A designated coordinator ensures continuity when the crew changes between shifts.",
                "Never assume someone else's lock protects you — personal accountability is non-negotiable."
            ],
            regulation: "OSHA 1910.147(f)(3)",
            proTip: "During shift handoff, both crews should be present. The outgoing lock comes off only after the incoming lock goes on."
        ),

        // MARK: - Fall Protection

        DailyLesson(
            id: "dl-fall-01",
            moduleTag: "Fall Protection",
            title: "The 6-Foot Trigger",
            subtitle: "When does fall protection kick in?",
            icon: "arrow.down.to.line",
            keyPoints: [
                "General industry requires fall protection at 4 feet; construction at 6 feet.",
                "Leading edges, holes, and unprotected sides all qualify as fall hazards.",
                "The trigger height is measured from the working surface to the level below."
            ],
            regulation: "OSHA 1910.28 / 1926.501",
            proTip: "Don't measure from the ground — measure from where the person would land. A 3-foot platform over a 10-foot pit is a fall hazard."
        ),

        DailyLesson(
            id: "dl-fall-02",
            moduleTag: "Fall Protection",
            title: "Guardrails vs. Personal Fall Arrest",
            subtitle: "Choosing the right system",
            icon: "shield.lefthalf.filled",
            keyPoints: [
                "Guardrails are passive — they protect without worker action.",
                "Personal fall arrest systems require training, inspection, and correct attachment.",
                "Hierarchy of controls favors elimination first, then guardrails, then personal systems."
            ],
            regulation: "OSHA 1910.29",
            proTip: "If a guardrail can do the job, prefer it. Passive protection beats active protection every time."
        ),

        DailyLesson(
            id: "dl-fall-03",
            moduleTag: "Fall Protection",
            title: "Total Fall Distance",
            subtitle: "Your lanyard length is not your fall distance",
            icon: "ruler",
            keyPoints: [
                "Total fall distance = free fall + deceleration distance + harness stretch + safety margin.",
                "A standard 6-foot lanyard with deceleration device needs roughly 18.5 feet of clearance.",
                "Retractable lifelines reduce free-fall distance but still need swing clearance."
            ],
            regulation: "OSHA 1926.502(d)",
            proTip: "Always calculate total fall distance before tying off. A lanyard that arrests your fall 2 feet into the floor didn't protect you."
        ),

        // MARK: - Risk Management

        DailyLesson(
            id: "dl-risk-01",
            moduleTag: "Risk Management",
            title: "Severity vs. Probability",
            subtitle: "Two axes of every risk decision",
            icon: "chart.bar.xaxis",
            keyPoints: [
                "Severity asks: 'How bad could it be?' — from negligible to catastrophic.",
                "Probability asks: 'How likely is it?' — from unlikely to frequent.",
                "A risk matrix combines both to determine whether the risk is acceptable, needs mitigation, or is unacceptable."
            ],
            regulation: "DAFPAM 90-803",
            proTip: "High-severity, low-probability events are the most commonly under-managed. Rare does not mean safe."
        ),

        DailyLesson(
            id: "dl-risk-02",
            moduleTag: "Risk Management",
            title: "Residual Risk",
            subtitle: "What's left after you mitigate",
            icon: "circle.bottomhalf.filled",
            keyPoints: [
                "No control eliminates risk entirely — the remaining risk after mitigation is residual risk.",
                "Residual risk must be formally accepted by the appropriate authority level.",
                "If residual risk is still high, add more controls or escalate the decision."
            ],
            regulation: "DAFPAM 90-803",
            proTip: "Document what residual risk you accepted and why. Future auditors (and you) will thank you."
        ),

        DailyLesson(
            id: "dl-risk-03",
            moduleTag: "Risk Management",
            title: "The Hierarchy of Controls",
            subtitle: "Not all controls are created equal",
            icon: "arrow.up.arrow.down",
            keyPoints: [
                "Elimination removes the hazard entirely — always the first option to consider.",
                "Engineering controls (guards, ventilation) are preferred over administrative ones (signs, training).",
                "PPE is the last line of defense, not the first solution."
            ],
            regulation: nil,
            proTip: "When someone jumps straight to PPE, ask: 'Did we consider engineering it out first?'"
        ),

        // MARK: - Confined Space

        DailyLesson(
            id: "dl-confined-01",
            moduleTag: "Confined Space",
            title: "What Makes a Space 'Confined'?",
            subtitle: "Three criteria every inspector must know",
            icon: "square.dashed",
            keyPoints: [
                "Large enough for a worker to enter and perform work.",
                "Has limited or restricted means of entry or exit.",
                "Is not designed for continuous occupancy."
            ],
            regulation: "OSHA 1910.146(b)",
            proTip: "A space doesn't have to be small to be confined. Large tanks and silos qualify if they meet all three criteria."
        ),

        DailyLesson(
            id: "dl-confined-02",
            moduleTag: "Confined Space",
            title: "Atmospheric Testing Order",
            subtitle: "Oxygen first, then flammables, then toxics",
            icon: "aqi.medium",
            keyPoints: [
                "Test oxygen first — combustible gas readings are unreliable in oxygen-deficient atmospheres.",
                "Test flammable gases and vapors second.",
                "Test for toxic contaminants last, based on what substances may be present."
            ],
            regulation: "OSHA 1910.146(c)(5)",
            proTip: "Continuous monitoring beats one-time testing. Conditions inside a confined space can change fast."
        ),

        DailyLesson(
            id: "dl-confined-03",
            moduleTag: "Confined Space",
            title: "The Attendant's Job",
            subtitle: "Eyes on the entry, no exceptions",
            icon: "eye.fill",
            keyPoints: [
                "The attendant monitors entrants and conditions from outside the space.",
                "They must never enter the space, even to attempt a rescue.",
                "The attendant controls access and summons rescue services when needed."
            ],
            regulation: "OSHA 1910.146(d)(6)",
            proTip: "Over 60% of confined-space fatalities are would-be rescuers. The attendant stays outside — that's the rule that saves lives."
        ),

        // MARK: - Hearing Conservation

        DailyLesson(
            id: "dl-hearing-01",
            moduleTag: "Hearing Conservation",
            title: "The 85 dBA Action Level",
            subtitle: "When the program kicks in",
            icon: "ear.fill",
            keyPoints: [
                "An 8-hour TWA of 85 dBA triggers the hearing conservation program.",
                "This includes monitoring, audiometric testing, hearing protector availability, and training.",
                "The permissible exposure limit (PEL) is 90 dBA — but the action level matters more for prevention."
            ],
            regulation: "OSHA 1910.95(c)",
            proTip: "If you have to raise your voice to talk to someone 3 feet away, you're probably at or above 85 dBA."
        ),

        DailyLesson(
            id: "dl-hearing-02",
            moduleTag: "Hearing Conservation",
            title: "NRR: Real-World Derating",
            subtitle: "The label number is not the protection you get",
            icon: "minus.circle",
            keyPoints: [
                "NRR (Noise Reduction Rating) is tested in a lab — real-world performance is lower.",
                "OSHA Appendix B subtracts 7 dB from the NRR when estimating attenuation from A-weighted measurements.",
                "Proper fit matters more than the rated number on the package."
            ],
            regulation: "OSHA 1910.95(j)",
            proTip: "A 33 NRR earplug poorly inserted might give you less protection than a 25 NRR plug with a perfect seal."
        ),

        DailyLesson(
            id: "dl-hearing-03",
            moduleTag: "Hearing Conservation",
            title: "Baseline Audiograms",
            subtitle: "The benchmark everything is compared to",
            icon: "waveform.path.ecg",
            keyPoints: [
                "A baseline audiogram must be established within 6 months of first exposure (1 year if using mobile testing).",
                "Workers must have 14 hours of quiet time before the baseline test.",
                "Annual audiograms are compared to the baseline to detect standard threshold shifts."
            ],
            regulation: "OSHA 1910.95(g)",
            proTip: "If the baseline wasn't done right, every future comparison is suspect. Get it right the first time."
        ),

        // MARK: - Mishap Reporting

        DailyLesson(
            id: "dl-mishap-01",
            moduleTag: "Mishap Reporting",
            title: "Class A Through E",
            subtitle: "Severity determines the reporting timeline",
            icon: "exclamationmark.triangle.fill",
            keyPoints: [
                "Class A: fatality, permanent total disability, or $2.5M+ damage — report immediately.",
                "Class B: permanent partial disability or $600K–$2.5M damage.",
                "Classes C through E cover progressively lower severity with longer reporting windows."
            ],
            regulation: "DAFI 91-204",
            proTip: "When in doubt, report at the higher class. It's easier to downgrade than to explain why you under-reported."
        ),

        DailyLesson(
            id: "dl-mishap-02",
            moduleTag: "Mishap Reporting",
            title: "Near-Miss Value",
            subtitle: "The mishap that didn't happen — this time",
            icon: "exclamationmark.circle",
            keyPoints: [
                "A near-miss is an event that could have caused injury or damage but didn't.",
                "Reporting near-misses reveals hazards before someone gets hurt.",
                "Organizations with high near-miss reporting rates tend to have lower actual mishap rates."
            ],
            regulation: nil,
            proTip: "Treat every near-miss as a free lesson. The next time, you might not be as lucky."
        ),

        DailyLesson(
            id: "dl-mishap-03",
            moduleTag: "Mishap Reporting",
            title: "Preservation of Evidence",
            subtitle: "Don't clean up before documenting",
            icon: "camera.fill",
            keyPoints: [
                "Secure the scene and restrict access until investigators arrive.",
                "Photograph everything from multiple angles before anything is moved.",
                "Document witness statements while memory is fresh — delay degrades accuracy."
            ],
            regulation: "DAFI 91-204",
            proTip: "A 5-minute photo walkthrough of the scene can save weeks of investigation guesswork."
        ),

        // MARK: - Program Responsibilities

        DailyLesson(
            id: "dl-roles-01",
            moduleTag: "Program Responsibilities",
            title: "Commander's Safety Responsibility",
            subtitle: "Safety starts at the top",
            icon: "star.circle.fill",
            keyPoints: [
                "The installation commander is ultimately responsible for the safety program.",
                "Commanders set the tone — if leadership tolerates shortcuts, so will the workforce.",
                "Resources (funding, staffing, equipment) must be allocated to sustain the program."
            ],
            regulation: "DAFMAN 91-203",
            proTip: "When leadership walks through the shop, watch what they look at. That's what the workforce will prioritize."
        ),

        DailyLesson(
            id: "dl-roles-02",
            moduleTag: "Program Responsibilities",
            title: "The 1S0 Inspector's Lane",
            subtitle: "What's yours and what isn't",
            icon: "person.badge.shield.checkmark.fill",
            keyPoints: [
                "Inspectors identify hazards, assess compliance, and recommend corrective actions.",
                "You advise — you do not direct. The commander decides how to allocate resources.",
                "Your credibility depends on consistent, fair, standards-based assessments."
            ],
            regulation: nil,
            proTip: "Document findings the same way whether it's the commander's office or the janitor's closet. Consistency builds trust."
        ),

        DailyLesson(
            id: "dl-roles-03",
            moduleTag: "Program Responsibilities",
            title: "Supervisor Accountability",
            subtitle: "First-line defense in the workplace",
            icon: "person.badge.clock",
            keyPoints: [
                "Supervisors are responsible for enforcing safety rules at the work level.",
                "They must ensure workers are trained, equipped, and following procedures.",
                "A supervisor who sees a hazard and does nothing has accepted the risk on behalf of their people."
            ],
            regulation: "DAFMAN 91-203",
            proTip: "During inspections, ask supervisors to explain their hazards. Their awareness level tells you more than any checklist."
        ),

        // MARK: - PPE

        DailyLesson(
            id: "dl-ppe-01",
            moduleTag: "PPE Decision Making",
            title: "Hazard Assessment First",
            subtitle: "PPE follows the assessment, not the other way around",
            icon: "checklist",
            keyPoints: [
                "A written hazard assessment of the workplace must be completed before selecting PPE.",
                "The assessment identifies the hazards present and the body parts at risk.",
                "PPE is matched to the specific hazards — one size does not fit all."
            ],
            regulation: "OSHA 1910.132(d)",
            proTip: "If someone can't tell you which hazard their PPE protects against, the assessment wasn't communicated well enough."
        ),

        DailyLesson(
            id: "dl-ppe-02",
            moduleTag: "PPE Decision Making",
            title: "Fit and Condition Checks",
            subtitle: "The PPE you don't inspect can't protect you",
            icon: "wrench.and.screwdriver",
            keyPoints: [
                "PPE must fit the individual worker — ill-fitting gear reduces or eliminates protection.",
                "Inspect PPE before each use for cracks, tears, degradation, or expired components.",
                "Hard hats, safety glasses, and fall harnesses all have service life limits."
            ],
            regulation: "OSHA 1910.132(f)",
            proTip: "Hold a scratched lens up to the light. If you can't see clearly through it, neither can the worker."
        ),

        DailyLesson(
            id: "dl-ppe-03",
            moduleTag: "PPE Decision Making",
            title: "Employer Obligations",
            subtitle: "Who pays, who trains, who replaces",
            icon: "dollarsign.circle",
            keyPoints: [
                "Employers must provide required PPE at no cost to employees.",
                "Training on proper use, care, and limitations is mandatory before the worker uses the PPE.",
                "Damaged or defective PPE must be replaced — workers should never be expected to use compromised gear."
            ],
            regulation: "OSHA 1910.132(h)",
            proTip: "If a worker is wearing beat-up PPE, ask when they last requested a replacement. The answer reveals a lot about the program."
        ),
    ]

    /// Returns the lesson for today, rotating through the bank by day of year.
    static func lessonForToday() -> DailyLesson {
        let day = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let index = (day - 1) % lessons.count
        return lessons[index]
    }

    /// Returns the lesson for a specific date.
    static func lesson(for date: Date) -> DailyLesson {
        let day = Calendar.current.ordinality(of: .day, in: .year, for: date) ?? 1
        let index = (day - 1) % lessons.count
        return lessons[index]
    }
}
