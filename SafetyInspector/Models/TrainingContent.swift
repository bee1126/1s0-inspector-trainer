import Foundation

enum TrainingContent {
    static let modules: [TrainingModule] = [
        TrainingModule(
            id: "loto",
            title: "Lockout / Tagout",
            subtitle: "Control hazardous energy before servicing or maintenance",
            estimatedMinutes: 18,
            difficulty: "Core",
            tags: ["Energy Control", "OSHA 1910.147"],
            objectives: [
                "Explain when lockout/tagout is required",
                "Apply the OSHA sequence for isolating hazardous energy",
                "Verify zero energy before work begins",
                "Communicate with affected employees"
            ],
            lessonPages: [
                LessonPage(
                    id: "loto-1",
                    title: "Why It Matters",
                    bullets: [
                        "Unexpected start-up or stored energy release can cause severe injury or death.",
                        "Lockout/tagout (LOTO) protects workers during servicing and maintenance.",
                        "A written energy control procedure is required for equipment with hazardous energy."
                    ]
                ),
                LessonPage(
                    id: "loto-2",
                    title: "Who Is Involved",
                    bullets: [
                        "Authorized employees apply LOTO devices and perform the work.",
                        "Affected employees operate or use the equipment and must be notified.",
                        "Clear communication prevents accidental re-energizing."
                    ]
                ),
                LessonPage(
                    id: "loto-3",
                    title: "OSHA Sequence",
                    bullets: [
                        "Prepare: identify all energy sources and control points.",
                        "Shut down and isolate the equipment from energy sources.",
                        "Apply lockout/tagout devices and release stored energy.",
                        "Verify isolation before starting work (try-out)."
                    ]
                ),
                LessonPage(
                    id: "loto-4",
                    title: "Key Rules",
                    bullets: [
                        "Each authorized employee applies their own lock or tag.",
                        "Tags are warning devices and do not provide physical restraint.",
                        "Only the person who applied the lock should remove it unless a formal procedure is used."
                    ]
                )
            ],
            scenario: Scenario(
                title: "Conveyor Guard Replacement",
                intro: "You are inspecting a powered conveyor and need to replace a damaged guard. Production is waiting on your go-ahead.",
                startStepId: "step-1",
                steps: [
                    ScenarioStep(
                        id: "step-1",
                        prompt: "What is your first action?",
                        options: [
                            ScenarioOption(
                                id: "step-1-a",
                                text: "Notify affected employees and review the energy control procedure.",
                                feedback: "Correct. Communicate and confirm the LOTO plan before shutdown.",
                                isCorrect: true,
                                nextStepId: "step-2"
                            ),
                            ScenarioOption(
                                id: "step-1-b",
                                text: "Start removing the guard while the conveyor is stopped at the controls.",
                                feedback: "Not safe. Stopping at the controls is not isolation.",
                                isCorrect: false,
                                nextStepId: "step-2"
                            )
                        ]
                    ),
                    ScenarioStep(
                        id: "step-2",
                        prompt: "You shut down the conveyor. What next?",
                        options: [
                            ScenarioOption(
                                id: "step-2-a",
                                text: "Isolate all energy sources and apply your lock.",
                                feedback: "Correct. Isolation and personal control are required.",
                                isCorrect: true,
                                nextStepId: "step-3"
                            ),
                            ScenarioOption(
                                id: "step-2-b",
                                text: "Place a tag on the control panel and start work.",
                                feedback: "Incorrect. Tags alone do not isolate energy.",
                                isCorrect: false,
                                nextStepId: "step-3"
                            )
                        ]
                    ),
                    ScenarioStep(
                        id: "step-3",
                        prompt: "Before removing the guard, you should:",
                        options: [
                            ScenarioOption(
                                id: "step-3-a",
                                text: "Release stored energy and verify zero energy by try-out.",
                                feedback: "Correct. Stored energy can still injure you.",
                                isCorrect: true,
                                nextStepId: "step-4"
                            ),
                            ScenarioOption(
                                id: "step-3-b",
                                text: "Assume isolation is complete because your lock is on.",
                                feedback: "Not enough. You must verify isolation.",
                                isCorrect: false,
                                nextStepId: "step-4"
                            )
                        ]
                    ),
                    ScenarioStep(
                        id: "step-4",
                        prompt: "Work is complete. How do you restore equipment to service?",
                        options: [
                            ScenarioOption(
                                id: "step-4-a",
                                text: "Clear tools, remove your lock, and notify affected employees before restart.",
                                feedback: "Correct. Restore safely and communicate before re-energizing.",
                                isCorrect: true,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "step-4-b",
                                text: "Ask another worker to remove your lock while you document the repair.",
                                feedback: "Incorrect. Removal should be done by the person who applied the lock.",
                                isCorrect: false,
                                nextStepId: nil
                            )
                        ]
                    )
                ]
            ),
            quiz: [
                QuizQuestion(
                    id: "loto-q1",
                    prompt: "Which step is part of the OSHA LOTO sequence?",
                    choices: [
                        QuizChoice(id: "loto-q1-a", text: "Verify isolation before starting work", isCorrect: true),
                        QuizChoice(id: "loto-q1-b", text: "Restart equipment to test the repair", isCorrect: false),
                        QuizChoice(id: "loto-q1-c", text: "Skip isolation if the equipment is powered off", isCorrect: false)
                    ]
                ),
                QuizQuestion(
                    id: "loto-q2",
                    prompt: "Who applies the lockout device?",
                    choices: [
                        QuizChoice(id: "loto-q2-a", text: "The authorized employee performing the work", isCorrect: true),
                        QuizChoice(id: "loto-q2-b", text: "Any supervisor in the area", isCorrect: false),
                        QuizChoice(id: "loto-q2-c", text: "The affected employee", isCorrect: false)
                    ]
                ),
                QuizQuestion(
                    id: "loto-q3",
                    prompt: "Tags are warning devices and:",
                    choices: [
                        QuizChoice(id: "loto-q3-a", text: "Do not provide physical restraint", isCorrect: true),
                        QuizChoice(id: "loto-q3-b", text: "Eliminate the need for isolation", isCorrect: false),
                        QuizChoice(id: "loto-q3-c", text: "Are optional if the machine is off", isCorrect: false)
                    ]
                )
            ]
        ),
        TrainingModule(
            id: "fall-protection",
            title: "Fall Protection",
            subtitle: "Prevent falls on walking-working surfaces",
            estimatedMinutes: 16,
            difficulty: "Core",
            tags: ["Walking-Working Surfaces", "OSHA 1910 Subpart D"],
            objectives: [
                "Recognize fall hazards in common work areas",
                "Select appropriate fall protection systems",
                "Perform pre-use checks on equipment",
                "Apply required training elements"
            ],
            lessonPages: [
                LessonPage(
                    id: "fall-1",
                    title: "When Protection Is Required",
                    bullets: [
                        "In general industry, fall protection is required when working 4 feet or more above a lower level unless a specific exception applies.",
                        "Plan work to minimize exposure to edges, holes, and unprotected sides.",
                        "Use passive systems first when feasible (guardrails, covers)."
                    ]
                ),
                LessonPage(
                    id: "fall-2",
                    title: "System Options",
                    bullets: [
                        "Guardrail systems, safety nets, and personal fall arrest systems (PFAS) are common options.",
                        "PFAS requires an anchorage, connectors, and a body harness.",
                        "Select systems based on the task, environment, and rescue plan."
                    ]
                ),
                LessonPage(
                    id: "fall-3",
                    title: "Training Essentials",
                    bullets: [
                        "Training must cover fall hazards, correct procedures, and system limitations.",
                        "Inspect equipment before each use and remove defective gear from service.",
                        "Retrain when procedures change or performance indicates gaps."
                    ]
                )
            ],
            scenario: Scenario(
                title: "Rooftop HVAC Inspection",
                intro: "You are assigned to inspect an HVAC unit on a flat roof with an unprotected edge.",
                startStepId: "fall-step-1",
                steps: [
                    ScenarioStep(
                        id: "fall-step-1",
                        prompt: "What is the safest first step?",
                        options: [
                            ScenarioOption(
                                id: "fall-step-1-a",
                                text: "Assess the work area and choose a fall protection method.",
                                feedback: "Correct. Evaluate hazards and select protection before stepping out.",
                                isCorrect: true,
                                nextStepId: "fall-step-2"
                            ),
                            ScenarioOption(
                                id: "fall-step-1-b",
                                text: "Walk to the unit quickly to limit exposure time.",
                                feedback: "Not safe. You need protection in place first.",
                                isCorrect: false,
                                nextStepId: "fall-step-2"
                            )
                        ]
                    ),
                    ScenarioStep(
                        id: "fall-step-2",
                        prompt: "There are no guardrails. What is the best option?",
                        options: [
                            ScenarioOption(
                                id: "fall-step-2-a",
                                text: "Use a PFAS with an approved anchorage and a body harness.",
                                feedback: "Correct. Active fall protection is required without passive systems.",
                                isCorrect: true,
                                nextStepId: "fall-step-3"
                            ),
                            ScenarioOption(
                                id: "fall-step-2-b",
                                text: "Use a waist belt so you can move freely.",
                                feedback: "Incorrect. Body harnesses are required for arrest systems.",
                                isCorrect: false,
                                nextStepId: "fall-step-3"
                            )
                        ]
                    ),
                    ScenarioStep(
                        id: "fall-step-3",
                        prompt: "Before stepping onto the roof, you should:",
                        options: [
                            ScenarioOption(
                                id: "fall-step-3-a",
                                text: "Inspect the harness, connectors, and anchorage point.",
                                feedback: "Correct. Pre-use inspection is required.",
                                isCorrect: true,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "fall-step-3-b",
                                text: "Skip inspection if the equipment was used yesterday.",
                                feedback: "Not acceptable. Inspect before each use.",
                                isCorrect: false,
                                nextStepId: nil
                            )
                        ]
                    )
                ]
            ),
            quiz: [
                QuizQuestion(
                    id: "fall-q1",
                    prompt: "What is the default fall protection threshold in general industry?",
                    choices: [
                        QuizChoice(id: "fall-q1-a", text: "4 feet above a lower level", isCorrect: true),
                        QuizChoice(id: "fall-q1-b", text: "10 feet above a lower level", isCorrect: false),
                        QuizChoice(id: "fall-q1-c", text: "No specific threshold", isCorrect: false)
                    ]
                ),
                QuizQuestion(
                    id: "fall-q2",
                    prompt: "Which component is required for a personal fall arrest system?",
                    choices: [
                        QuizChoice(id: "fall-q2-a", text: "Body harness", isCorrect: true),
                        QuizChoice(id: "fall-q2-b", text: "Waist belt only", isCorrect: false),
                        QuizChoice(id: "fall-q2-c", text: "Warning line only", isCorrect: false)
                    ]
                ),
                QuizQuestion(
                    id: "fall-q3",
                    prompt: "Training should include which of the following?",
                    choices: [
                        QuizChoice(id: "fall-q3-a", text: "Hazards, procedures, and equipment limitations", isCorrect: true),
                        QuizChoice(id: "fall-q3-b", text: "Only the policy memo title", isCorrect: false),
                        QuizChoice(id: "fall-q3-c", text: "Only how to complete paperwork", isCorrect: false)
                    ]
                )
            ]
        ),
        TrainingModule(
            id: "risk-management",
            title: "Risk Management",
            subtitle: "Apply the Air Force RM process",
            estimatedMinutes: 14,
            difficulty: "Core",
            tags: ["RM", "DAFPAM 90-803"],
            objectives: [
                "Apply the five-step RM process",
                "Use severity and probability to assess risk",
                "Select controls using the hierarchy of controls",
                "Supervise and evaluate effectiveness"
            ],
            lessonPages: [
                LessonPage(
                    id: "rm-1",
                    title: "The Five Steps",
                    bullets: [
                        "Identify hazards in the task and environment.",
                        "Assess hazards by severity and probability.",
                        "Develop controls and make risk decisions.",
                        "Implement controls and assign responsibilities.",
                        "Supervise and evaluate results for improvement."
                    ]
                ),
                LessonPage(
                    id: "rm-2",
                    title: "Controls",
                    bullets: [
                        "Use the hierarchy of controls: eliminate, engineer, administrate, and PPE.",
                        "Prefer controls that remove or reduce the hazard over relying on PPE alone.",
                        "Document controls in pre-task briefs and work plans."
                    ]
                ),
                LessonPage(
                    id: "rm-3",
                    title: "Decision Discipline",
                    bullets: [
                        "Accept risk only at the proper level of authority.",
                        "If conditions change, reassess and update controls.",
                        "Close the loop by supervising and evaluating outcomes."
                    ]
                )
            ],
            scenario: Scenario(
                title: "Flight Line Equipment Inspection",
                intro: "You are planning a safety inspection on the flight line during hot weather with vehicle traffic.",
                startStepId: "rm-step-1",
                steps: [
                    ScenarioStep(
                        id: "rm-step-1",
                        prompt: "Which action is part of the first RM step?",
                        options: [
                            ScenarioOption(
                                id: "rm-step-1-a",
                                text: "Identify hazards like heat stress and moving vehicles.",
                                feedback: "Correct. Identify hazards before selecting controls.",
                                isCorrect: true,
                                nextStepId: "rm-step-2"
                            ),
                            ScenarioOption(
                                id: "rm-step-1-b",
                                text: "Assign PPE without assessing risks.",
                                feedback: "Not yet. You must identify and assess hazards first.",
                                isCorrect: false,
                                nextStepId: "rm-step-2"
                            )
                        ]
                    ),
                    ScenarioStep(
                        id: "rm-step-2",
                        prompt: "How do you assess hazards?",
                        options: [
                            ScenarioOption(
                                id: "rm-step-2-a",
                                text: "Estimate severity and probability to determine risk level.",
                                feedback: "Correct. This drives control selection and decisions.",
                                isCorrect: true,
                                nextStepId: "rm-step-3"
                            ),
                            ScenarioOption(
                                id: "rm-step-2-b",
                                text: "Assume all hazards are high risk.",
                                feedback: "Incorrect. Use a structured assessment to prioritize.",
                                isCorrect: false,
                                nextStepId: "rm-step-3"
                            )
                        ]
                    ),
                    ScenarioStep(
                        id: "rm-step-3",
                        prompt: "Which control is strongest?",
                        options: [
                            ScenarioOption(
                                id: "rm-step-3-a",
                                text: "Eliminate the hazard or engineer it out.",
                                feedback: "Correct. Elimination and engineering are strongest.",
                                isCorrect: true,
                                nextStepId: "rm-step-4"
                            ),
                            ScenarioOption(
                                id: "rm-step-3-b",
                                text: "Rely only on PPE and reminders.",
                                feedback: "Not ideal. PPE is the last line of defense.",
                                isCorrect: false,
                                nextStepId: "rm-step-4"
                            )
                        ]
                    ),
                    ScenarioStep(
                        id: "rm-step-4",
                        prompt: "What closes the RM loop?",
                        options: [
                            ScenarioOption(
                                id: "rm-step-4-a",
                                text: "Supervise and evaluate to confirm controls work.",
                                feedback: "Correct. Monitor and adjust as needed.",
                                isCorrect: true,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "rm-step-4-b",
                                text: "Assume controls are effective without follow-up.",
                                feedback: "Incorrect. Supervision and evaluation are required.",
                                isCorrect: false,
                                nextStepId: nil
                            )
                        ]
                    )
                ]
            ),
            quiz: [
                QuizQuestion(
                    id: "rm-q1",
                    prompt: "What are the first two steps of the RM process?",
                    choices: [
                        QuizChoice(id: "rm-q1-a", text: "Identify hazards, assess hazards", isCorrect: true),
                        QuizChoice(id: "rm-q1-b", text: "Implement controls, supervise", isCorrect: false),
                        QuizChoice(id: "rm-q1-c", text: "Make decisions, report results", isCorrect: false)
                    ]
                ),
                QuizQuestion(
                    id: "rm-q2",
                    prompt: "Which control is preferred over PPE?",
                    choices: [
                        QuizChoice(id: "rm-q2-a", text: "Engineering controls", isCorrect: true),
                        QuizChoice(id: "rm-q2-b", text: "Reminders only", isCorrect: false),
                        QuizChoice(id: "rm-q2-c", text: "No control", isCorrect: false)
                    ]
                ),
                QuizQuestion(
                    id: "rm-q3",
                    prompt: "Why do we supervise and evaluate?",
                    choices: [
                        QuizChoice(id: "rm-q3-a", text: "To verify controls work and adjust as needed", isCorrect: true),
                        QuizChoice(id: "rm-q3-b", text: "Only to complete paperwork", isCorrect: false),
                        QuizChoice(id: "rm-q3-c", text: "Because the process ends after controls are chosen", isCorrect: false)
                    ]
                )
            ]
        )
    ]

    static let references: [ReferenceSource] = [
        ReferenceSource(
            id: "osha-1910-147",
            title: "OSHA 29 CFR 1910.147 - The control of hazardous energy (lockout/tagout)",
            date: "Accessed Feb 2, 2026",
            notes: "Sequence of lockout/tagout and program requirements."
        ),
        ReferenceSource(
            id: "osha-1910-subpart-d",
            title: "OSHA 29 CFR 1910.28 and 1910.30 - Walking-Working Surfaces and Training",
            date: "Accessed Feb 2, 2026",
            notes: "Fall protection thresholds, systems, and training requirements."
        ),
        ReferenceSource(
            id: "dafman-91-203",
            title: "DAFMAN 91-203 - Air Force Occupational Safety, Fire, and Health Standards",
            date: "25 Mar 2022 with DAFGM 2025-01 (12 May 2025)",
            notes: "Air Force safety program standards used to align training emphasis."
        ),
        ReferenceSource(
            id: "dafpam-90-803",
            title: "DAFPAM 90-803 - Risk Management (RM) Guidelines and Tools",
            date: "23 Mar 2022",
            notes: "Five-step RM process and control selection guidance."
        ),
        ReferenceSource(
            id: "cfetp-1s0x1",
            title: "CFETP 1S0X1 - Safety Career Field Education and Training Plan",
            date: "12 Jun 2024",
            notes: "Career field training outcomes and expectations."
        )
    ]
}
