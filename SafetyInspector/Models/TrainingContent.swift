import Foundation

enum TrainingContent {
    static let modules: [TrainingModule] = [
        TrainingModule(
            id: "loto",
            title: "Lockout / Tagout",
            subtitle: "Control hazardous energy before servicing or maintenance",
            estimatedMinutes: 20,
            difficulty: "Core",
            tags: ["Energy Control", "OSHA 1910.147"],
            objectives: [
                "Explain when lockout/tagout is required",
                "Apply the OSHA sequence for isolating hazardous energy",
                "Verify zero energy before work begins",
                "Communicate with affected employees",
                "Coordinate group lockout when multiple workers are involved"
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
                ),
                LessonPage(
                    id: "loto-5",
                    title: "Group Coordination",
                    bullets: [
                        "When multiple workers are involved, use a group lockout process.",
                        "Each authorized employee maintains personal control with their own lock.",
                        "Shift changes require a controlled transfer so isolation is never broken."
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
                ),
                QuizQuestion(
                    id: "loto-q4",
                    prompt: "Group LOTO requires that:",
                    choices: [
                        QuizChoice(id: "loto-q4-a", text: "Each authorized employee maintains personal lock control", isCorrect: true),
                        QuizChoice(id: "loto-q4-b", text: "Only the supervisor applies locks", isCorrect: false),
                        QuizChoice(id: "loto-q4-c", text: "Locks can be shared across shifts", isCorrect: false)
                    ]
                )
            ]
        ),
        TrainingModule(
            id: "fall-protection",
            title: "Fall Protection",
            subtitle: "Prevent falls on walking-working surfaces",
            estimatedMinutes: 18,
            difficulty: "Core",
            tags: ["Walking-Working Surfaces", "OSHA 1910 Subpart D"],
            objectives: [
                "Recognize fall hazards in common work areas",
                "Select appropriate fall protection systems",
                "Perform pre-use checks on equipment",
                "Apply required training elements",
                "Plan for rescue and recovery"
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
                ),
                LessonPage(
                    id: "fall-4",
                    title: "Rescue Planning",
                    bullets: [
                        "Plan for prompt rescue when using fall arrest systems.",
                        "Coordinate rescue roles before starting the task.",
                        "Avoid relying on emergency response as the only plan."
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
                ),
                QuizQuestion(
                    id: "fall-q4",
                    prompt: "Rescue planning is important because:",
                    choices: [
                        QuizChoice(id: "fall-q4-a", text: "Suspension time after a fall can create additional risk", isCorrect: true),
                        QuizChoice(id: "fall-q4-b", text: "It replaces fall protection", isCorrect: false),
                        QuizChoice(id: "fall-q4-c", text: "It eliminates the need for inspection", isCorrect: false)
                    ]
                )
            ]
        ),
        TrainingModule(
            id: "risk-management",
            title: "Risk Management",
            subtitle: "Apply the Air Force RM process",
            estimatedMinutes: 16,
            difficulty: "Core",
            tags: ["RM", "DAFPAM 90-803"],
            objectives: [
                "Apply the five-step RM process",
                "Use severity and probability to assess risk",
                "Select controls using the hierarchy of controls",
                "Supervise and evaluate effectiveness",
                "Document and communicate risk decisions"
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
                ),
                LessonPage(
                    id: "rm-4",
                    title: "Communicate Risk",
                    bullets: [
                        "Ensure risk decisions are understood by the team.",
                        "Use clear terminology and documented controls.",
                        "Escalate when risk exceeds local authority."
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
                ),
                QuizQuestion(
                    id: "rm-q4",
                    prompt: "Risk decisions should be:",
                    choices: [
                        QuizChoice(id: "rm-q4-a", text: "Communicated to the team and documented", isCorrect: true),
                        QuizChoice(id: "rm-q4-b", text: "Kept informal to save time", isCorrect: false),
                        QuizChoice(id: "rm-q4-c", text: "Made without considering controls", isCorrect: false)
                    ]
                )
            ]
        ),
        TrainingModule(
            id: "roles-responsibilities",
            title: "Roles & Responsibilities",
            subtitle: "Clarify who does what in the safety program",
            estimatedMinutes: 14,
            difficulty: "Core",
            tags: ["Safety Program", "DAFMAN 91-203"],
            objectives: [
                "Identify key safety roles at the unit level",
                "Describe supervisor and employee responsibilities",
                "Explain the safety office role in inspections and guidance",
                "Apply responsibility boundaries during inspections"
            ],
            lessonPages: [
                LessonPage(
                    id: "roles-1",
                    title: "Program Roles",
                    bullets: [
                        "Commanders and directors set expectations and allocate resources.",
                        "Supervisors enforce safe procedures and ensure training.",
                        "Safety offices provide oversight, inspections, and program guidance.",
                        "Workers follow procedures, use PPE, and report hazards."
                    ]
                ),
                LessonPage(
                    id: "roles-2",
                    title: "Supervisor Duties",
                    bullets: [
                        "Ensure job hazard analysis and safe work practices are in place.",
                        "Correct unsafe acts and conditions promptly.",
                        "Track abatement actions and verify completion."
                    ]
                ),
                LessonPage(
                    id: "roles-3",
                    title: "Employee Duties",
                    bullets: [
                        "Follow approved procedures and report unsafe conditions.",
                        "Use assigned PPE correctly and maintain it.",
                        "Pause work and elevate risks that exceed controls."
                    ]
                ),
                LessonPage(
                    id: "roles-4",
                    title: "Inspector Focus",
                    bullets: [
                        "Clarify expectations with leadership before inspections.",
                        "Document findings and coordinate corrective actions.",
                        "Verify abatement and close the loop."
                    ]
                )
            ],
            scenario: Scenario(
                title: "Pre-Inspection Brief",
                intro: "You are preparing for a shop inspection and need to align responsibilities before the walkthrough.",
                startStepId: "roles-step-1",
                steps: [
                    ScenarioStep(
                        id: "roles-step-1",
                        prompt: "Who should you brief first?",
                        options: [
                            ScenarioOption(
                                id: "roles-step-1-a",
                                text: "The shop supervisor to align expectations and scope.",
                                feedback: "Correct. Supervisors are responsible for local processes and can align the team.",
                                isCorrect: true,
                                nextStepId: "roles-step-2"
                            ),
                            ScenarioOption(
                                id: "roles-step-1-b",
                                text: "Only the newest worker because they are most at risk.",
                                feedback: "Not enough. You need supervisor alignment for the whole shop.",
                                isCorrect: false,
                                nextStepId: "roles-step-2"
                            )
                        ]
                    ),
                    ScenarioStep(
                        id: "roles-step-2",
                        prompt: "You find repeated PPE misuse. Who is primarily responsible for correcting it?",
                        options: [
                            ScenarioOption(
                                id: "roles-step-2-a",
                                text: "The supervisor, with support from the safety office.",
                                feedback: "Correct. Supervisors enforce standards; safety provides guidance.",
                                isCorrect: true,
                                nextStepId: "roles-step-3"
                            ),
                            ScenarioOption(
                                id: "roles-step-2-b",
                                text: "The safety office alone.",
                                feedback: "Incorrect. Safety supports, but supervisors own day-to-day enforcement.",
                                isCorrect: false,
                                nextStepId: "roles-step-3"
                            )
                        ]
                    ),
                    ScenarioStep(
                        id: "roles-step-3",
                        prompt: "An employee reports a hazard with no easy fix. What should happen?",
                        options: [
                            ScenarioOption(
                                id: "roles-step-3-a",
                                text: "Document it, apply interim controls, and assign abatement responsibility.",
                                feedback: "Correct. Track the hazard and control risk until fixed.",
                                isCorrect: true,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "roles-step-3-b",
                                text: "Ignore it until next inspection.",
                                feedback: "Incorrect. Hazards must be addressed and tracked.",
                                isCorrect: false,
                                nextStepId: nil
                            )
                        ]
                    )
                ]
            ),
            quiz: [
                QuizQuestion(
                    id: "roles-q1",
                    prompt: "Who is responsible for enforcing safe procedures in daily operations?",
                    choices: [
                        QuizChoice(id: "roles-q1-a", text: "Supervisors", isCorrect: true),
                        QuizChoice(id: "roles-q1-b", text: "Only the safety office", isCorrect: false),
                        QuizChoice(id: "roles-q1-c", text: "Only the commander", isCorrect: false)
                    ]
                ),
                QuizQuestion(
                    id: "roles-q2",
                    prompt: "Employees should:",
                    choices: [
                        QuizChoice(id: "roles-q2-a", text: "Report hazards and follow procedures", isCorrect: true),
                        QuizChoice(id: "roles-q2-b", text: "Wait for inspections to mention hazards", isCorrect: false),
                        QuizChoice(id: "roles-q2-c", text: "Use PPE only when convenient", isCorrect: false)
                    ]
                ),
                QuizQuestion(
                    id: "roles-q3",
                    prompt: "The safety office primarily provides:",
                    choices: [
                        QuizChoice(id: "roles-q3-a", text: "Oversight, guidance, and program support", isCorrect: true),
                        QuizChoice(id: "roles-q3-b", text: "Only disciplinary actions", isCorrect: false),
                        QuizChoice(id: "roles-q3-c", text: "Only emergency response", isCorrect: false)
                    ]
                )
            ]
        ),
        TrainingModule(
            id: "hazard-abatement",
            title: "Hazard Abatement",
            subtitle: "Control and track corrective actions",
            estimatedMinutes: 16,
            difficulty: "Core",
            tags: ["Abatement", "DAFMAN 91-203"],
            objectives: [
                "Document hazards clearly and consistently",
                "Select interim controls when immediate fixes are not possible",
                "Assign responsibility and timelines",
                "Verify and close abatement actions"
            ],
            lessonPages: [
                LessonPage(
                    id: "abatement-1",
                    title: "Document the Hazard",
                    bullets: [
                        "Use clear, specific descriptions with location and conditions.",
                        "Capture evidence when possible (photos, measurements, witness input).",
                        "Link hazards to applicable standards and local procedures."
                    ]
                ),
                LessonPage(
                    id: "abatement-2",
                    title: "Interim Controls",
                    bullets: [
                        "Apply temporary controls to reduce risk until a permanent fix is complete.",
                        "Common interim controls include barricades, signage, and administrative limits.",
                        "Document interim controls and communicate to affected personnel."
                    ]
                ),
                LessonPage(
                    id: "abatement-3",
                    title: "Assign and Track",
                    bullets: [
                        "Assign a responsible owner and realistic completion date.",
                        "Track progress and follow up regularly.",
                        "Escalate overdue high-risk hazards for leadership action."
                    ]
                ),
                LessonPage(
                    id: "abatement-4",
                    title: "Verify Closure",
                    bullets: [
                        "Confirm corrective action removed or controlled the hazard.",
                        "Update records and communicate closure.",
                        "Capture lessons learned for prevention."
                    ]
                )
            ],
            scenario: Scenario(
                title: "Hangar Trip Hazard",
                intro: "A power cable is routed across a hangar aisle and has already caused a near miss.",
                startStepId: "abatement-step-1",
                steps: [
                    ScenarioStep(
                        id: "abatement-step-1",
                        prompt: "What is the best immediate action?",
                        options: [
                            ScenarioOption(
                                id: "abatement-step-1-a",
                                text: "Install interim controls (cover, reroute, or barricade) and document the hazard.",
                                feedback: "Correct. Reduce risk immediately and document the hazard.",
                                isCorrect: true,
                                nextStepId: "abatement-step-2"
                            ),
                            ScenarioOption(
                                id: "abatement-step-1-b",
                                text: "Wait until the next scheduled inspection to address it.",
                                feedback: "Incorrect. Immediate interim controls are needed.",
                                isCorrect: false,
                                nextStepId: "abatement-step-2"
                            )
                        ]
                    ),
                    ScenarioStep(
                        id: "abatement-step-2",
                        prompt: "Who should own the corrective action?",
                        options: [
                            ScenarioOption(
                                id: "abatement-step-2-a",
                                text: "The shop leadership responsible for the workspace.",
                                feedback: "Correct. Owners must have authority to fix the hazard.",
                                isCorrect: true,
                                nextStepId: "abatement-step-3"
                            ),
                            ScenarioOption(
                                id: "abatement-step-2-b",
                                text: "Only the safety office.",
                                feedback: "Incorrect. Safety supports, but shop leadership owns corrective action.",
                                isCorrect: false,
                                nextStepId: "abatement-step-3"
                            )
                        ]
                    ),
                    ScenarioStep(
                        id: "abatement-step-3",
                        prompt: "When can you close the hazard?",
                        options: [
                            ScenarioOption(
                                id: "abatement-step-3-a",
                                text: "After verifying the fix removes or controls the hazard.",
                                feedback: "Correct. Verify effectiveness before closure.",
                                isCorrect: true,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "abatement-step-3-b",
                                text: "As soon as a work order is opened.",
                                feedback: "Incorrect. Opening a work order is not closure.",
                                isCorrect: false,
                                nextStepId: nil
                            )
                        ]
                    )
                ]
            ),
            quiz: [
                QuizQuestion(
                    id: "abatement-q1",
                    prompt: "Interim controls are used when:",
                    choices: [
                        QuizChoice(id: "abatement-q1-a", text: "A permanent fix is not yet complete", isCorrect: true),
                        QuizChoice(id: "abatement-q1-b", text: "No hazard exists", isCorrect: false),
                        QuizChoice(id: "abatement-q1-c", text: "To replace documentation", isCorrect: false)
                    ]
                ),
                QuizQuestion(
                    id: "abatement-q2",
                    prompt: "Who should be assigned corrective action responsibility?",
                    choices: [
                        QuizChoice(id: "abatement-q2-a", text: "The person or team with authority to fix it", isCorrect: true),
                        QuizChoice(id: "abatement-q2-b", text: "Anyone available", isCorrect: false),
                        QuizChoice(id: "abatement-q2-c", text: "No one until funding arrives", isCorrect: false)
                    ]
                ),
                QuizQuestion(
                    id: "abatement-q3",
                    prompt: "A hazard can be closed when:",
                    choices: [
                        QuizChoice(id: "abatement-q3-a", text: "The corrective action is verified effective", isCorrect: true),
                        QuizChoice(id: "abatement-q3-b", text: "A memo is sent", isCorrect: false),
                        QuizChoice(id: "abatement-q3-c", text: "The next inspection is scheduled", isCorrect: false)
                    ]
                )
            ]
        ),
        TrainingModule(
            id: "rac-system",
            title: "RAC System",
            subtitle: "Assign risk using severity and probability",
            estimatedMinutes: 14,
            difficulty: "Core",
            tags: ["RAC", "DAFPAM 90-803"],
            objectives: [
                "Explain how RAC is derived from severity and probability",
                "Use a risk matrix to prioritize hazards",
                "Connect RAC levels to required actions",
                "Apply RAC consistently during inspections"
            ],
            lessonPages: [
                LessonPage(
                    id: "rac-1",
                    title: "RAC Basics",
                    bullets: [
                        "Risk Assessment Code (RAC) combines severity and probability.",
                        "Use the approved matrix to determine the overall risk level.",
                        "RAC helps prioritize hazard abatement and leadership attention."
                    ]
                ),
                LessonPage(
                    id: "rac-2",
                    title: "Severity and Probability",
                    bullets: [
                        "Severity considers the consequence if the hazard occurs.",
                        "Probability estimates how likely the hazard is to occur.",
                        "Use consistent criteria and document the rationale."
                    ]
                ),
                LessonPage(
                    id: "rac-3",
                    title: "Using the Matrix",
                    bullets: [
                        "Combine severity and probability to determine RAC.",
                        "Higher RAC requires faster abatement and higher-level decisions.",
                        "If uncertain, consult your safety office for alignment."
                    ]
                )
            ],
            scenario: Scenario(
                title: "Vehicle Bay Inspection",
                intro: "You find a missing guard on a rotating shaft in a vehicle bay. The task is performed daily.",
                startStepId: "rac-step-1",
                steps: [
                    ScenarioStep(
                        id: "rac-step-1",
                        prompt: "How should you begin assigning RAC?",
                        options: [
                            ScenarioOption(
                                id: "rac-step-1-a",
                                text: "Estimate severity and probability, then use the approved matrix.",
                                feedback: "Correct. RAC is derived from severity and probability.",
                                isCorrect: true,
                                nextStepId: "rac-step-2"
                            ),
                            ScenarioOption(
                                id: "rac-step-1-b",
                                text: "Pick a RAC number based on experience alone.",
                                feedback: "Incorrect. Use the matrix with defined criteria.",
                                isCorrect: false,
                                nextStepId: "rac-step-2"
                            )
                        ]
                    ),
                    ScenarioStep(
                        id: "rac-step-2",
                        prompt: "The hazard is frequent and could cause serious injury. What should you do next?",
                        options: [
                            ScenarioOption(
                                id: "rac-step-2-a",
                                text: "Assign a higher RAC and elevate for prompt abatement.",
                                feedback: "Correct. Higher severity and probability increase RAC and urgency.",
                                isCorrect: true,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "rac-step-2-b",
                                text: "Assign a low RAC to avoid disrupting operations.",
                                feedback: "Incorrect. RAC must reflect actual risk.",
                                isCorrect: false,
                                nextStepId: nil
                            )
                        ]
                    )
                ]
            ),
            quiz: [
                QuizQuestion(
                    id: "rac-q1",
                    prompt: "RAC is determined by:",
                    choices: [
                        QuizChoice(id: "rac-q1-a", text: "Severity and probability", isCorrect: true),
                        QuizChoice(id: "rac-q1-b", text: "Cost of the fix only", isCorrect: false),
                        QuizChoice(id: "rac-q1-c", text: "Who reported the hazard", isCorrect: false)
                    ]
                ),
                QuizQuestion(
                    id: "rac-q2",
                    prompt: "A higher RAC generally means:",
                    choices: [
                        QuizChoice(id: "rac-q2-a", text: "Faster abatement and higher-level attention", isCorrect: true),
                        QuizChoice(id: "rac-q2-b", text: "Less documentation", isCorrect: false),
                        QuizChoice(id: "rac-q2-c", text: "Lower urgency", isCorrect: false)
                    ]
                ),
                QuizQuestion(
                    id: "rac-q3",
                    prompt: "If you are unsure about severity or probability, you should:",
                    choices: [
                        QuizChoice(id: "rac-q3-a", text: "Consult the safety office for alignment", isCorrect: true),
                        QuizChoice(id: "rac-q3-b", text: "Assign the lowest RAC", isCorrect: false),
                        QuizChoice(id: "rac-q3-c", text: "Skip the RAC", isCorrect: false)
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
            notes: "Roles, responsibilities, and hazard abatement references for the AF safety program."
        ),
        ReferenceSource(
            id: "dafpam-90-803",
            title: "DAFPAM 90-803 - Risk Management (RM) Guidelines and Tools",
            date: "23 Mar 2022",
            notes: "Five-step RM process and risk assessment matrix guidance."
        ),
        ReferenceSource(
            id: "cfetp-1s0x1",
            title: "CFETP 1S0X1 - Safety Career Field Education and Training Plan",
            date: "12 Jun 2024",
            notes: "Career field training outcomes and expectations."
        )
    ]
}
