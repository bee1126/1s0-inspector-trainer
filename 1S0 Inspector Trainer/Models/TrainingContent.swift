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
                                text: "The inspector should personally correct each employee during the shift.",
                                feedback: "Not the primary fix. Inspectors can coach, but supervisors own sustained enforcement and training.",
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
                            ),
                            ScenarioOption(
                                id: "abatement-step-1-c",
                                text: "Tell people to watch their step and keep the cable where it is.",
                                feedback: "Not enough. Verbal reminders are weak controls—reduce exposure with a physical control and document the hazard.",
                                isCorrect: false,
                                nextStepId: "abatement-step-2"
                            ),
                            ScenarioOption(
                                id: "abatement-step-1-d",
                                text: "Close the hazard because it’s only a near miss, not an injury.",
                                feedback: "Incorrect. Near misses are signals—control the hazard now and track corrective action to prevent injury.",
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
                            ),
                            ScenarioOption(
                                id: "abatement-step-2-c",
                                text: "The newest worker because they noticed it first.",
                                feedback: "Incorrect. Ownership must sit with a person/team who has authority and resources to fix the hazard.",
                                isCorrect: false,
                                nextStepId: "abatement-step-3"
                            ),
                            ScenarioOption(
                                id: "abatement-step-2-d",
                                text: "The inspector who documented it must personally fix it.",
                                feedback: "Not usually. Inspectors drive accountability and verification; the process owner is responsible for correction.",
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
                            ),
                            ScenarioOption(
                                id: "abatement-step-3-c",
                                text: "Once leadership verbally accepts the risk.",
                                feedback: "Incorrect. Risk acceptance does not equal abatement—closure requires a verified effective corrective action.",
                                isCorrect: false,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "abatement-step-3-d",
                                text: "As soon as interim controls are installed.",
                                feedback: "Not necessarily. Interim controls reduce risk but do not automatically close the hazard without verified long-term effectiveness.",
                                isCorrect: false,
                                nextStepId: nil
                            )
                        ]
                    )
                ]
            ),
            quiz: QuizBank.hazardAbatement
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
                            ),
                            ScenarioOption(
                                id: "rac-step-1-c",
                                text: "Assign severity only and skip probability since it’s performed daily anyway.",
                                feedback: "Incorrect. RAC requires both severity and probability—frequency/exposure influences probability.",
                                isCorrect: false,
                                nextStepId: "rac-step-2"
                            ),
                            ScenarioOption(
                                id: "rac-step-1-d",
                                text: "Assign RAC based on cost and schedule impact of the fix.",
                                feedback: "Incorrect. RAC reflects risk, not convenience—use severity/probability criteria.",
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
                            ),
                            ScenarioOption(
                                id: "rac-step-2-c",
                                text: "Write it as an observation without a RAC so the shop can decide urgency.",
                                feedback: "Not enough. A consistent RAC supports prioritization and proper escalation for abatement.",
                                isCorrect: false,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "rac-step-2-d",
                                text: "Post a warning sign and close the hazard as controlled.",
                                feedback: "Incorrect. Signs may be interim controls, but they don’t justify closing a high-risk hazard without verified effective correction.",
                                isCorrect: false,
                                nextStepId: nil
                            )
                        ]
                    )
                ]
            ),
            quiz: QuizBank.racSystem
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
            id: "hot-work",
            title: "Hot Work",
            subtitle: "Fire prevention during cutting and welding",
            estimatedMinutes: 16,
            difficulty: "Core",
            tags: ["Fire Prevention", "Permit"],
            objectives: [
                "Identify hot work hazards",
                "Apply hot work permit controls",
                "Establish fire watch requirements",
                "Verify area readiness after work"
            ],
            lessonPages: [
                LessonPage(
                    id: "hw-1",
                    title: "Hot Work Risks",
                    bullets: [
                        "Hot work produces sparks, heat, and slag that can ignite combustibles.",
                        "Verify surrounding areas are clear or protected.",
                        "Use permits and follow local fire prevention procedures."
                    ]
                ),
                LessonPage(
                    id: "hw-2",
                    title: "Fire Watch",
                    bullets: [
                        "Assign a trained fire watch when required.",
                        "Maintain firefighting equipment nearby.",
                        "Monitor the area after work is complete."
                    ]
                ),
                LessonPage(
                    id: "hw-3",
                    title: "Closeout",
                    bullets: [
                        "Inspect the work area for smoldering materials.",
                        "Secure gas cylinders and equipment.",
                        "Document completion per permit requirements."
                    ]
                )
            ],
            scenario: Scenario(
                title: "Cutting in the Hangar",
                intro: "A team needs to cut metal inside a hangar bay.",
                startStepId: "hw-step-1",
                steps: [
                    ScenarioStep(
                        id: "hw-step-1",
                        prompt: "What must be done before cutting begins?",
                        options: [
                            ScenarioOption(
                                id: "hw-step-1-a",
                                text: "Complete a hot work permit and clear combustibles.",
                                feedback: "Correct. Permit and area prep are required.",
                                isCorrect: true,
                                nextStepId: "hw-step-2"
                            ),
                            ScenarioOption(
                                id: "hw-step-1-b",
                                text: "Start immediately to save time.",
                                feedback: "Incorrect. Hot work requires controls before starting.",
                                isCorrect: false,
                                nextStepId: "hw-step-2"
                            ),
                            ScenarioOption(
                                id: "hw-step-1-c",
                                text: "Post a warning sign and begin since everyone knows it’s hot work.",
                                feedback: "Not enough. A sign doesn’t verify combustibles are controlled or that permit requirements are met.",
                                isCorrect: false,
                                nextStepId: "hw-step-2"
                            ),
                            ScenarioOption(
                                id: "hw-step-1-d",
                                text: "Proceed if a fire extinguisher is nearby, even without a permit.",
                                feedback: "Incorrect. Extinguishers support response; they don’t replace hazard evaluation, permitting, and area prep.",
                                isCorrect: false,
                                nextStepId: "hw-step-2"
                            )
                        ]
                    ),
                    ScenarioStep(
                        id: "hw-step-2",
                        prompt: "What is the fire watch role?",
                        options: [
                            ScenarioOption(
                                id: "hw-step-2-a",
                                text: "Monitor for fire during and after work.",
                                feedback: "Correct. Fire watch monitors for hazards.",
                                isCorrect: true,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "hw-step-2-b",
                                text: "Leave once cutting is done.",
                                feedback: "Incorrect. Fire watch continues after work.",
                                isCorrect: false,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "hw-step-2-c",
                                text: "Help with cutting while keeping an eye out for fire.",
                                feedback: "Incorrect. Fire watch must remain focused on monitoring—splitting duties increases miss risk.",
                                isCorrect: false,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "hw-step-2-d",
                                text: "Focus only on PPE compliance; area monitoring is the welder’s job.",
                                feedback: "Incorrect. Fire watch monitors the work area and adjacent exposures during and after hot work.",
                                isCorrect: false,
                                nextStepId: nil
                            )
                        ]
                    )
                ]
            ),
            quiz: QuizBank.hotWork
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
                        prompt: "What should you do first?",
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
            id: "investigation-basics",
            title: "Investigation Basics",
            subtitle: "Collect facts and identify root causes",
            estimatedMinutes: 16,
            difficulty: "Core",
            tags: ["Investigation", "Root Cause"],
            objectives: [
                "Preserve evidence and collect statements",
                "Differentiate proximate and root causes",
                "Document findings clearly",
                "Recommend corrective actions"
            ],
            lessonPages: [
                LessonPage(
                    id: "inv-1",
                    title: "Preserve Evidence",
                    bullets: [
                        "Secure the area and prevent evidence loss.",
                        "Photograph conditions and equipment.",
                        "Capture witness statements promptly."
                    ]
                ),
                LessonPage(
                    id: "inv-2",
                    title: "Root Cause",
                    bullets: [
                        "Proximate causes are immediate actions or conditions.",
                        "Root causes are underlying system or process failures.",
                        "Corrective actions should address root causes."
                    ]
                ),
                LessonPage(
                    id: "inv-3",
                    title: "Recommendations",
                    bullets: [
                        "Recommend practical, measurable controls.",
                        "Assign responsibility and timelines.",
                        "Track closure to prevent recurrence."
                    ]
                )
            ],
            scenario: Scenario(
                title: "Slip Incident",
                intro: "A worker slips on a wet floor in a maintenance bay.",
                startStepId: "inv-step-1",
                steps: [
                    ScenarioStep(
                        id: "inv-step-1",
                        prompt: "What should you capture first?",
                        options: [
                            ScenarioOption(
                                id: "inv-step-1-a",
                                text: "Photos and witness statements of conditions.",
                                feedback: "Correct. Preserve evidence immediately.",
                                isCorrect: true,
                                nextStepId: "inv-step-2"
                            ),
                            ScenarioOption(
                                id: "inv-step-1-b",
                                text: "Assumptions about who is at fault.",
                                feedback: "Incorrect. Focus on facts first.",
                                isCorrect: false,
                                nextStepId: "inv-step-2"
                            ),
                            ScenarioOption(
                                id: "inv-step-1-c",
                                text: "Clean up the area first, then take photos once it’s safe.",
                                feedback: "Be careful. Make it safe, but preserve and document perishable evidence before it’s lost whenever possible.",
                                isCorrect: false,
                                nextStepId: "inv-step-2"
                            ),
                            ScenarioOption(
                                id: "inv-step-1-d",
                                text: "Wait until the end of the day to interview witnesses so memories settle.",
                                feedback: "Incorrect. Witness recollection degrades quickly—capture statements and conditions as soon as practical.",
                                isCorrect: false,
                                nextStepId: "inv-step-2"
                            )
                        ]
                    ),
                    ScenarioStep(
                        id: "inv-step-2",
                        prompt: "A root cause might be:",
                        options: [
                            ScenarioOption(
                                id: "inv-step-2-a",
                                text: "Lack of a spill response procedure.",
                                feedback: "Correct. Root causes address system failures.",
                                isCorrect: true,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "inv-step-2-b",
                                text: "The slip itself.",
                                feedback: "Incorrect. The slip is the event, not the root cause.",
                                isCorrect: false,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "inv-step-2-c",
                                text: "The floor was wet.",
                                feedback: "That’s a condition/proximate factor. Root causes explain why the condition existed and wasn’t controlled.",
                                isCorrect: false,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "inv-step-2-d",
                                text: "The worker was careless.",
                                feedback: "Not sufficient. Go deeper—training, procedures, environment, supervision, and barriers are typical root-cause areas.",
                                isCorrect: false,
                                nextStepId: nil
                            )
                        ]
                    )
                ]
            ),
            quiz: QuizBank.investigationBasics
        ),
        TrainingModule(
            id: "jha-builder",
            title: "JHA Fundamentals",
            subtitle: "Build job hazard analyses",
            estimatedMinutes: 12,
            difficulty: "Core",
            tags: ["JHA", "Controls"],
            objectives: [
                "Identify task steps and hazards",
                "Select controls using the hierarchy",
                "Document JHA for briefings and execution"
            ],
            lessonPages: [
                LessonPage(
                    id: "jha-1",
                    title: "Task Breakdown",
                    bullets: [
                        "Break work into clear steps.",
                        "Identify hazards for each step.",
                        "Focus on conditions and behaviors."
                    ]
                ),
                LessonPage(
                    id: "jha-2",
                    title: "Controls",
                    bullets: [
                        "Use the hierarchy of controls to reduce risk.",
                        "Assign responsibilities and timelines.",
                        "Verify controls before execution."
                    ]
                )
            ],
            scenario: Scenario(
                title: "Equipment Move",
                intro: "A team must move heavy equipment into a shop bay.",
                startStepId: "jha-step-1",
                steps: [
                    ScenarioStep(
                        id: "jha-step-1",
                        prompt: "What is a key first step in a JHA?",
                        options: [
                            ScenarioOption(
                                id: "jha-step-1-a",
                                text: "Break the task into steps and identify hazards.",
                                feedback: "Correct. Start with the task breakdown.",
                                isCorrect: true,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "jha-step-1-b",
                                text: "Skip the hazards and rely on PPE.",
                                feedback: "Incorrect. Identify hazards and controls first.",
                                isCorrect: false,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "jha-step-1-c",
                                text: "Start moving equipment and write the JHA afterward.",
                                feedback: "Incorrect. JHA is a planning tool—do it before execution so controls are in place before exposure.",
                                isCorrect: false,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "jha-step-1-d",
                                text: "Skip the JHA because the team has moved equipment before.",
                                feedback: "Incorrect. Changes in conditions, routes, and equipment make “routine” a risky assumption—plan the job.",
                                isCorrect: false,
                                nextStepId: nil
                            )
                        ]
                    )
                ]
            ),
            quiz: QuizBank.jhaFundamentals
        ),
        TrainingModule(
            id: "safety-briefing",
            title: "Safety Briefing",
            subtitle: "Prepare effective pre-task briefs",
            estimatedMinutes: 10,
            difficulty: "Core",
            tags: ["Briefing", "Communication"],
            objectives: [
                "Cover hazards, controls, and responsibilities",
                "Confirm understanding and questions",
                "Document the briefing"
            ],
            lessonPages: [
                LessonPage(
                    id: "sb-1",
                    title: "Briefing Elements",
                    bullets: [
                        "Discuss task steps, hazards, and controls.",
                        "Assign roles and confirm communications.",
                        "Reassess if conditions change."
                    ]
                )
            ],
            scenario: Scenario(
                title: "Pre-Task Brief",
                intro: "You are leading a short pre-task brief.",
                startStepId: "sb-step-1",
                steps: [
                    ScenarioStep(
                        id: "sb-step-1",
                        prompt: "What should be included?",
                        options: [
                            ScenarioOption(
                                id: "sb-step-1-a",
                                text: "Hazards, controls, and roles.",
                                feedback: "Correct. Cover risks and responsibilities.",
                                isCorrect: true,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "sb-step-1-b",
                                text: "Only the schedule.",
                                feedback: "Incorrect. Safety elements are required.",
                                isCorrect: false,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "sb-step-1-c",
                                text: "Only the hazards—controls can be figured out during the job.",
                                feedback: "Incorrect. Controls and responsibilities should be briefed before work starts so the team executes safely.",
                                isCorrect: false,
                                nextStepId: nil
                            ),
                            ScenarioOption(
                                id: "sb-step-1-d",
                                text: "Read last week’s brief verbatim even if today’s job is different.",
                                feedback: "Not ideal. Briefs should match today’s tasks, hazards, and conditions to stay actionable.",
                                isCorrect: false,
                                nextStepId: nil
                            )
                        ]
                    )
                ]
            ),
            quiz: QuizBank.safetyBriefing
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
        )
    ]

    static let allQuizQuestions: [QuizQuestion] = modules.flatMap { $0.quiz }

    static func modules(for role: TrainingRole?) -> [TrainingModule] {
        guard let role else { return modules }
        return modules.map { $0.tailored(for: role) }
    }

    static func allQuizQuestions(for role: TrainingRole?) -> [QuizQuestion] {
        modules(for: role).flatMap { $0.quiz }
    }

    static let references: [ReferenceSource] = [
        ReferenceSource(
            id: "osha-1910-95",
            title: "OSHA 29 CFR 1910.95 - Occupational noise exposure",
            date: "Accessed Feb 2, 2026",
            notes: "Hearing conservation program elements and exposure requirements."
        ),
        ReferenceSource(
            id: "osha-1910-147",
            title: "OSHA 29 CFR 1910.147 - The control of hazardous energy (lockout/tagout)",
            date: "Accessed Feb 2, 2026",
            notes: "Sequence of lockout/tagout and program requirements."
        ),
        ReferenceSource(
            id: "osha-1910-146",
            title: "OSHA 29 CFR 1910.146 - Permit-required confined spaces",
            date: "Accessed Feb 2, 2026",
            notes: "Confined space entry requirements and roles."
        ),
        ReferenceSource(
            id: "osha-1910-252",
            title: "OSHA 29 CFR 1910 Subpart Q - Welding, Cutting, and Brazing",
            date: "Accessed Feb 2, 2026",
            notes: "Hot work controls, fire prevention, and related requirements."
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
