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
                        prompt: "Conveyor guard replacement: first action?",
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
                            ),
                            ScenarioOption(
                                id: "step-1-c",
                                text: "Pull the disconnect immediately without briefing anyone to save time.",
                                feedback: "Not quite. You still need to notify affected employees and confirm all energy sources and procedures before shutdown.",
                                isCorrect: false,
                                nextStepId: "step-2"
                            ),
                            ScenarioOption(
                                id: "step-1-d",
                                text: "Have the operator stand by the start/stop controls while you remove the guard.",
                                feedback: "Incorrect. A spotter at the controls is not energy isolation or personal control.",
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
                            ),
                            ScenarioOption(
                                id: "step-2-c",
                                text: "Remove the guard first, then lock out if the job takes longer than expected.",
                                feedback: "Unsafe. If you are exposed to hazardous energy during servicing, isolate first—don’t wait until mid-task.",
                                isCorrect: false,
                                nextStepId: "step-3"
                            ),
                            ScenarioOption(
                                id: "step-2-d",
                                text: "Lock only the main switch and ignore secondary sources and stored energy.",
                                feedback: "Incorrect. You must isolate all energy sources and address stored/accumulated energy as part of the sequence.",
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
                            ),
                            ScenarioOption(
                                id: "step-3-c",
                                text: "Use only an instrument check and skip try-out to avoid accidental start.",
                                feedback: "Not enough. Verification should follow the established try-out/verification method—not a single check you invent on the fly.",
                                isCorrect: false,
                                nextStepId: "step-4"
                            ),
                            ScenarioOption(
                                id: "step-3-d",
                                text: "Begin loosening the guard fasteners to see if anything moves.",
                                feedback: "Unsafe. Verification happens before you place any part of your body into a hazard zone.",
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
                            ),
                            ScenarioOption(
                                id: "step-4-c",
                                text: "Re-energize to test operation before reinstalling the guard to save time.",
                                feedback: "Incorrect. Restore guarding and ensure the area is clear before re-energizing and returning to service.",
                                isCorrect: false,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "step-4-d",
                                text: "Remove your lock and leave—assume the operator will handle notifications later.",
                                feedback: "Not acceptable. Clear communication with affected employees is a required part of restoring the equipment safely.",
                                isCorrect: false,
                                nextStepId: nil
                            )
                        ]
                    )
                ]
            ),
            quiz: QuizBank.loto
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
                            ),
                            ScenarioOption(
                                id: "fall-step-1-c",
                                text: "Have a coworker spot you while you work near the edge without a system.",
                                feedback: "Incorrect. A spotter doesn’t prevent a fall—fall protection must be in place before exposure.",
                                isCorrect: false,
                                nextStepId: "fall-step-2"
                            ),
                            ScenarioOption(
                                id: "fall-step-1-d",
                                text: "Mark the edge with tape and proceed since you can see the hazard.",
                                feedback: "Not enough. Visual cues don’t provide protection if you slip or get distracted.",
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
                            ),
                            ScenarioOption(
                                id: "fall-step-2-c",
                                text: "Tie off to a nearby pipe/duct because it’s convenient.",
                                feedback: "Incorrect. Anchorage must be approved/capable for fall loading—convenience is not a rating.",
                                isCorrect: false,
                                nextStepId: "fall-step-3"
                            ),
                            ScenarioOption(
                                id: "fall-step-2-d",
                                text: "Proceed without fall protection because the roof is flat and dry.",
                                feedback: "Incorrect. Flat surfaces still present fall hazards at unprotected edges.",
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
                            ),
                            ScenarioOption(
                                id: "fall-step-3-c",
                                text: "Step onto the roof, then clip in once you reach the unit.",
                                feedback: "Incorrect. You need protection before you’re exposed to the hazard.",
                                isCorrect: false,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "fall-step-3-d",
                                text: "Set the lanyard as long as possible so you can reach the edge easily.",
                                feedback: "Incorrect. Rigging must control exposure and account for swing fall and clearance.",
                                isCorrect: false,
                                nextStepId: nil
                            )
                        ]
                    )
                ]
            ),
            quiz: QuizBank.fallProtection
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
                            ),
                            ScenarioOption(
                                id: "rm-step-1-c",
                                text: "Skip hazard identification because the inspection is routine.",
                                feedback: "Incorrect. Routine tasks still require hazard identification—conditions and hazards change.",
                                isCorrect: false,
                                nextStepId: "rm-step-2"
                            ),
                            ScenarioOption(
                                id: "rm-step-1-d",
                                text: "Start the inspection and figure out hazards as you go.",
                                feedback: "Not ideal. Identify hazards up front so controls and stop-work triggers are in place before exposure.",
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
                            ),
                            ScenarioOption(
                                id: "rm-step-2-c",
                                text: "Use only estimated cost impacts to decide the risk level.",
                                feedback: "Incorrect. Risk assessment is driven by severity and probability of credible outcomes, not cost alone.",
                                isCorrect: false,
                                nextStepId: "rm-step-3"
                            ),
                            ScenarioOption(
                                id: "rm-step-2-d",
                                text: "Let the most senior person decide risk level without criteria.",
                                feedback: "Incorrect. Authority matters for acceptance, but assessment should use defined criteria and rationale.",
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
                            ),
                            ScenarioOption(
                                id: "rm-step-3-c",
                                text: "Post a sign and continue with no other controls.",
                                feedback: "Weak control. Signs rely on behavior and don’t reduce the hazard at the source.",
                                isCorrect: false,
                                nextStepId: "rm-step-4"
                            ),
                            ScenarioOption(
                                id: "rm-step-3-d",
                                text: "Document the hazard and proceed without implementing controls.",
                                feedback: "Incorrect. Documentation does not reduce risk—controls must be implemented and owned.",
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
                            ),
                            ScenarioOption(
                                id: "rm-step-4-c",
                                text: "File the paperwork and consider the process complete.",
                                feedback: "Incorrect. The loop closes with supervision and evaluation, not filing.",
                                isCorrect: false,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "rm-step-4-d",
                                text: "Hand it off to the next shift with no follow-up since controls exist on paper.",
                                feedback: "Not enough. Controls must be verified in execution and adjusted if conditions change.",
                                isCorrect: false,
                                nextStepId: nil
                            )
                        ]
                    )
                ]
            ),
            quiz: QuizBank.riskManagement
        ),
        TrainingModule(
            id: "roles-responsibilities",
            title: "Program Responsibilities",
            subtitle: "Clarify how commanders, supervisors, workers, and 1S0 inspectors sustain the safety program",
            estimatedMinutes: 14,
            difficulty: "Core",
            tags: ["Safety Program", "DAFMAN 91-203"],
            objectives: [
                "Identify key safety responsibilities at the unit level",
                "Describe commander, supervisor, and worker responsibilities",
                "Explain how 1S0 inspectors support inspections and guidance",
                "Apply responsibility boundaries during inspections"
            ],
            lessonPages: [
                LessonPage(
                    id: "roles-1",
                    title: "Program Responsibilities",
                    bullets: [
                        "Commanders and directors set expectations and allocate resources.",
                        "Supervisors enforce safe procedures and ensure training.",
                        "Safety offices provide oversight, inspections, and program guidance.",
                        "Workers follow procedures, use PPE, and report hazards."
                    ]
                ),
                LessonPage(
                    id: "roles-2",
                    title: "Supervisor Responsibilities",
                    bullets: [
                        "Ensure job hazard analysis and safe work practices are in place.",
                        "Correct unsafe acts and conditions promptly.",
                        "Track abatement actions and verify completion."
                    ]
                ),
                LessonPage(
                    id: "roles-3",
                    title: "Worker Responsibilities",
                    bullets: [
                        "Follow approved procedures and report unsafe conditions.",
                        "Use assigned PPE correctly and maintain it.",
                        "Pause work and elevate risks that exceed controls."
                    ]
                ),
                LessonPage(
                    id: "roles-4",
                    title: "1S0 Inspector Focus",
                    bullets: [
                        "Clarify expectations with leadership before inspections.",
                        "Document findings and coordinate corrective actions.",
                        "Verify abatement and close the loop."
                    ]
                )
            ],
            scenario: Scenario(
                title: "Pre-Inspection Alignment",
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
                            ),
                            ScenarioOption(
                                id: "roles-step-1-c",
                                text: "Skip the brief so you don’t disrupt production and just start the walkthrough.",
                                feedback: "Incorrect. Alignment up front prevents surprises, resistance, and missed scope during the inspection.",
                                isCorrect: false,
                                nextStepId: "roles-step-2"
                            ),
                            ScenarioOption(
                                id: "roles-step-1-d",
                                text: "Brief only the safety office and begin without engaging the shop leadership.",
                                feedback: "Not enough. Safety can support, but shop leadership owns day-to-day execution and needs alignment.",
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
                            ),
                            ScenarioOption(
                                id: "roles-step-2-c",
                                text: "The individual employee only; enforcement is a personal choice.",
                                feedback: "Incorrect. Individuals have responsibilities, but supervisors must enforce standards and correct behavior.",
                                isCorrect: false,
                                nextStepId: "roles-step-3"
                            ),
                            ScenarioOption(
                                id: "roles-step-2-d",
                                text: "The 1S0 inspector should personally correct each employee during the shift.",
                                feedback: "Not the primary fix. 1S0 inspectors can coach, but supervisors own sustained enforcement and training.",
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
                            ),
                            ScenarioOption(
                                id: "roles-step-3-c",
                                text: "Close the issue once it’s written down so the paperwork is complete.",
                                feedback: "Incorrect. Documentation is necessary, but the hazard remains open until controlled or eliminated and verified.",
                                isCorrect: false,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "roles-step-3-d",
                                text: "Tell the employee to work around it; mission comes first.",
                                feedback: "Incorrect. Apply interim controls, document, and elevate risk acceptance as required—don’t normalize unsafe workarounds.",
                                isCorrect: false,
                                nextStepId: nil
                            )
                        ]
                    )
                ]
            ),
            quiz: QuizBank.rolesResponsibilities
        ),
        TrainingModule(
            id: "confined-space",
            title: "Confined Space",
            subtitle: "Entry planning, permits, and hazards",
            estimatedMinutes: 18,
            difficulty: "Core",
            tags: ["Entry", "Permit Required"],
            objectives: [
                "Define a confined space and permit-required space",
                "Identify atmospheric and physical hazards",
                "Apply entry permit and attendant roles",
                "Plan rescue and emergency response"
            ],
            lessonPages: [
                LessonPage(
                    id: "cs-1",
                    title: "Definitions",
                    bullets: [
                        "Confined spaces have limited entry or exit and are not designed for continuous occupancy.",
                        "Permit-required spaces contain hazards such as atmospheric risks or engulfment.",
                        "Always verify local procedures before entry."
                    ]
                ),
                LessonPage(
                    id: "cs-2",
                    title: "Entry Control",
                    bullets: [
                        "Use permits, atmospheric testing, and isolation controls.",
                        "Assign an attendant to monitor conditions and entry status.",
                        "Maintain communication and verify rescue capability."
                    ]
                ),
                LessonPage(
                    id: "cs-3",
                    title: "Rescue",
                    bullets: [
                        "Plan rescue before entry and do not rely solely on external responders.",
                        "Use retrieval systems when feasible.",
                        "Stop entry if conditions change."
                    ]
                )
            ],
            scenario: Scenario(
                title: "Tank Inspection",
                intro: "A crew needs to enter a storage tank for inspection.",
                startStepId: "cs-step-1",
                steps: [
                    ScenarioStep(
                        id: "cs-step-1",
                        prompt: "What is the first requirement before entry?",
                        options: [
                            ScenarioOption(
                                id: "cs-step-1-a",
                                text: "Determine if the space is permit-required and complete a permit.",
                                feedback: "Correct. Confirm classification and complete the permit process.",
                                isCorrect: true,
                                nextStepId: "cs-step-2"
                            ),
                            ScenarioOption(
                                id: "cs-step-1-b",
                                text: "Send a worker inside to inspect quickly.",
                                feedback: "Incorrect. Entry must follow permit requirements.",
                                isCorrect: false,
                                nextStepId: "cs-step-2"
                            ),
                            ScenarioOption(
                                id: "cs-step-1-c",
                                text: "Start ventilation and enter without a permit since the air should improve.",
                                feedback: "Incorrect. You must determine classification and follow the required entry process before entry begins.",
                                isCorrect: false,
                                nextStepId: "cs-step-2"
                            ),
                            ScenarioOption(
                                id: "cs-step-1-d",
                                text: "Assume it’s non-permit because it’s just a storage tank.",
                                feedback: "Incorrect. Classification is based on hazards and configuration—not what the space is used for.",
                                isCorrect: false,
                                nextStepId: "cs-step-2"
                            )
                        ]
                    ),
                    ScenarioStep(
                        id: "cs-step-2",
                        prompt: "What should the attendant do?",
                        options: [
                            ScenarioOption(
                                id: "cs-step-2-a",
                                text: "Monitor entrants and conditions, maintain communication.",
                                feedback: "Correct. The attendant monitors and initiates response if needed.",
                                isCorrect: true,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "cs-step-2-b",
                                text: "Enter the space to assist with the inspection.",
                                feedback: "Incorrect. The attendant should remain outside unless trained and reassigned.",
                                isCorrect: false,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "cs-step-2-c",
                                text: "Leave the post briefly to get tools once the entrant is inside.",
                                feedback: "Incorrect. The attendant must remain at the entry and continuously monitor status and conditions.",
                                isCorrect: false,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "cs-step-2-d",
                                text: "Rely on the entrant to self-monitor and self-rescue if anything changes.",
                                feedback: "Incorrect. The attendant has a specific duty to monitor and initiate evacuation/response.",
                                isCorrect: false,
                                nextStepId: nil
                            )
                        ]
                    )
                ]
            ),
            quiz: QuizBank.confinedSpace
        ),
        TrainingModule(
            id: "hearing-conservation",
            title: "Hearing Conservation",
            subtitle: "Protect against hazardous noise exposure",
            estimatedMinutes: 14,
            difficulty: "Core",
            tags: ["Noise", "PPE"],
            objectives: [
                "Recognize hazardous noise environments",
                "Select and use hearing protection",
                "Understand baseline and annual audiograms",
                "Apply engineering and administrative controls"
            ],
            lessonPages: [
                LessonPage(
                    id: "hc-1",
                    title: "Noise Hazards",
                    bullets: [
                        "Prolonged exposure to high noise can cause permanent hearing loss.",
                        "Identify tasks and areas with hazardous noise levels.",
                        "Use signage and monitoring to communicate risks."
                    ]
                ),
                LessonPage(
                    id: "hc-2",
                    title: "Controls",
                    bullets: [
                        "Use engineering controls to reduce noise at the source.",
                        "Administrative controls limit exposure time.",
                        "Hearing protection is the last line of defense."
                    ]
                ),
                LessonPage(
                    id: "hc-3",
                    title: "Program Elements",
                    bullets: [
                        "Baseline and annual audiograms are required for enrolled personnel.",
                        "Training includes proper fit and care of hearing protection.",
                        "Document and correct threshold shifts."
                    ]
                )
            ],
            scenario: Scenario(
                title: "Flight Line Noise",
                intro: "You observe maintenance near running aircraft engines.",
                startStepId: "hc-step-1",
                steps: [
                    ScenarioStep(
                        id: "hc-step-1",
                        prompt: "What is the best immediate action?",
                        options: [
                            ScenarioOption(
                                id: "hc-step-1-a",
                                text: "Verify hearing protection is used correctly.",
                                feedback: "Correct. Ensure PPE is worn and fitted.",
                                isCorrect: true,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "hc-step-1-b",
                                text: "Ignore it because hearing loss is slow.",
                                feedback: "Incorrect. Exposure can cause permanent damage.",
                                isCorrect: false,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "hc-step-1-c",
                                text: "Let the job continue and remind them to wear protection at the end of the shift.",
                                feedback: "Incorrect. The hazard is occurring now—correct PPE use and exposure controls immediately.",
                                isCorrect: false,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "hc-step-1-d",
                                text: "Post a sign later; PPE compliance is optional if work must continue.",
                                feedback: "Incorrect. Signs and reminders don’t replace immediate control of hazardous exposure.",
                                isCorrect: false,
                                nextStepId: nil
                            )
                        ]
                    )
                ]
            ),
            quiz: QuizBank.hearingConservation
        ),
        TrainingModule(
            id: "mishap-reporting",
            title: "Mishap Reporting",
            subtitle: "Report incidents quickly and accurately",
            estimatedMinutes: 14,
            difficulty: "Core",
            tags: ["Reporting", "Notification"],
            objectives: [
                "Recognize reportable events",
                "Preserve evidence and protect personnel",
                "Follow notification timelines",
                "Coordinate with leadership and safety"
            ],
            lessonPages: [
                LessonPage(
                    id: "mr-1",
                    title: "What to Report",
                    bullets: [
                        "Report injuries, property damage, and near misses per local policy.",
                        "Do not delay reporting while waiting for complete details.",
                        "Safety offices use reports to prevent recurrence."
                    ]
                ),
                LessonPage(
                    id: "mr-2",
                    title: "Initial Actions",
                    bullets: [
                        "Provide medical care and secure the area.",
                        "Preserve evidence for investigation.",
                        "Notify leadership and safety immediately."
                    ]
                ),
                LessonPage(
                    id: "mr-3",
                    title: "Documentation",
                    bullets: [
                        "Document facts, not speculation.",
                        "Capture time, location, and involved personnel.",
                        "Follow local timelines for submission."
                    ]
                )
            ],
            scenario: Scenario(
                title: "Maintenance Injury",
                intro: "A technician receives a minor injury while servicing equipment.",
                startStepId: "mr-step-1",
                steps: [
                    ScenarioStep(
                        id: "mr-step-1",
                        prompt: "Worker injury is reported. What should happen first?",
                        options: [
                            ScenarioOption(
                                id: "mr-step-1-a",
                                text: "Ensure medical care and secure the scene.",
                                feedback: "Correct. Protect personnel and the area first.",
                                isCorrect: true,
                                nextStepId: "mr-step-2"
                            ),
                            ScenarioOption(
                                id: "mr-step-1-b",
                                text: "Wait to see if the injury worsens before reporting.",
                                feedback: "Incorrect. Report promptly per policy.",
                                isCorrect: false,
                                nextStepId: "mr-step-2"
                            ),
                            ScenarioOption(
                                id: "mr-step-1-c",
                                text: "Interview witnesses first so you can write a complete report.",
                                feedback: "Not first. Provide care, prevent further injury, and secure the scene before investigative steps.",
                                isCorrect: false,
                                nextStepId: "mr-step-2"
                            ),
                            ScenarioOption(
                                id: "mr-step-1-d",
                                text: "Keep the job moving and report at the end of the shift.",
                                feedback: "Incorrect. Delayed reporting can miss key facts and may violate notification timelines.",
                                isCorrect: false,
                                nextStepId: "mr-step-2"
                            )
                        ]
                    ),
                    ScenarioStep(
                        id: "mr-step-2",
                        prompt: "What should the report include?",
                        options: [
                            ScenarioOption(
                                id: "mr-step-2-a",
                                text: "Facts such as time, location, and conditions.",
                                feedback: "Correct. Stick to facts and document clearly.",
                                isCorrect: true,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "mr-step-2-b",
                                text: "Speculation about blame.",
                                feedback: "Incorrect. Avoid speculation.",
                                isCorrect: false,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "mr-step-2-c",
                                text: "Only who was at fault so leadership can act quickly.",
                                feedback: "Incorrect. Reports should focus on facts and conditions—avoid blame speculation.",
                                isCorrect: false,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "mr-step-2-d",
                                text: "Nothing until all details are confirmed and finalized.",
                                feedback: "Incorrect. Don’t delay initial reporting while waiting for perfect information—submit facts as known.",
                                isCorrect: false,
                                nextStepId: nil
                            )
                        ]
                    )
                ]
            ),
            quiz: QuizBank.mishapReporting
        ),
        TrainingModule(
            id: "ppe-decision",
            title: "PPE Decision",
            subtitle: "Select PPE based on hazard analysis",
            estimatedMinutes: 12,
            difficulty: "Core",
            tags: ["PPE", "Decision"],
            objectives: [
                "Identify hazards requiring PPE",
                "Select PPE types and fit",
                "Verify PPE condition and use"
            ],
            lessonPages: [
                LessonPage(
                    id: "ppe-1",
                    title: "PPE Selection",
                    bullets: [
                        "Match PPE to the hazard and exposure level.",
                        "Verify PPE is approved and fits properly.",
                        "Inspect PPE before use and replace if damaged."
                    ]
                )
            ],
            scenario: Scenario(
                title: "Grinding Operation",
                intro: "A worker will grind metal with sparks and debris.",
                startStepId: "ppe-step-1",
                steps: [
                    ScenarioStep(
                        id: "ppe-step-1",
                        prompt: "Which PPE is most critical?",
                        options: [
                            ScenarioOption(
                                id: "ppe-step-1-a",
                                text: "Eye/face protection and gloves.",
                                feedback: "Correct. Protect against flying particles and heat.",
                                isCorrect: true,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "ppe-step-1-b",
                                text: "No PPE needed.",
                                feedback: "Incorrect. Grinding creates hazards.",
                                isCorrect: false,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "ppe-step-1-c",
                                text: "Only hearing protection since grinders are loud.",
                                feedback: "Not enough. Noise matters, but the immediate high-severity hazard is flying particles—eye/face protection is critical.",
                                isCorrect: false,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "ppe-step-1-d",
                                text: "Only a dust mask because debris is visible.",
                                feedback: "Incorrect. Respiratory protection may be needed depending on material, but impact/thermal hazards require eye/face and hand protection.",
                                isCorrect: false,
                                nextStepId: nil
                            )
                        ]
                    )
                ]
            ),
            quiz: QuizBank.ppeDecision
        ),
        TrainingModule(
            id: "hazcom",
            title: "Hazard Communication",
            subtitle: "Classify, label, and communicate chemical hazards",
            estimatedMinutes: 16,
            difficulty: "Core",
            tags: ["HazCom", "OSHA 1910.1200"],
            objectives: [
                "Verify chemical labels and Safety Data Sheet access",
                "Identify when HazCom training is required",
                "Assess secondary containers and non-routine task briefings",
                "Connect SDS hazards to storage, PPE, and emergency procedures"
            ],
            lessonPages: [
                LessonPage(
                    id: "hazcom-1",
                    title: "Chemical Right-To-Know",
                    bullets: [
                        "Workers must understand the chemical hazards in their work area.",
                        "HazCom uses labels, Safety Data Sheets, and training to communicate those hazards.",
                        "A written program explains how the organization manages labels, SDS access, and training."
                    ]
                ),
                LessonPage(
                    id: "hazcom-2",
                    title: "Labels And SDSs",
                    bullets: [
                        "Shipped-container labels identify the product, hazards, precautions, pictograms, and supplier.",
                        "Secondary containers need identity and hazard information unless an immediate-use exception applies.",
                        "SDSs must be readily accessible during each work shift."
                    ]
                ),
                LessonPage(
                    id: "hazcom-3",
                    title: "Training Triggers",
                    bullets: [
                        "Train workers at initial assignment and when new chemical hazards are introduced.",
                        "Non-routine tasks require a specific hazard briefing before work starts.",
                        "Storage compatibility comes from SDS data, not from broad hazard class names alone."
                    ]
                )
            ],
            scenario: Scenario(
                title: "Unknown Solvent Bottle",
                intro: "During an inspection, you find an unlabeled spray bottle near a parts washer and workers cannot identify the solvent.",
                startStepId: "hazcom-step-1",
                steps: [
                    ScenarioStep(
                        id: "hazcom-step-1",
                        prompt: "What is your first correction?",
                        options: [
                            ScenarioOption(
                                id: "hazcom-step-1-a",
                                text: "Remove it from use until the identity, label information, and SDS are confirmed.",
                                feedback: "Correct. Workers cannot safely use an unknown chemical.",
                                isCorrect: true,
                                nextStepId: "hazcom-step-2"
                            ),
                            ScenarioOption(
                                id: "hazcom-step-1-b",
                                text: "Smell it to identify the product.",
                                feedback: "Incorrect. Intentional sniff testing is not a safe identification method.",
                                isCorrect: false,
                                nextStepId: "hazcom-step-2"
                            ),
                            ScenarioOption(
                                id: "hazcom-step-1-c",
                                text: "Let experienced workers keep using it.",
                                feedback: "Incorrect. Experience does not replace labels, SDS access, and hazard communication.",
                                isCorrect: false,
                                nextStepId: "hazcom-step-2"
                            ),
                            ScenarioOption(
                                id: "hazcom-step-1-d",
                                text: "Move it to a cabinet and close the finding.",
                                feedback: "Not enough. Storage does not resolve unknown identity or missing hazard information.",
                                isCorrect: false,
                                nextStepId: "hazcom-step-2"
                            )
                        ]
                    ),
                    ScenarioStep(
                        id: "hazcom-step-2",
                        prompt: "Workers say they have never been trained on the solvent. What do you recommend?",
                        options: [
                            ScenarioOption(
                                id: "hazcom-step-2-a",
                                text: "Conduct HazCom training on hazards, labels, SDS location, PPE, and emergency actions before further use.",
                                feedback: "Correct. Training must cover the specific hazards and protective measures.",
                                isCorrect: true,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "hazcom-step-2-b",
                                text: "Have workers initial the SDS and resume work.",
                                feedback: "Incorrect. Initialing a document is not the same as effective training.",
                                isCorrect: false,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "hazcom-step-2-c",
                                text: "Wait for the annual safety day.",
                                feedback: "Incorrect. New chemical hazards require training before exposure continues.",
                                isCorrect: false,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "hazcom-step-2-d",
                                text: "Assign only one worker to use the solvent.",
                                feedback: "Incorrect. Limiting users does not fix missing hazard communication.",
                                isCorrect: false,
                                nextStepId: nil
                            )
                        ]
                    )
                ]
            ),
            quiz: QuizBank.hazardCommunication
        ),
        TrainingModule(
            id: "electrical",
            title: "Electrical Safety",
            subtitle: "Control shock, arc, and temporary wiring hazards",
            estimatedMinutes: 18,
            difficulty: "Core",
            tags: ["Electrical", "OSHA 1910 Subpart S"],
            objectives: [
                "Recognize exposed live parts and inadequate guarding",
                "Evaluate electrical working space and cord use",
                "Apply de-energized work and LOTO principles",
                "Identify when qualified electrical personnel are required"
            ],
            lessonPages: [
                LessonPage(
                    id: "electrical-1",
                    title: "Guard Live Parts",
                    bullets: [
                        "Live parts at 50 volts or more must be guarded against accidental contact.",
                        "Missing covers, open panels, and damaged cords create direct shock hazards.",
                        "Warnings do not replace approved covers, enclosures, or barriers."
                    ]
                ),
                LessonPage(
                    id: "electrical-2",
                    title: "Working Space",
                    bullets: [
                        "Electrical panels need clear access for safe operation and maintenance.",
                        "Storage in electrical working space slows emergency response and exposes workers to arc and shock hazards.",
                        "Disconnects and circuits must be identifiable for normal operation and isolation."
                    ]
                ),
                LessonPage(
                    id: "electrical-3",
                    title: "Safe Work Condition",
                    bullets: [
                        "De-energize equipment before servicing unless energized work is justified and controlled.",
                        "Use LOTO and verify absence of voltage before touching conductors or parts.",
                        "Qualified workers must know the equipment, hazards, and safe work practices."
                    ]
                )
            ],
            scenario: Scenario(
                title: "Open Panel In A Shop",
                intro: "A 480V panel is open, storage blocks the approach, and a mechanic wants to reset a breaker for production.",
                startStepId: "electrical-step-1",
                steps: [
                    ScenarioStep(
                        id: "electrical-step-1",
                        prompt: "What should you do first?",
                        options: [
                            ScenarioOption(
                                id: "electrical-step-1-a",
                                text: "Restrict access, keep unqualified personnel away, and have qualified electrical personnel make the area safe.",
                                feedback: "Correct. Exposed live parts and blocked working space require immediate control.",
                                isCorrect: true,
                                nextStepId: "electrical-step-2"
                            ),
                            ScenarioOption(
                                id: "electrical-step-1-b",
                                text: "Let the mechanic reset the breaker if they wear gloves.",
                                feedback: "Incorrect. PPE alone does not make unqualified energized work acceptable.",
                                isCorrect: false,
                                nextStepId: "electrical-step-2"
                            ),
                            ScenarioOption(
                                id: "electrical-step-1-c",
                                text: "Close the panel door and ignore the storage.",
                                feedback: "Not enough. Working space must remain clear.",
                                isCorrect: false,
                                nextStepId: "electrical-step-2"
                            ),
                            ScenarioOption(
                                id: "electrical-step-1-d",
                                text: "Post caution tape and return during the next inspection cycle.",
                                feedback: "Incorrect. This is an immediate exposure hazard.",
                                isCorrect: false,
                                nextStepId: "electrical-step-2"
                            )
                        ]
                    ),
                    ScenarioStep(
                        id: "electrical-step-2",
                        prompt: "A repair is required inside the panel. What standard control should be planned?",
                        options: [
                            ScenarioOption(
                                id: "electrical-step-2-a",
                                text: "De-energize, lock/tag, verify absence of voltage, and follow qualified electrical work procedures.",
                                feedback: "Correct. Establish an electrically safe work condition before repair.",
                                isCorrect: true,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "electrical-step-2-b",
                                text: "Work energized because troubleshooting is faster.",
                                feedback: "Incorrect. Energized work requires strict justification and controls.",
                                isCorrect: false,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "electrical-step-2-c",
                                text: "Have a coworker stand by the breaker instead of using LOTO.",
                                feedback: "Incorrect. A spotter is not an energy-isolation device.",
                                isCorrect: false,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "electrical-step-2-d",
                                text: "Turn off nearby lights to remind others work is underway.",
                                feedback: "Incorrect. Visual cues do not verify zero energy.",
                                isCorrect: false,
                                nextStepId: nil
                            )
                        ]
                    )
                ]
            ),
            quiz: QuizBank.electricalSafety
        ),
        TrainingModule(
            id: "machine-guarding",
            title: "Machine Guarding",
            subtitle: "Prevent contact with moving machine hazards",
            estimatedMinutes: 18,
            difficulty: "Core",
            tags: ["Machine Guarding", "OSHA 1910 Subpart O"],
            objectives: [
                "Identify point-of-operation and rotating-part hazards",
                "Verify guards are effective and do not create new hazards",
                "Inspect abrasive wheel guarding and setup",
                "Connect machine clearing and maintenance to LOTO"
            ],
            lessonPages: [
                LessonPage(
                    id: "machine-1",
                    title: "Guard The Hazard",
                    bullets: [
                        "Machine guards protect against points of operation, nip points, rotating parts, and flying material.",
                        "A guard must prevent contact while allowing the work to be performed safely.",
                        "Signs and emergency stops supplement guarding; they do not replace required guards."
                    ]
                ),
                LessonPage(
                    id: "machine-2",
                    title: "Abrasive Wheels",
                    bullets: [
                        "Bench grinder tongue guards are adjusted close to the wheel.",
                        "Work rests are kept close enough to prevent material from being pulled into the wheel.",
                        "Damaged wheels and missing guards require removal from service."
                    ]
                ),
                LessonPage(
                    id: "machine-3",
                    title: "Clearing Jams",
                    bullets: [
                        "Jam clearing exposes workers to unexpected motion and stored energy.",
                        "Stop, isolate, lock/tag, and verify before reaching into danger zones.",
                        "Return guards and tools to safe condition before restart."
                    ]
                )
            ],
            scenario: Scenario(
                title: "Bench Grinder Setup",
                intro: "A shop bench grinder has a wide tongue-guard gap and the work rest is far from the wheel.",
                startStepId: "machine-step-1",
                steps: [
                    ScenarioStep(
                        id: "machine-step-1",
                        prompt: "What is the correct inspection action?",
                        options: [
                            ScenarioOption(
                                id: "machine-step-1-a",
                                text: "Stop use until guards and work rest are adjusted within required limits and the wheel is inspected.",
                                feedback: "Correct. The setup can pull material into the wheel or allow fragments to escape.",
                                isCorrect: true,
                                nextStepId: "machine-step-2"
                            ),
                            ScenarioOption(
                                id: "machine-step-1-b",
                                text: "Allow use if operators wear face shields.",
                                feedback: "Incorrect. PPE does not replace machine guarding.",
                                isCorrect: false,
                                nextStepId: "machine-step-2"
                            ),
                            ScenarioOption(
                                id: "machine-step-1-c",
                                text: "Mark it for monthly maintenance and continue use.",
                                feedback: "Incorrect. Guarding deficiencies require immediate control.",
                                isCorrect: false,
                                nextStepId: "machine-step-2"
                            ),
                            ScenarioOption(
                                id: "machine-step-1-d",
                                text: "Reduce grinder speed by half and continue.",
                                feedback: "Incorrect. Speed reduction does not correct improper guarding.",
                                isCorrect: false,
                                nextStepId: "machine-step-2"
                            )
                        ]
                    ),
                    ScenarioStep(
                        id: "machine-step-2",
                        prompt: "A worker wants to clear a jam inside a guarded machine. What should happen?",
                        options: [
                            ScenarioOption(
                                id: "machine-step-2-a",
                                text: "Use the energy control procedure before reaching into the machine.",
                                feedback: "Correct. Jam clearing often requires LOTO and zero-energy verification.",
                                isCorrect: true,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "machine-step-2-b",
                                text: "Jog the machine while pulling the jam free.",
                                feedback: "Incorrect. Jogging exposes the worker to moving parts.",
                                isCorrect: false,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "machine-step-2-c",
                                text: "Use a long screwdriver while the machine idles.",
                                feedback: "Incorrect. Tools can pull the worker into the hazard.",
                                isCorrect: false,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "machine-step-2-d",
                                text: "Let the most experienced worker decide whether to lock out.",
                                feedback: "Incorrect. The energy control requirement is based on exposure, not seniority.",
                                isCorrect: false,
                                nextStepId: nil
                            )
                        ]
                    )
                ]
            ),
            quiz: QuizBank.machineGuarding
        ),
        TrainingModule(
            id: "material-handling",
            title: "Material Handling",
            subtitle: "Control storage, forklift, and hoisting hazards",
            estimatedMinutes: 18,
            difficulty: "Core",
            tags: ["Warehouse", "OSHA 1910.176/178"],
            objectives: [
                "Assess aisle clearance and stable storage",
                "Verify powered industrial truck condition and operator controls",
                "Recognize load, capacity, and elevated-load hazards",
                "Inspect hoisting equipment for rating and condition"
            ],
            lessonPages: [
                LessonPage(
                    id: "material-1",
                    title: "Storage And Aisles",
                    bullets: [
                        "Aisles must be clear, maintained, and marked where mechanical handling equipment is used.",
                        "Materials must be stacked and secured so they do not collapse, slide, or obstruct egress.",
                        "Housekeeping findings often point to deeper traffic-flow and supervision issues."
                    ]
                ),
                LessonPage(
                    id: "material-2",
                    title: "Powered Trucks",
                    bullets: [
                        "Operators must be trained, evaluated, and authorized for the equipment and conditions.",
                        "Defective powered industrial trucks are removed from service.",
                        "Capacity plates and approved attachments define what the truck can safely lift."
                    ]
                ),
                LessonPage(
                    id: "material-3",
                    title: "Hoisting Discipline",
                    bullets: [
                        "Use rated lifting gear compatible with the load and environment.",
                        "Damaged slings, hooks, or hoist components are removed from service.",
                        "No one should stand or pass beneath elevated loads."
                    ]
                )
            ],
            scenario: Scenario(
                title: "Warehouse Reset",
                intro: "Pallets are blocking marked aisles, a forklift has a missing capacity plate, and a worker is about to walk under an elevated load.",
                startStepId: "material-step-1",
                steps: [
                    ScenarioStep(
                        id: "material-step-1",
                        prompt: "Which hazard should be controlled immediately?",
                        options: [
                            ScenarioOption(
                                id: "material-step-1-a",
                                text: "Stop the elevated-load exposure and move pedestrians out of the lift path.",
                                feedback: "Correct. Personnel under loads face immediate crushing risk.",
                                isCorrect: true,
                                nextStepId: "material-step-2"
                            ),
                            ScenarioOption(
                                id: "material-step-1-b",
                                text: "Start repainting aisle lines first.",
                                feedback: "Incorrect. Markings matter, but the elevated-load exposure is immediate.",
                                isCorrect: false,
                                nextStepId: "material-step-2"
                            ),
                            ScenarioOption(
                                id: "material-step-1-c",
                                text: "Ask the operator to hurry before the pedestrian crosses.",
                                feedback: "Incorrect. Speed increases risk and does not control the hazard.",
                                isCorrect: false,
                                nextStepId: "material-step-2"
                            ),
                            ScenarioOption(
                                id: "material-step-1-d",
                                text: "Document only the blocked aisles.",
                                feedback: "Not enough. Multiple material-handling hazards are present.",
                                isCorrect: false,
                                nextStepId: "material-step-2"
                            )
                        ]
                    ),
                    ScenarioStep(
                        id: "material-step-2",
                        prompt: "What should happen to the forklift with the missing capacity plate?",
                        options: [
                            ScenarioOption(
                                id: "material-step-2-a",
                                text: "Remove it from service until capacity information is restored and verified.",
                                feedback: "Correct. Operators need verified capacity and configuration data.",
                                isCorrect: true,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "material-step-2-b",
                                text: "Use it only for light pallets.",
                                feedback: "Incorrect. Guessing load capacity is not a control.",
                                isCorrect: false,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "material-step-2-c",
                                text: "Let the senior operator approve each lift.",
                                feedback: "Incorrect. Operator experience does not replace required equipment information.",
                                isCorrect: false,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "material-step-2-d",
                                text: "Photograph the missing plate and close the finding.",
                                feedback: "Incorrect. Documentation without removal from service leaves the hazard active.",
                                isCorrect: false,
                                nextStepId: nil
                            )
                        ]
                    )
                ]
            ),
            quiz: QuizBank.materialHandling
        ),
        TrainingModule(
            id: "fire-hot-work",
            title: "Fire / Hot Work",
            subtitle: "Prevent ignition, blocked egress, and extinguisher failures",
            estimatedMinutes: 18,
            difficulty: "Core",
            tags: ["Fire", "Hot Work", "OSHA 1910.157/252"],
            objectives: [
                "Verify hot work permits and fire-watch controls",
                "Inspect fire extinguisher access and maintenance status",
                "Recognize blocked exits and ignition paths",
                "Assess flammable storage and cylinder separation"
            ],
            lessonPages: [
                LessonPage(
                    id: "fire-1",
                    title: "Hot Work Controls",
                    bullets: [
                        "Hot work requires area inspection, combustible control, authorization, and emergency readiness.",
                        "Fire watch is required when combustibles cannot be moved or protected adequately.",
                        "Sparks can travel through openings into concealed spaces."
                    ]
                ),
                LessonPage(
                    id: "fire-2",
                    title: "Extinguishers And Exits",
                    bullets: [
                        "Portable extinguishers must be accessible and maintained.",
                        "Exit routes must remain free and unobstructed.",
                        "Fire equipment deficiencies require immediate replacement or correction."
                    ]
                ),
                LessonPage(
                    id: "fire-3",
                    title: "Flammables",
                    bullets: [
                        "Flammable liquids require compatible containers, labels, closed storage, and quantity control.",
                        "Oxygen and fuel-gas cylinders need proper separation or a rated barrier when stored.",
                        "Never weld or cut on containers until residues are removed and the container is made safe."
                    ]
                )
            ],
            scenario: Scenario(
                title: "Maintenance Bay Hot Work",
                intro: "A welder is ready to cut brackets near cardboard packaging, a wall opening, and a blocked extinguisher.",
                startStepId: "fire-step-1",
                steps: [
                    ScenarioStep(
                        id: "fire-step-1",
                        prompt: "What must happen before hot work starts?",
                        options: [
                            ScenarioOption(
                                id: "fire-step-1-a",
                                text: "Move or protect combustibles, clear extinguisher access, cover openings, and complete hot work authorization.",
                                feedback: "Correct. Fire prevention controls come before ignition sources are introduced.",
                                isCorrect: true,
                                nextStepId: "fire-step-2"
                            ),
                            ScenarioOption(
                                id: "fire-step-1-b",
                                text: "Start cutting and assign someone to watch for smoke.",
                                feedback: "Incorrect. Fire watch does not replace pre-work hazard control.",
                                isCorrect: false,
                                nextStepId: "fire-step-2"
                            ),
                            ScenarioOption(
                                id: "fire-step-1-c",
                                text: "Move the cardboard but leave the wall opening uncovered.",
                                feedback: "Not enough. Sparks can travel into concealed spaces.",
                                isCorrect: false,
                                nextStepId: "fire-step-2"
                            ),
                            ScenarioOption(
                                id: "fire-step-1-d",
                                text: "Use a smaller torch tip and continue.",
                                feedback: "Incorrect. Reducing torch size does not control combustibles or blocked fire equipment.",
                                isCorrect: false,
                                nextStepId: "fire-step-2"
                            )
                        ]
                    ),
                    ScenarioStep(
                        id: "fire-step-2",
                        prompt: "Combustibles cannot be moved more than 35 feet away. What control is required?",
                        options: [
                            ScenarioOption(
                                id: "fire-step-2-a",
                                text: "Protect the combustibles and post a fire watch during work and for at least 30 minutes after.",
                                feedback: "Correct. Fire watch addresses ignition risk that remains after protection measures.",
                                isCorrect: true,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "fire-step-2-b",
                                text: "Proceed if the welder has completed annual training.",
                                feedback: "Incorrect. Training does not eliminate the fire-watch requirement.",
                                isCorrect: false,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "fire-step-2-c",
                                text: "Stop only if flames are visible.",
                                feedback: "Incorrect. Prevention happens before ignition.",
                                isCorrect: false,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "fire-step-2-d",
                                text: "Leave a note for the next shift to inspect the area.",
                                feedback: "Incorrect. The post-work fire watch is part of the active control.",
                                isCorrect: false,
                                nextStepId: nil
                            )
                        ]
                    )
                ]
            ),
            quiz: QuizBank.fireHotWork
        ),

        // MARK: - Deployed ORM

        TrainingModule(
            id: "deployed-orm",
            title: "Deployed ORM",
            subtitle: "Manage operational risk at contingency and deployed locations",
            estimatedMinutes: 25,
            difficulty: "Advanced",
            tags: ["ORM", "Contingency Ops"],
            objectives: [
                "Apply the 5-step ORM process in austere and time-compressed environments",
                "Identify risk acceptance authority levels for residual risk in deployed settings",
                "Navigate mission-vs-safety tensions when commanders push to accept elevated risk",
                "Assess host-nation compliance gaps and your obligations under DAFI 91-202",
                "Document risk decisions and recommendations even in expeditionary conditions"
            ],
            lessonPages: [
                LessonPage(
                    id: "dorm-1",
                    title: "ORM in Deployed Environments",
                    bullets: [
                        "Deployed locations rarely have a fully established safety office, reference library, or inspection history.",
                        "Standards that are clear-cut in garrison become ambiguous in austere settings — temporary structures, expedient repairs, and improvised work areas are the norm.",
                        "Decision timelines compress dramatically. Commanders need answers in hours, not weeks.",
                        "Your responsibilities as the 1S0 safety inspector do not change: identify hazards, assess risk, recommend controls, and inform the commander."
                    ]
                ),
                LessonPage(
                    id: "dorm-2",
                    title: "The 5-Step ORM Process Downrange",
                    bullets: [
                        "Step 1 — Identify Hazards: Walk the site. In deployed settings, hazards hide in expedient solutions and workarounds that would never pass garrison inspection.",
                        "Step 2 — Assess Risk: Use the standard severity × probability matrix, but recognize that deployed conditions often increase probability (limited PPE, fatigued workers, improvised setups).",
                        "Step 3 — Analyze Controls: The full hierarchy of controls still applies, but engineering controls may require creativity with limited materials.",
                        "Step 4 — Make Risk Decisions: Present the risk assessment clearly. The commander decides — you inform. Document the decision regardless of outcome.",
                        "Step 5 — Supervise and Evaluate: Controls that work on day one may degrade quickly in harsh environments. Re-assess regularly."
                    ]
                ),
                LessonPage(
                    id: "dorm-3",
                    title: "Risk Acceptance Authority",
                    bullets: [
                        "Low residual risk: Flight/CC or equivalent can accept.",
                        "Medium residual risk: Squadron/CC level acceptance required.",
                        "High residual risk: Group/CC (O-6) or equivalent must accept.",
                        "Extremely High residual risk: Wing/CC or equivalent — rarely acceptable outside combat operations.",
                        "The inspector NEVER accepts risk — you prepare the assessment and the appropriate commander signs. This distinction matters especially when pressured."
                    ]
                ),
                LessonPage(
                    id: "dorm-4",
                    title: "Common Deployed Hazards",
                    bullets: [
                        "Generator operations: CO exposure from inadequate setback distances, fuel handling in improvised storage, electrical distribution from temporary panels.",
                        "Temporary structures: Fabric shelters degrade in UV/sand, tent city fire separation, improvised maintenance facilities.",
                        "Expedient repairs: Unqualified personnel performing work outside their AFSC, bypassing safety devices to meet mission timelines.",
                        "HAZMAT with limited supplies: Expired PPE, incomplete spill kits, no industrial hygiene monitoring capability.",
                        "Host-nation compliance: Contract language vs. DAFI 91-202 obligations, SOFA implications, cultural differences in safety practices."
                    ]
                ),
                LessonPage(
                    id: "dorm-5",
                    title: "The Inspector's Gray Area",
                    bullets: [
                        "When standards do not cleanly apply, your job is to identify the hazard and assess the risk — not to force a garrison solution onto a deployed problem.",
                        "Credibility comes from offering alternatives, not just saying 'no.' Find the option that supports the mission AND reduces risk.",
                        "Document everything. In the absence of formal inspection reports, emails, photos, and risk assessment worksheets become your record.",
                        "Fatigue, isolation, and mission pressure affect your judgment too. Apply ORM to yourself — know when you need a second opinion.",
                        "The best deployed safety professionals are the ones commanders seek out before making decisions, not the ones they try to avoid."
                    ]
                ),
            ],
            scenario: Scenario(
                title: "Sandstorm Damage Assessment",
                intro: "You are the deployed 1S0 safety inspector at a bare base in Southwest Asia. A major sandstorm has damaged several temporary structures and equipment. The Operations Group Commander needs your risk assessment before resuming flight operations. You have 2 hours before the next launch window.",
                startStepId: "storm-1",
                steps: [
                    ScenarioStep(
                        id: "storm-1",
                        prompt: "You arrive at the flight line to begin your assessment. Multiple structures and systems are damaged. Where do you start?",
                        options: [
                            ScenarioOption(
                                id: "storm-1-a",
                                text: "Assess occupied structures first — personnel in damaged buildings are the immediate life-safety priority.",
                                feedback: "Correct. Life safety comes first in any assessment. Occupied structures with potential collapse risk must be evaluated before equipment or operational assets. This follows the ORM principle of addressing the highest severity hazards first.",
                                isCorrect: true,
                                nextStepId: "storm-2"
                            ),
                            ScenarioOption(
                                id: "storm-1-b",
                                text: "Start with the flight line equipment since the commander needs to know about launch capability.",
                                feedback: "Incorrect. While the commander wants operational answers, occupied structures with collapse potential are a higher severity hazard. Equipment can be assessed after confirming personnel safety.",
                                isCorrect: false,
                                nextStepId: "storm-2"
                            ),
                            ScenarioOption(
                                id: "storm-1-c",
                                text: "Begin a systematic left-to-right sweep of the entire base to document all damage.",
                                feedback: "Incorrect. A systematic sweep is thorough but does not prioritize. With a 2-hour window, you need to triage by risk severity — occupied structures first, then operational assets.",
                                isCorrect: false,
                                nextStepId: "storm-2"
                            ),
                            ScenarioOption(
                                id: "storm-1-d",
                                text: "Ask the commander which assets they want assessed first.",
                                feedback: "Incorrect. The commander wants an operational answer, but the safety professional determines assessment priority based on hazard severity, not mission preference.",
                                isCorrect: false,
                                nextStepId: "storm-2"
                            )
                        ]
                    ),
                    ScenarioStep(
                        id: "storm-2",
                        prompt: "During your assessment, you discover a damaged fuel bladder with a slow JP-8 seep near the aircraft parking area. The Ops Group Commander wants maintenance crews to patch it and continue flight ops. What do you recommend?",
                        options: [
                            ScenarioOption(
                                id: "storm-2-a",
                                text: "Evacuate the immediate area, establish a hazard perimeter, and assess the full extent of the seep before any repair attempt.",
                                feedback: "Correct. An uncontrolled fuel leak near an active flight line creates fire/explosion risk. You must establish the extent of contamination before allowing personnel into the area. Patching without assessment could miss a larger structural failure in the bladder.",
                                isCorrect: true,
                                nextStepId: "storm-3"
                            ),
                            ScenarioOption(
                                id: "storm-2-b",
                                text: "Allow the patch if maintenance uses proper PPE and has a fire extinguisher standing by.",
                                feedback: "Incorrect. PPE and fire extinguishers do not address the root issue — the extent of the damage and contamination is unknown. A small visible seep may indicate a larger structural failure.",
                                isCorrect: false,
                                nextStepId: "storm-3"
                            ),
                            ScenarioOption(
                                id: "storm-2-c",
                                text: "Recommend switching to a backup fuel source and abandoning the damaged bladder entirely.",
                                feedback: "Partially correct in concept, but premature. Assessment must come first — the bladder may be repairable once the damage extent is known. Abandoning it without assessment wastes a critical resource.",
                                isCorrect: false,
                                nextStepId: "storm-3"
                            ),
                            ScenarioOption(
                                id: "storm-2-d",
                                text: "This is a fuels issue, not a safety issue. Defer to the POL team.",
                                feedback: "Incorrect. A fuel leak on the flight line is absolutely a safety issue — fire/explosion risk and environmental contamination fall within your scope. Coordinate with POL, but do not abdicate your assessment responsibility.",
                                isCorrect: false,
                                nextStepId: "storm-3"
                            )
                        ]
                    ),
                    ScenarioStep(
                        id: "storm-3",
                        prompt: "The base control tower has visible cracking in the temporary structure walls. The commander suggests controllers can operate from a ground vehicle with radio equipment as an alternative. What is your assessment?",
                        options: [
                            ScenarioOption(
                                id: "storm-3-a",
                                text: "Support the vehicle-based alternative, document the tower as off-limits, and request a structural engineering assessment.",
                                feedback: "Correct. The commander proposed a creative alternative that avoids the structural risk. Your responsibility is to validate that the alternative is safe and ensure the damaged structure is formally restricted. Requesting engineering assessment is the right follow-up for the permanent fix.",
                                isCorrect: true,
                                nextStepId: "storm-4"
                            ),
                            ScenarioOption(
                                id: "storm-3-b",
                                text: "The tower must remain operational — recommend reinforcing the cracked walls with available materials.",
                                feedback: "Incorrect. Improvised structural repairs to a cracked temporary structure are unreliable. The commander already offered a viable alternative. There is no need to accept structural risk when the mission can continue from a vehicle.",
                                isCorrect: false,
                                nextStepId: "storm-4"
                            ),
                            ScenarioOption(
                                id: "storm-3-c",
                                text: "Shut down all flight operations until the tower is repaired or replaced.",
                                feedback: "Disproportionate. The commander's vehicle-based alternative allows safe continuation of operations. Shutting down completely when a viable workaround exists is not adding value — it is being an unnecessary mission stopper.",
                                isCorrect: false,
                                nextStepId: "storm-4"
                            ),
                            ScenarioOption(
                                id: "storm-3-d",
                                text: "Allow limited tower use with reduced occupancy until engineering assesses it.",
                                feedback: "Incorrect. Cracked walls in a temporary structure indicate potential failure. 'Reduced occupancy' does not reduce collapse risk — it just means fewer people are at risk. The vehicle alternative eliminates the hazard entirely.",
                                isCorrect: false,
                                nextStepId: "storm-4"
                            )
                        ]
                    ),
                    ScenarioStep(
                        id: "storm-4",
                        prompt: "The Ops Group Commander asks you to sign a risk acceptance letter stating that flight operations can safely resume with your identified mitigations in place. What do you do?",
                        options: [
                            ScenarioOption(
                                id: "storm-4-a",
                                text: "Prepare the risk assessment documenting hazards, controls, and residual risk — but the commander signs the acceptance, not you.",
                                feedback: "Correct. Safety professionals prepare risk assessments and recommend controls. Commanders accept risk. This is a fundamental ORM principle. Your signature goes on the assessment, not the acceptance. The commander's signature acknowledges they understand and accept the residual risk.",
                                isCorrect: true,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "storm-4-b",
                                text: "Sign it — you have assessed the risks and your mitigations are in place.",
                                feedback: "Incorrect. Signing a risk acceptance letter exceeds your authority as the 1S0 inspector. If something goes wrong, you have taken personal liability for a command decision. Your job is to inform, not to accept risk on behalf of the organization.",
                                isCorrect: false,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "storm-4-c",
                                text: "Refuse to prepare any documentation until all hazards are fully resolved.",
                                feedback: "Incorrect. Deployed operations often proceed with residual risk — that is the nature of contingency operations. Your job is to document the risk clearly so the commander can make an informed decision, not to hold documentation hostage until risk is zero.",
                                isCorrect: false,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "storm-4-d",
                                text: "Tell the commander risk acceptance letters are not required at deployed locations.",
                                feedback: "Incorrect. Risk documentation is arguably MORE important in deployed settings where oversight is limited. The lack of a garrison safety office does not eliminate the requirement to document risk decisions.",
                                isCorrect: false,
                                nextStepId: nil
                            )
                        ]
                    )
                ]
            ),
            quiz: QuizBank.deployedORM
        )
    ]


    static let allQuizQuestions: [QuizQuestion] = modules.flatMap { $0.quiz }

    static func modules(for role: TrainingRole?) -> [TrainingModule] {
        modules
    }

    static func allQuizQuestions(for role: TrainingRole?) -> [QuizQuestion] {
        modules(for: role).flatMap { $0.quiz }
    }

    static let references: [ReferenceSource] = [
        ReferenceSource(
            id: "saferep-ios",
            title: "SAFEREP - Air Force Safety Center App Store Listing",
            date: "Accessed May 28, 2026",
            notes: "Official Air Force Safety Center app for reporting hazardous conditions or events.",
            url: URL(string: "https://apps.apple.com/us/app/saferep/id1406996346")
        ),
        ReferenceSource(
            id: "osha-1910-95",
            title: "OSHA 29 CFR 1910.95 - Occupational noise exposure",
            date: "Accessed May 27, 2026",
            notes: "Hearing conservation program elements and exposure requirements."
        ),
        ReferenceSource(
            id: "osha-1910-147",
            title: "OSHA 29 CFR 1910.147 - The control of hazardous energy (lockout/tagout)",
            date: "Accessed May 27, 2026",
            notes: "Sequence of lockout/tagout and program requirements."
        ),
        ReferenceSource(
            id: "osha-1910-146",
            title: "OSHA 29 CFR 1910.146 - Permit-required confined spaces",
            date: "Accessed May 27, 2026",
            notes: "Confined space entry requirements and roles."
        ),
        ReferenceSource(
            id: "osha-1910-1200",
            title: "OSHA 29 CFR 1910.1200 - Hazard Communication",
            date: "Accessed May 27, 2026",
            notes: "Chemical labels, safety data sheets, and hazard communication training requirements."
        ),
        ReferenceSource(
            id: "osha-1910-132-134",
            title: "OSHA 29 CFR 1910.132 and 1910.134 - PPE and Respiratory Protection",
            date: "Accessed May 27, 2026",
            notes: "PPE assessment, selection, and respiratory protection terminology."
        ),
        ReferenceSource(
            id: "osha-1910-subpart-s",
            title: "OSHA 29 CFR 1910 Subpart S - Electrical",
            date: "Accessed May 27, 2026",
            notes: "Electrical guarding, working space, flexible cord, and safe installation requirements."
        ),
        ReferenceSource(
            id: "osha-1910-subpart-o",
            title: "OSHA 29 CFR 1910 Subpart O - Machinery and Machine Guarding",
            date: "Accessed May 27, 2026",
            notes: "Machine guarding, abrasive wheel, and mechanical power transmission requirements."
        ),
        ReferenceSource(
            id: "osha-1910-176-178",
            title: "OSHA 29 CFR 1910.176 and 1910.178 - Material Handling and Powered Industrial Trucks",
            date: "Accessed May 27, 2026",
            notes: "Storage, aisle, powered industrial truck, operator evaluation, and equipment condition requirements."
        ),
        ReferenceSource(
            id: "osha-1910-252",
            title: "OSHA 29 CFR 1910 Subpart Q - Welding, Cutting, and Brazing",
            date: "Accessed May 27, 2026",
            notes: "Hot work controls, fire prevention, and related requirements."
        ),
        ReferenceSource(
            id: "osha-1910-157",
            title: "OSHA 29 CFR 1910.157 - Portable Fire Extinguishers",
            date: "Accessed May 27, 2026",
            notes: "Portable extinguisher access, inspection, maintenance, and training requirements."
        ),
        ReferenceSource(
            id: "osha-1910-subpart-d",
            title: "OSHA 29 CFR 1910 Subpart D - Walking-Working Surfaces and Training",
            date: "Accessed May 27, 2026",
            notes: "Fall protection thresholds, systems, and training requirements."
        ),
        ReferenceSource(
            id: "dafi-91-202",
            title: "DAFI 91-202 - Department of the Air Force Mishap Prevention Program",
            date: "20 Mar 2020, incorporating Change 1 (10 Apr 2024) and DAFGM2026-01 (26 Feb 2026)",
            notes: "DAF hazard reporting, near-miss reporting, hazard abatement, and mishap prevention program responsibilities."
        ),
        ReferenceSource(
            id: "dafi-91-207",
            title: "DAFI 91-207 - The US Air Force Traffic Safety Program",
            date: "Accessed May 27, 2026",
            notes: "Motorcycle safety program requirements and rider responsibilities."
        ),
        ReferenceSource(
            id: "dafman-91-203",
            title: "DAFMAN 91-203 - Air Force Occupational Safety, Fire, and Health Standards",
            date: "24 Feb 2026",
            notes: "Safety program responsibilities and hazard abatement references for the Air Force safety program."
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
