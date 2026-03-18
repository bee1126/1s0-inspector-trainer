import Foundation

// swiftlint:disable file_length type_body_length

enum QuizBank {
    // NOTE: These quizzes are intentionally geared toward 5/7-level pros.
    // They focus on decision-making, sequencing, and edge cases versus simple recall.

    // MARK: - Lockout / Tagout (LOTO)

    static let loto: [QuizQuestion] = [
        QuizQuestion(
            id: "loto-q1",
            prompt: "A machine has three energy sources: electrical, pneumatic, and hydraulic. What must happen before servicing begins?",
            difficulty: .medium,
            imageName: "hazard_scene_03_electrical",
            choices: [
                QuizChoice(id: "loto-q1-a", text: "All three energy sources must be individually isolated, locked, and verified at zero energy", isCorrect: true),
                QuizChoice(id: "loto-q1-b", text: "Only the primary electrical source needs lockout; the others will bleed down naturally", isCorrect: false),
                QuizChoice(id: "loto-q1-c", text: "A single lock on the main breaker covers all downstream energy sources", isCorrect: false),
                QuizChoice(id: "loto-q1-d", text: "Verbal confirmation from the operator that the machine is off is sufficient", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "loto-q2",
            prompt: "During a shift change, the outgoing worker needs to remove their lock but the incoming worker has not yet arrived. What is correct?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "loto-q2-a", text: "Leave the lock in place until the incoming worker applies their own lock first", isCorrect: true),
                QuizChoice(id: "loto-q2-b", text: "Remove the lock and leave a note for the next worker to reapply", isCorrect: false),
                QuizChoice(id: "loto-q2-c", text: "Transfer the key to the supervisor so they can manage the transition", isCorrect: false),
                QuizChoice(id: "loto-q2-d", text: "Remove the lock since the shift change itself constitutes a new energy control sequence", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "loto-q3",
            prompt: "An authorized employee discovers that a lock belongs to a worker who is on extended leave. What is the proper procedure?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "loto-q3-a", text: "Contact the absent employee if possible; if not, follow the employer's lock removal authorization procedure", isCorrect: true),
                QuizChoice(id: "loto-q3-b", text: "Cut the lock immediately since the worker is not present", isCorrect: false),
                QuizChoice(id: "loto-q3-c", text: "Leave the lock indefinitely until the employee returns", isCorrect: false),
                QuizChoice(id: "loto-q3-d", text: "Have any available worker remove it with bolt cutters", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "loto-q4",
            prompt: "What is the purpose of the 'try-out' step after applying LOTO devices?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "loto-q4-a", text: "To verify that the energy isolation is effective by attempting to restart the equipment", isCorrect: true),
                QuizChoice(id: "loto-q4-b", text: "To test whether the locks are strong enough to withstand force", isCorrect: false),
                QuizChoice(id: "loto-q4-c", text: "To document the serial numbers of all locks applied", isCorrect: false),
                QuizChoice(id: "loto-q4-d", text: "To confirm that PPE is being worn by all workers in the area", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "loto-q5",
            prompt: "A contractor is performing work alongside facility employees on the same equipment. How should LOTO be coordinated?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "loto-q5-a", text: "Both the facility and contractor must apply their own locks under a coordinated group lockout procedure", isCorrect: true),
                QuizChoice(id: "loto-q5-b", text: "The facility's locks are sufficient since contractors work under the host employer's program", isCorrect: false),
                QuizChoice(id: "loto-q5-c", text: "The contractor applies locks and the facility relies on their program exclusively", isCorrect: false),
                QuizChoice(id: "loto-q5-d", text: "Only one set of locks is needed as long as someone is designated to manage them", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "loto-q6",
            prompt: "Under OSHA 1910.147, when can tagout be used instead of lockout?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "loto-q6-a", text: "Only when the energy-isolating device is not capable of being locked out and equivalent safety is demonstrated", isCorrect: true),
                QuizChoice(id: "loto-q6-b", text: "Whenever locks are not available in the immediate work area", isCorrect: false),
                QuizChoice(id: "loto-q6-c", text: "When the job is expected to last less than 30 minutes", isCorrect: false),
                QuizChoice(id: "loto-q6-d", text: "When the supervisor authorizes tagout as an alternative", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "loto-q7",
            prompt: "Stored energy remains in a hydraulic system after the pump is isolated. What must be done?",
            difficulty: .medium,
            imageName: "hazard_scene_06_loto",
            choices: [
                QuizChoice(id: "loto-q7-a", text: "Relieve, disconnect, or restrain the stored energy before work begins", isCorrect: true),
                QuizChoice(id: "loto-q7-b", text: "Proceed with caution since the pump isolation prevents new pressure", isCorrect: false),
                QuizChoice(id: "loto-q7-c", text: "Wait 15 minutes for the pressure to dissipate on its own", isCorrect: false),
                QuizChoice(id: "loto-q7-d", text: "Apply an additional lock to the hydraulic line fitting", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "loto-q8",
            prompt: "What distinguishes an 'affected employee' from an 'authorized employee' under LOTO?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "loto-q8-a", text: "An authorized employee applies locks and performs servicing; an affected employee works in the area but does not service the equipment", isCorrect: true),
                QuizChoice(id: "loto-q8-b", text: "An affected employee holds the keys; an authorized employee performs the work", isCorrect: false),
                QuizChoice(id: "loto-q8-c", text: "They are interchangeable terms for anyone in the lockout zone", isCorrect: false),
                QuizChoice(id: "loto-q8-d", text: "An affected employee is only a supervisor; an authorized employee is a craft worker", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "loto-q9",
            prompt: "An annual periodic inspection of the LOTO program is required. What must the inspection include?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "loto-q9-a", text: "A review between the inspector and authorized employees to verify they understand their responsibilities under the energy control procedure", isCorrect: true),
                QuizChoice(id: "loto-q9-b", text: "Counting the number of locks and tags in inventory", isCorrect: false),
                QuizChoice(id: "loto-q9-c", text: "Checking that all machines have been serviced within the last year", isCorrect: false),
                QuizChoice(id: "loto-q9-d", text: "Confirming that no incidents occurred during the review period", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "loto-q10",
            prompt: "During group lockout, what is the role of the primary authorized employee?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "loto-q10-a", text: "Coordinate the lockout, ensure all members are accounted for, and be the last to remove their lock", isCorrect: true),
                QuizChoice(id: "loto-q10-b", text: "Apply a single lock on behalf of the entire group", isCorrect: false),
                QuizChoice(id: "loto-q10-c", text: "Delegate lockout duties to the most experienced worker", isCorrect: false),
                QuizChoice(id: "loto-q10-d", text: "Verify only that tags are attached; individual locks are optional in group lockout", isCorrect: false)
            ]
        )
    ]

    // MARK: - Fall Protection

    static let fallProtection: [QuizQuestion] = [
        QuizQuestion(
            id: "fall-q1",
            prompt: "At what height does OSHA general industry (1910.28) require fall protection for workers on walking-working surfaces?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "fall-q1-a", text: "4 feet above a lower level", isCorrect: true),
                QuizChoice(id: "fall-q1-b", text: "6 feet above a lower level", isCorrect: false),
                QuizChoice(id: "fall-q1-c", text: "10 feet above a lower level", isCorrect: false),
                QuizChoice(id: "fall-q1-d", text: "Any height where a hazard exists", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "fall-q2",
            prompt: "A worker's personal fall arrest system must limit free fall to what maximum distance?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "fall-q2-a", text: "6 feet", isCorrect: true),
                QuizChoice(id: "fall-q2-b", text: "4 feet", isCorrect: false),
                QuizChoice(id: "fall-q2-c", text: "10 feet", isCorrect: false),
                QuizChoice(id: "fall-q2-d", text: "12 feet", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "fall-q3",
            prompt: "After a fall arrest event, what must happen to the harness and lanyard?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "fall-q3-a", text: "They must be removed from service and not used again until inspected by a competent person", isCorrect: true),
                QuizChoice(id: "fall-q3-b", text: "They can continue to be used if there is no visible damage", isCorrect: false),
                QuizChoice(id: "fall-q3-c", text: "Only the lanyard needs replacement; the harness can be reused", isCorrect: false),
                QuizChoice(id: "fall-q3-d", text: "They should be washed and returned to service within 24 hours", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "fall-q4",
            prompt: "What is the minimum requirement for a guardrail system's top rail height on a walking-working surface?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "fall-q4-a", text: "42 inches plus or minus 3 inches above the walking surface", isCorrect: true),
                QuizChoice(id: "fall-q4-b", text: "36 inches above the walking surface", isCorrect: false),
                QuizChoice(id: "fall-q4-c", text: "48 inches minimum with no tolerance", isCorrect: false),
                QuizChoice(id: "fall-q4-d", text: "39 inches as long as a mid-rail is present", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "fall-q5",
            prompt: "A worker needs to access a roof with an unprotected edge 20 feet above grade. No permanent guardrails exist. What is the best course of action?",
            difficulty: .medium,
            imageName: "hazard_scene_02_rooftop",
            choices: [
                QuizChoice(id: "fall-q5-a", text: "Install temporary guardrails, a warning line system, or use a personal fall arrest system before accessing the edge", isCorrect: true),
                QuizChoice(id: "fall-q5-b", text: "Stay 10 feet from the edge and no fall protection is needed", isCorrect: false),
                QuizChoice(id: "fall-q5-c", text: "Use a safety monitor alone as the sole means of protection", isCorrect: false),
                QuizChoice(id: "fall-q5-d", text: "Proceed carefully and maintain three points of contact", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "fall-q6",
            prompt: "When calculating total fall distance for a personal fall arrest system, which factors must be included?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "fall-q6-a", text: "Free fall distance, deceleration distance, harness stretch, and safety factor clearance", isCorrect: true),
                QuizChoice(id: "fall-q6-b", text: "Only the lanyard length and the worker's height", isCorrect: false),
                QuizChoice(id: "fall-q6-c", text: "The distance from the anchor to the ground minus 6 feet", isCorrect: false),
                QuizChoice(id: "fall-q6-d", text: "Free fall distance only, since the shock absorber handles the rest", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "fall-q7",
            prompt: "What qualifies a person as 'competent' to inspect fall protection equipment?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "fall-q7-a", text: "They can identify hazards, have authority to take corrective action, and are trained to inspect the specific equipment", isCorrect: true),
                QuizChoice(id: "fall-q7-b", text: "They have used fall protection equipment for at least one year", isCorrect: false),
                QuizChoice(id: "fall-q7-c", text: "They hold a current OSHA-30 card", isCorrect: false),
                QuizChoice(id: "fall-q7-d", text: "They are the supervisor of the crew performing elevated work", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "fall-q8",
            prompt: "A self-retracting lifeline (SRL) is rated for a 310-pound capacity. A worker weighs 280 pounds and carries 40 pounds of tools. Can they use this SRL?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "fall-q8-a", text: "No — the combined weight of 320 pounds exceeds the SRL's rated capacity", isCorrect: true),
                QuizChoice(id: "fall-q8-b", text: "Yes — tool weight does not count toward the capacity rating", isCorrect: false),
                QuizChoice(id: "fall-q8-c", text: "Yes — there is a built-in 15% safety margin above the rated capacity", isCorrect: false),
                QuizChoice(id: "fall-q8-d", text: "Yes — as long as the tools are attached to a separate lanyard", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "fall-q9",
            prompt: "An anchor point for a personal fall arrest system must be capable of supporting at least how much force per worker attached?",
            difficulty: .medium,
            imageName: "hazard_scene_07_scaffold",
            choices: [
                QuizChoice(id: "fall-q9-a", text: "5,000 pounds per worker", isCorrect: true),
                QuizChoice(id: "fall-q9-b", text: "3,000 pounds per worker", isCorrect: false),
                QuizChoice(id: "fall-q9-c", text: "Twice the worker's body weight", isCorrect: false),
                QuizChoice(id: "fall-q9-d", text: "1,800 pounds per worker", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "fall-q10",
            prompt: "A hole in a walking surface measures 3 inches in diameter. What protection is required?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "fall-q10-a", text: "A cover that can support at least twice the maximum expected load and is secured against displacement", isCorrect: true),
                QuizChoice(id: "fall-q10-b", text: "No protection needed — holes under 4 inches do not require covers", isCorrect: false),
                QuizChoice(id: "fall-q10-c", text: "Caution tape around the hole is sufficient", isCorrect: false),
                QuizChoice(id: "fall-q10-d", text: "Only a verbal warning to workers in the area", isCorrect: false)
            ]
        )
    ]

    // MARK: - Risk Management (ORM)

    static let riskManagement: [QuizQuestion] = [
        QuizQuestion(
            id: "rm-q1",
            prompt: "In the ORM process, what is the correct sequence of the five steps?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "rm-q1-a", text: "Identify hazards, assess hazards, make risk decisions, implement controls, supervise and review", isCorrect: true),
                QuizChoice(id: "rm-q1-b", text: "Assess hazards, identify controls, implement decisions, review results, supervise workers", isCorrect: false),
                QuizChoice(id: "rm-q1-c", text: "Implement controls, identify hazards, assess risk, make decisions, document results", isCorrect: false),
                QuizChoice(id: "rm-q1-d", text: "Supervise work, identify hazards, implement controls, assess risk, review decisions", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "rm-q2",
            prompt: "A risk assessment results in a 'High' residual risk. Who has the authority to accept this level of risk?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "rm-q2-a", text: "The first flag officer or general officer in the chain of command, per OPNAVINST 3500.39", isCorrect: true),
                QuizChoice(id: "rm-q2-b", text: "The on-scene supervisor, as long as they document the decision", isCorrect: false),
                QuizChoice(id: "rm-q2-c", text: "Any E-7 or above with safety training", isCorrect: false),
                QuizChoice(id: "rm-q2-d", text: "The safety officer alone can accept any level of residual risk", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "rm-q3",
            prompt: "What is the difference between 'deliberate' and 'time-critical' risk management?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "rm-q3-a", text: "Deliberate uses a thorough analysis with full documentation; time-critical is a rapid mental assessment when time is limited", isCorrect: true),
                QuizChoice(id: "rm-q3-b", text: "Deliberate is for combat operations; time-critical is for garrison activities", isCorrect: false),
                QuizChoice(id: "rm-q3-c", text: "They are the same process but deliberate involves more people", isCorrect: false),
                QuizChoice(id: "rm-q3-d", text: "Time-critical allows skipping the hazard identification step", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "rm-q4",
            prompt: "When assessing risk, what two factors are combined to determine the risk level?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "rm-q4-a", text: "Severity of the potential consequence and probability of occurrence", isCorrect: true),
                QuizChoice(id: "rm-q4-b", text: "Number of workers exposed and duration of the task", isCorrect: false),
                QuizChoice(id: "rm-q4-c", text: "Cost of controls and schedule impact", isCorrect: false),
                QuizChoice(id: "rm-q4-d", text: "Type of hazard and location of the work", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "rm-q5",
            prompt: "Controls should be selected in a specific order of preference. What is the correct hierarchy?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "rm-q5-a", text: "Elimination, substitution, engineering controls, administrative controls, PPE", isCorrect: true),
                QuizChoice(id: "rm-q5-b", text: "PPE, administrative controls, engineering controls, substitution, elimination", isCorrect: false),
                QuizChoice(id: "rm-q5-c", text: "Engineering controls, PPE, elimination, administrative controls, substitution", isCorrect: false),
                QuizChoice(id: "rm-q5-d", text: "Administrative controls, engineering controls, PPE, elimination, substitution", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "rm-q6",
            prompt: "A team completes risk assessment and implements controls, but conditions change mid-task. What should happen?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "rm-q6-a", text: "Stop work, reassess hazards with the new conditions, and adjust controls before resuming", isCorrect: true),
                QuizChoice(id: "rm-q6-b", text: "Continue under the original assessment since it was already approved", isCorrect: false),
                QuizChoice(id: "rm-q6-c", text: "Add PPE as a precaution and continue the task", isCorrect: false),
                QuizChoice(id: "rm-q6-d", text: "Note the change in the post-task debrief for future reference", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "rm-q7",
            prompt: "What does 'residual risk' mean in the ORM process?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "rm-q7-a", text: "The level of risk remaining after all controls have been applied", isCorrect: true),
                QuizChoice(id: "rm-q7-b", text: "The risk level before any controls are considered", isCorrect: false),
                QuizChoice(id: "rm-q7-c", text: "Risk that only exists after an incident occurs", isCorrect: false),
                QuizChoice(id: "rm-q7-d", text: "The difference between the initial and final risk scores", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "rm-q8",
            prompt: "During 'supervise and review,' what is the inspector's primary focus?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "rm-q8-a", text: "Verifying that controls are in place, effective, and being followed as planned", isCorrect: true),
                QuizChoice(id: "rm-q8-b", text: "Documenting the number of hazards found for the quarterly report", isCorrect: false),
                QuizChoice(id: "rm-q8-c", text: "Ensuring all workers have signed the risk assessment form", isCorrect: false),
                QuizChoice(id: "rm-q8-d", text: "Confirming that no injuries have occurred during the task", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "rm-q9",
            prompt: "A supervisor decides to accept moderate risk for a routine maintenance task. Is this appropriate?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "rm-q9-a", text: "Only if the risk acceptance authority level matches the residual risk level per command policy", isCorrect: true),
                QuizChoice(id: "rm-q9-b", text: "Yes — supervisors can always accept moderate risk for routine tasks", isCorrect: false),
                QuizChoice(id: "rm-q9-c", text: "No — all risk must be reduced to low before any work begins", isCorrect: false),
                QuizChoice(id: "rm-q9-d", text: "Yes — as long as PPE is provided to all workers", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "rm-q10",
            prompt: "Why should risk management be integrated into the planning phase rather than applied just before execution?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "rm-q10-a", text: "Early integration allows more effective controls like elimination and engineering to be built into the plan", isCorrect: true),
                QuizChoice(id: "rm-q10-b", text: "It is only a documentation requirement and does not affect outcomes", isCorrect: false),
                QuizChoice(id: "rm-q10-c", text: "Last-minute risk management is equally effective but harder to document", isCorrect: false),
                QuizChoice(id: "rm-q10-d", text: "Planning-phase risk management is optional for routine operations", isCorrect: false)
            ]
        )
    ]

    // MARK: - Roles & Responsibilities

    static let rolesResponsibilities: [QuizQuestion] = [
        QuizQuestion(
            id: "roles-q1",
            prompt: "Under NAVOSH, who is ultimately responsible for the safety and health program at a command?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "roles-q1-a", text: "The commanding officer", isCorrect: true),
                QuizChoice(id: "roles-q1-b", text: "The safety officer", isCorrect: false),
                QuizChoice(id: "roles-q1-c", text: "The senior enlisted advisor", isCorrect: false),
                QuizChoice(id: "roles-q1-d", text: "The industrial hygienist", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "roles-q2",
            prompt: "What is the primary role of the collateral duty safety officer (CDSO)?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "roles-q2-a", text: "Advise the commanding officer on safety matters and assist in implementing the safety program", isCorrect: true),
                QuizChoice(id: "roles-q2-b", text: "Replace the need for a full-time safety professional at the command", isCorrect: false),
                QuizChoice(id: "roles-q2-c", text: "Conduct all safety inspections without assistance", isCorrect: false),
                QuizChoice(id: "roles-q2-d", text: "Approve risk acceptance decisions on behalf of the CO", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "roles-q3",
            prompt: "A worker identifies an imminent danger situation. What is their responsibility?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "roles-q3-a", text: "Stop work immediately, warn others in the area, and report the hazard to their supervisor", isCorrect: true),
                QuizChoice(id: "roles-q3-b", text: "Document the hazard and submit a report at the end of the shift", isCorrect: false),
                QuizChoice(id: "roles-q3-c", text: "Continue work while notifying the safety officer by email", isCorrect: false),
                QuizChoice(id: "roles-q3-d", text: "Wait for the supervisor to assess the situation before taking action", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "roles-q4",
            prompt: "Who is responsible for ensuring that safety training records are maintained for all personnel?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "roles-q4-a", text: "The department supervisor, with oversight from the safety office", isCorrect: true),
                QuizChoice(id: "roles-q4-b", text: "Individual workers are solely responsible for their own records", isCorrect: false),
                QuizChoice(id: "roles-q4-c", text: "The commanding officer personally maintains all records", isCorrect: false),
                QuizChoice(id: "roles-q4-d", text: "Training records are only required for civilian employees", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "roles-q5",
            prompt: "During a safety inspection, who has the authority to issue a stop-work order for an unsafe condition?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "roles-q5-a", text: "Any person who identifies an imminent danger has the right and responsibility to stop work", isCorrect: true),
                QuizChoice(id: "roles-q5-b", text: "Only the safety officer can issue a formal stop-work order", isCorrect: false),
                QuizChoice(id: "roles-q5-c", text: "Only E-7 and above can stop work on a military installation", isCorrect: false),
                QuizChoice(id: "roles-q5-d", text: "Stop-work authority rests solely with the commanding officer", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "roles-q6",
            prompt: "What is the role of the safety committee (or Safety Council) at a command?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "roles-q6-a", text: "Review mishap trends, recommend corrective actions, and advise the CO on safety program effectiveness", isCorrect: true),
                QuizChoice(id: "roles-q6-b", text: "Conduct all workplace inspections on behalf of department supervisors", isCorrect: false),
                QuizChoice(id: "roles-q6-c", text: "Approve all hazardous work permits before operations begin", isCorrect: false),
                QuizChoice(id: "roles-q6-d", text: "Discipline workers who violate safety procedures", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "roles-q7",
            prompt: "A supervisor delegates safety inspection duties to a junior worker. Is this acceptable?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "roles-q7-a", text: "The supervisor may delegate tasks but retains accountability for ensuring inspections are done correctly", isCorrect: true),
                QuizChoice(id: "roles-q7-b", text: "No — only supervisors may conduct safety inspections", isCorrect: false),
                QuizChoice(id: "roles-q7-c", text: "Yes — once delegated, the supervisor is no longer responsible for the outcome", isCorrect: false),
                QuizChoice(id: "roles-q7-d", text: "Only if the junior worker has completed OSHA-30 training", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "roles-q8",
            prompt: "What is the inspector's role in the hazard abatement tracking process?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "roles-q8-a", text: "Verify that identified hazards are corrected within established timelines and interim controls are in place", isCorrect: true),
                QuizChoice(id: "roles-q8-b", text: "Personally fix all hazards found during inspections", isCorrect: false),
                QuizChoice(id: "roles-q8-c", text: "Only record hazards; corrective action is the exclusive responsibility of the department head", isCorrect: false),
                QuizChoice(id: "roles-q8-d", text: "Close out hazards after 30 days regardless of corrective action status", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "roles-q9",
            prompt: "Per OPNAVINST 5100.23, how often must the commanding officer review the safety program?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "roles-q9-a", text: "At least annually, with continuous oversight through the safety committee and safety officer", isCorrect: true),
                QuizChoice(id: "roles-q9-b", text: "Only after a Class A mishap occurs", isCorrect: false),
                QuizChoice(id: "roles-q9-c", text: "Every five years during the command's certification cycle", isCorrect: false),
                QuizChoice(id: "roles-q9-d", text: "Monthly via personal inspection of all workspaces", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "roles-q10",
            prompt: "A new employee reports to the shop. Before they begin work, what is the supervisor's safety responsibility?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "roles-q10-a", text: "Provide workplace-specific safety orientation including hazards, controls, emergency procedures, and required PPE", isCorrect: true),
                QuizChoice(id: "roles-q10-b", text: "Have them sign a general safety acknowledgment form and begin work immediately", isCorrect: false),
                QuizChoice(id: "roles-q10-c", text: "Schedule safety training within 90 days of arrival", isCorrect: false),
                QuizChoice(id: "roles-q10-d", text: "Assign them to observe another worker for one full shift with no further training required", isCorrect: false)
            ]
        )
    ]

    // MARK: - Confined Space

    static let confinedSpace: [QuizQuestion] = [
        QuizQuestion(
            id: "cs-q1",
            prompt: "What three criteria define a permit-required confined space?",
            difficulty: .hard,
            imageName: "hazard_scene_04_confined",
            choices: [
                QuizChoice(id: "cs-q1-a", text: "Large enough to enter, has limited means of entry/exit, and is not designed for continuous occupancy", isCorrect: true),
                QuizChoice(id: "cs-q1-b", text: "Contains hazardous atmosphere, has limited ventilation, and is below ground level", isCorrect: false),
                QuizChoice(id: "cs-q1-c", text: "Requires a ladder to enter, has poor lighting, and is not climate-controlled", isCorrect: false),
                QuizChoice(id: "cs-q1-d", text: "Is enclosed on all sides, contains machinery, and requires PPE to enter", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "cs-q2",
            prompt: "Atmospheric testing of a confined space must be performed in what order?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "cs-q2-a", text: "Oxygen first, then combustible gases, then toxic gases", isCorrect: true),
                QuizChoice(id: "cs-q2-b", text: "Toxic gases first, then oxygen, then combustibles", isCorrect: false),
                QuizChoice(id: "cs-q2-c", text: "Combustibles first, then toxics, then oxygen", isCorrect: false),
                QuizChoice(id: "cs-q2-d", text: "The order does not matter as long as all three are tested", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "cs-q3",
            prompt: "The acceptable oxygen range for confined space entry is:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "cs-q3-a", text: "19.5% to 23.5%", isCorrect: true),
                QuizChoice(id: "cs-q3-b", text: "16.0% to 25.0%", isCorrect: false),
                QuizChoice(id: "cs-q3-c", text: "20.0% to 22.0%", isCorrect: false),
                QuizChoice(id: "cs-q3-d", text: "18.0% to 24.0%", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "cs-q4",
            prompt: "What is the attendant's most critical responsibility during a confined space entry?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "cs-q4-a", text: "Maintain continuous communication with entrants, monitor conditions, and summon rescue if needed — never enter the space", isCorrect: true),
                QuizChoice(id: "cs-q4-b", text: "Operate the ventilation equipment and monitor air quality instruments inside the space", isCorrect: false),
                QuizChoice(id: "cs-q4-c", text: "Enter the space immediately if an entrant calls for help", isCorrect: false),
                QuizChoice(id: "cs-q4-d", text: "Complete the entry permit paperwork while entrants work", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "cs-q5",
            prompt: "An entry permit has been issued but conditions change significantly two hours into the job. What is required?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "cs-q5-a", text: "Evacuate the space, cancel the permit, reassess hazards, and issue a new permit before re-entry", isCorrect: true),
                QuizChoice(id: "cs-q5-b", text: "Annotate the change on the existing permit and continue work", isCorrect: false),
                QuizChoice(id: "cs-q5-c", text: "Increase ventilation and have entrants don additional PPE", isCorrect: false),
                QuizChoice(id: "cs-q5-d", text: "Continue work as long as the original permit has not expired", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "cs-q6",
            prompt: "What is the primary purpose of continuous atmospheric monitoring during confined space work?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "cs-q6-a", text: "To detect real-time changes in oxygen, combustible gases, or toxic levels that could endanger entrants", isCorrect: true),
                QuizChoice(id: "cs-q6-b", text: "To document compliance with OSHA recordkeeping requirements", isCorrect: false),
                QuizChoice(id: "cs-q6-c", text: "To determine whether ventilation equipment is functioning properly", isCorrect: false),
                QuizChoice(id: "cs-q6-d", text: "To measure the temperature and humidity inside the space", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "cs-q7",
            prompt: "Under OSHA 1910.146, who is qualified to authorize a confined space entry permit?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "cs-q7-a", text: "The entry supervisor — a person trained to evaluate hazards and authorize entry with appropriate conditions", isCorrect: true),
                QuizChoice(id: "cs-q7-b", text: "Any worker who has completed confined space awareness training", isCorrect: false),
                QuizChoice(id: "cs-q7-c", text: "Only the facility safety officer", isCorrect: false),
                QuizChoice(id: "cs-q7-d", text: "The attendant, since they are positioned at the entry point", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "cs-q8",
            prompt: "A non-permit confined space is later found to contain a hazardous atmosphere. What must happen?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "cs-q8-a", text: "Reclassify it as a permit-required confined space and implement all permit-required entry procedures", isCorrect: true),
                QuizChoice(id: "cs-q8-b", text: "Increase ventilation to eliminate the atmosphere and continue as non-permit", isCorrect: false),
                QuizChoice(id: "cs-q8-c", text: "Post a warning sign but continue non-permit entry procedures", isCorrect: false),
                QuizChoice(id: "cs-q8-d", text: "Seal the space permanently since it was originally classified incorrectly", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "cs-q9",
            prompt: "Rescue and emergency services for confined space must be:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "cs-q9-a", text: "Evaluated and available before any entry begins, with retrieval equipment in place at the entry point", isCorrect: true),
                QuizChoice(id: "cs-q9-b", text: "Called only after an emergency occurs to avoid unnecessary cost", isCorrect: false),
                QuizChoice(id: "cs-q9-c", text: "On standby at the fire station — a phone call is sufficient", isCorrect: false),
                QuizChoice(id: "cs-q9-d", text: "Arranged within 24 hours of the first entry", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "cs-q10",
            prompt: "How long must completed confined space entry permits be retained?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "cs-q10-a", text: "At least one year to facilitate the annual review of the confined space program", isCorrect: true),
                QuizChoice(id: "cs-q10-b", text: "Permits may be discarded after the entry is completed", isCorrect: false),
                QuizChoice(id: "cs-q10-c", text: "Five years per OSHA recordkeeping requirements", isCorrect: false),
                QuizChoice(id: "cs-q10-d", text: "Indefinitely — they must never be destroyed", isCorrect: false)
            ]
        )
    ]

    // MARK: - Hearing Conservation

    static let hearingConservation: [QuizQuestion] = [
        QuizQuestion(
            id: "hc-q1",
            prompt: "At what 8-hour TWA noise level must an employer implement a hearing conservation program?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "hc-q1-a", text: "85 dBA", isCorrect: true),
                QuizChoice(id: "hc-q1-b", text: "90 dBA", isCorrect: false),
                QuizChoice(id: "hc-q1-c", text: "80 dBA", isCorrect: false),
                QuizChoice(id: "hc-q1-d", text: "100 dBA", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "hc-q2",
            prompt: "A Standard Threshold Shift (STS) is defined as a change of how many decibels averaged across specific frequencies?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "hc-q2-a", text: "10 dB average at 2000, 3000, and 4000 Hz in either ear", isCorrect: true),
                QuizChoice(id: "hc-q2-b", text: "5 dB at any single frequency", isCorrect: false),
                QuizChoice(id: "hc-q2-c", text: "15 dB average across all tested frequencies", isCorrect: false),
                QuizChoice(id: "hc-q2-d", text: "25 dB at 500 Hz only", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "hc-q3",
            prompt: "How often must audiometric testing be performed for workers in a hearing conservation program?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "hc-q3-a", text: "Annually, within 12 months of the previous audiogram", isCorrect: true),
                QuizChoice(id: "hc-q3-b", text: "Every two years unless a threshold shift is detected", isCorrect: false),
                QuizChoice(id: "hc-q3-c", text: "Only at initial hire and upon separation", isCorrect: false),
                QuizChoice(id: "hc-q3-d", text: "Every six months for workers in noise above 100 dBA", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "hc-q4",
            prompt: "What is the purpose of a baseline audiogram?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "hc-q4-a", text: "To establish a reference point for comparing future audiometric tests and detecting hearing changes", isCorrect: true),
                QuizChoice(id: "hc-q4-b", text: "To determine whether a worker qualifies for hazard duty pay", isCorrect: false),
                QuizChoice(id: "hc-q4-c", text: "To measure the noise reduction rating of the worker's hearing protection", isCorrect: false),
                QuizChoice(id: "hc-q4-d", text: "To verify the calibration of the audiometric equipment", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "hc-q5",
            prompt: "An employee's NRR-rated earplugs have an NRR of 29. Using the OSHA derating method, what is the estimated real-world noise reduction?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "hc-q5-a", text: "Approximately 14 dB — subtract 7, then divide by 2: (29-7)/2 = 11, used as practical estimate", isCorrect: true),
                QuizChoice(id: "hc-q5-b", text: "The full 29 dB as stated on the label", isCorrect: false),
                QuizChoice(id: "hc-q5-c", text: "Approximately 22 dB — subtract 7 from the NRR", isCorrect: false),
                QuizChoice(id: "hc-q5-d", text: "The NRR only applies in laboratory conditions and cannot be estimated for field use", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "hc-q6",
            prompt: "When must an employer notify a worker that a standard threshold shift has occurred?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "hc-q6-a", text: "Within 21 days of the determination", isCorrect: true),
                QuizChoice(id: "hc-q6-b", text: "At the next annual audiometric test", isCorrect: false),
                QuizChoice(id: "hc-q6-c", text: "Within 5 business days of the audiogram", isCorrect: false),
                QuizChoice(id: "hc-q6-d", text: "Only if the worker requests their results in writing", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "hc-q7",
            prompt: "What areas must be posted when noise levels exceed the action level?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "hc-q7-a", text: "Areas must be identified as high-noise zones with signage indicating hearing protection is required", isCorrect: true),
                QuizChoice(id: "hc-q7-b", text: "Posting is only required above the PEL, not the action level", isCorrect: false),
                QuizChoice(id: "hc-q7-c", text: "No posting is required if hearing protection is available at the entrance", isCorrect: false),
                QuizChoice(id: "hc-q7-d", text: "Only the entrance to the building needs to be posted", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "hc-q8",
            prompt: "What training must be provided annually to workers in a hearing conservation program?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "hc-q8-a", text: "Effects of noise on hearing, purpose of hearing protectors and audiometric testing, and proper use of protectors", isCorrect: true),
                QuizChoice(id: "hc-q8-b", text: "Only how to insert earplugs correctly", isCorrect: false),
                QuizChoice(id: "hc-q8-c", text: "General safety awareness training that covers all hazards including noise", isCorrect: false),
                QuizChoice(id: "hc-q8-d", text: "Training is only required at initial enrollment, not annually", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "hc-q9",
            prompt: "OSHA's Permissible Exposure Limit (PEL) for noise is:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "hc-q9-a", text: "90 dBA as an 8-hour TWA", isCorrect: true),
                QuizChoice(id: "hc-q9-b", text: "85 dBA as an 8-hour TWA", isCorrect: false),
                QuizChoice(id: "hc-q9-c", text: "100 dBA as an 8-hour TWA", isCorrect: false),
                QuizChoice(id: "hc-q9-d", text: "80 dBA as an 8-hour TWA", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "hc-q10",
            prompt: "For every 5 dB increase above 90 dBA, the permissible exposure time is:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "hc-q10-a", text: "Cut in half — 95 dBA allows 4 hours, 100 dBA allows 2 hours", isCorrect: true),
                QuizChoice(id: "hc-q10-b", text: "Reduced by one hour per 5 dB increase", isCorrect: false),
                QuizChoice(id: "hc-q10-c", text: "Unchanged as long as hearing protection is worn", isCorrect: false),
                QuizChoice(id: "hc-q10-d", text: "Reduced by 25% per 5 dB increase", isCorrect: false)
            ]
        )
    ]

    // MARK: - Mishap Reporting

    static let mishapReporting: [QuizQuestion] = [
        QuizQuestion(
            id: "mishap-q1",
            prompt: "A Class A mishap is defined by which threshold?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "mishap-q1-a", text: "A fatality, permanent total disability, or property damage of $2.5 million or more", isCorrect: true),
                QuizChoice(id: "mishap-q1-b", text: "Any injury requiring hospitalization regardless of cost", isCorrect: false),
                QuizChoice(id: "mishap-q1-c", text: "Property damage exceeding $500,000", isCorrect: false),
                QuizChoice(id: "mishap-q1-d", text: "Any lost workday case or restricted duty assignment", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "mishap-q2",
            prompt: "Within what timeframe must a Class A mishap be reported to the chain of command?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "mishap-q2-a", text: "Immediately by the fastest means available", isCorrect: true),
                QuizChoice(id: "mishap-q2-b", text: "Within 24 hours via the mishap reporting system", isCorrect: false),
                QuizChoice(id: "mishap-q2-c", text: "Within 72 hours with a preliminary report", isCorrect: false),
                QuizChoice(id: "mishap-q2-d", text: "By close of business on the day of the mishap", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "mishap-q3",
            prompt: "Why is near-miss reporting critical to a safety program?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "mishap-q3-a", text: "Near-misses reveal hazards and system failures before they cause injury, enabling proactive corrective action", isCorrect: true),
                QuizChoice(id: "mishap-q3-b", text: "OSHA requires a specific number of near-miss reports per quarter", isCorrect: false),
                QuizChoice(id: "mishap-q3-c", text: "Near-miss reports are used to evaluate individual worker performance", isCorrect: false),
                QuizChoice(id: "mishap-q3-d", text: "They are only useful for insurance claims documentation", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "mishap-q4",
            prompt: "What is the primary purpose of preserving the mishap scene?",
            difficulty: .hard,
            imageName: "hazard_scene_08_flightline",
            choices: [
                QuizChoice(id: "mishap-q4-a", text: "To maintain physical evidence so investigators can accurately determine root causes", isCorrect: true),
                QuizChoice(id: "mishap-q4-b", text: "To prevent workers from returning to work until the area is cleaned", isCorrect: false),
                QuizChoice(id: "mishap-q4-c", text: "To take photographs for the command newsletter", isCorrect: false),
                QuizChoice(id: "mishap-q4-d", text: "To satisfy law enforcement requirements in all cases", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "mishap-q5",
            prompt: "An employee is injured but insists they do not want to report it. What is the supervisor's obligation?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "mishap-q5-a", text: "Report the injury regardless — employers are required to record and report work-related injuries", isCorrect: true),
                QuizChoice(id: "mishap-q5-b", text: "Respect the employee's wishes and do not file a report", isCorrect: false),
                QuizChoice(id: "mishap-q5-c", text: "Report it only if the employee seeks medical treatment", isCorrect: false),
                QuizChoice(id: "mishap-q5-d", text: "Wait 24 hours to see if the injury resolves before reporting", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "mishap-q6",
            prompt: "What information must be included in an initial mishap report?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "mishap-q6-a", text: "Who was involved, what happened, when and where it occurred, immediate actions taken, and severity assessment", isCorrect: true),
                QuizChoice(id: "mishap-q6-b", text: "Only the injured person's name and the date of the incident", isCorrect: false),
                QuizChoice(id: "mishap-q6-c", text: "A complete root cause analysis and corrective action plan", isCorrect: false),
                QuizChoice(id: "mishap-q6-d", text: "The cost estimate of property damage and medical expenses", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "mishap-q7",
            prompt: "Under OSHA recordkeeping (29 CFR 1904), which of the following is a recordable injury?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "mishap-q7-a", text: "An injury requiring medical treatment beyond first aid, or resulting in lost workdays, restricted duty, or loss of consciousness", isCorrect: true),
                QuizChoice(id: "mishap-q7-b", text: "Any workplace injury regardless of severity", isCorrect: false),
                QuizChoice(id: "mishap-q7-c", text: "Only injuries that result in hospitalization", isCorrect: false),
                QuizChoice(id: "mishap-q7-d", text: "Injuries treated with first aid measures like bandages or ice packs", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "mishap-q8",
            prompt: "What is the difference between a mishap investigation and a mishap report?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "mishap-q8-a", text: "A report documents what happened; an investigation analyzes why it happened and identifies root causes to prevent recurrence", isCorrect: true),
                QuizChoice(id: "mishap-q8-b", text: "They are the same document with different names", isCorrect: false),
                QuizChoice(id: "mishap-q8-c", text: "A report is for Class A/B mishaps; an investigation is for Class C/D only", isCorrect: false),
                QuizChoice(id: "mishap-q8-d", text: "A report is sent to OSHA; an investigation is an internal document only", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "mishap-q9",
            prompt: "A worker experiences a needlestick injury. Under OSHA, what reporting action is required?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "mishap-q9-a", text: "Record it on the OSHA 300 log as it is a recordable injury involving a sharps exposure", isCorrect: true),
                QuizChoice(id: "mishap-q9-b", text: "No action unless the worker develops an infection", isCorrect: false),
                QuizChoice(id: "mishap-q9-c", text: "Report to OSHA within 8 hours as a hospitalization", isCorrect: false),
                QuizChoice(id: "mishap-q9-d", text: "Document in the employee's medical file only", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "mishap-q10",
            prompt: "How should mishap trends be used by the safety program?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "mishap-q10-a", text: "Analyze trends to identify systemic hazards, inform training needs, and drive targeted corrective actions", isCorrect: true),
                QuizChoice(id: "mishap-q10-b", text: "Use trends only for annual reporting to higher headquarters", isCorrect: false),
                QuizChoice(id: "mishap-q10-c", text: "Compare trends to other commands for competitive ranking", isCorrect: false),
                QuizChoice(id: "mishap-q10-d", text: "Trends are only relevant if mishap rates exceed the national average", isCorrect: false)
            ]
        )
    ]

    // MARK: - PPE Decision

    static let ppeDecision: [QuizQuestion] = [
        QuizQuestion(
            id: "ppe-q1",
            prompt: "PPE should be considered what level in the hierarchy of controls?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "ppe-q1-a", text: "The last line of defense — used when higher-level controls cannot adequately reduce the hazard", isCorrect: true),
                QuizChoice(id: "ppe-q1-b", text: "The first response to any identified hazard", isCorrect: false),
                QuizChoice(id: "ppe-q1-c", text: "Equal to engineering controls in effectiveness", isCorrect: false),
                QuizChoice(id: "ppe-q1-d", text: "A substitute for hazard elimination when elimination is inconvenient", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "ppe-q2",
            prompt: "Before assigning PPE, the employer must first conduct:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "ppe-q2-a", text: "A hazard assessment to determine what PPE is necessary for the specific workplace hazards present", isCorrect: true),
                QuizChoice(id: "ppe-q2-b", text: "A cost-benefit analysis to determine the cheapest acceptable PPE", isCorrect: false),
                QuizChoice(id: "ppe-q2-c", text: "A survey of worker preferences for comfort and style", isCorrect: false),
                QuizChoice(id: "ppe-q2-d", text: "An inventory check to see what PPE is already in stock", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "ppe-q3",
            prompt: "A worker is exposed to both impact and chemical splash hazards. What eye protection is required?",
            difficulty: .hard,
            imageName: "hazard_scene_01_shop",
            choices: [
                QuizChoice(id: "ppe-q3-a", text: "Safety goggles or face shield rated for both impact (ANSI Z87.1) and chemical splash protection", isCorrect: true),
                QuizChoice(id: "ppe-q3-b", text: "Standard safety glasses are sufficient for all eye hazards", isCorrect: false),
                QuizChoice(id: "ppe-q3-c", text: "The worker can choose whichever protection they prefer", isCorrect: false),
                QuizChoice(id: "ppe-q3-d", text: "Chemical splash goggles only — they inherently provide impact protection", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "ppe-q4",
            prompt: "Who is responsible for the cost of required PPE under OSHA?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "ppe-q4-a", text: "The employer must provide required PPE at no cost to the employee", isCorrect: true),
                QuizChoice(id: "ppe-q4-b", text: "The cost is split equally between employer and employee", isCorrect: false),
                QuizChoice(id: "ppe-q4-c", text: "The employee pays for PPE but can deduct it from taxes", isCorrect: false),
                QuizChoice(id: "ppe-q4-d", text: "The employer pays only for PPE costing over $50", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "ppe-q5",
            prompt: "An employee's respirator has a protection factor of 10. The workplace has 5x the PEL of a contaminant. Is this respirator adequate?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "ppe-q5-a", text: "Yes — the assigned protection factor of 10 exceeds the 5x hazard ratio, providing adequate protection", isCorrect: true),
                QuizChoice(id: "ppe-q5-b", text: "No — the protection factor must be at least 20x the exposure level", isCorrect: false),
                QuizChoice(id: "ppe-q5-c", text: "Protection factors are not used to select respirators", isCorrect: false),
                QuizChoice(id: "ppe-q5-d", text: "Only a supplied-air respirator is acceptable above the PEL", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "ppe-q6",
            prompt: "What training must workers receive before using PPE?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "ppe-q6-a", text: "When PPE is necessary, what type is needed, how to properly put on/take off, adjust, wear, and maintain it, and its limitations", isCorrect: true),
                QuizChoice(id: "ppe-q6-b", text: "Only how to put it on and take it off", isCorrect: false),
                QuizChoice(id: "ppe-q6-c", text: "Training is only required for respirators, not other PPE", isCorrect: false),
                QuizChoice(id: "ppe-q6-d", text: "Reading the manufacturer's instructions is sufficient training", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "ppe-q7",
            prompt: "A worker complains that their safety gloves make it difficult to perform fine motor tasks. What should the supervisor do?",
            difficulty: .hard,
            imageName: "hazard_scene_05_warehouse",
            choices: [
                QuizChoice(id: "ppe-q7-a", text: "Evaluate alternative gloves that provide the required protection level while allowing better dexterity", isCorrect: true),
                QuizChoice(id: "ppe-q7-b", text: "Allow the worker to remove gloves for tasks requiring fine motor skills", isCorrect: false),
                QuizChoice(id: "ppe-q7-c", text: "Tell the worker to adapt to the gloves since they meet the safety requirement", isCorrect: false),
                QuizChoice(id: "ppe-q7-d", text: "Exempt the worker from glove requirements based on their complaint", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "ppe-q8",
            prompt: "How often should PPE be inspected?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "ppe-q8-a", text: "Before each use by the wearer, with periodic documented inspections per the manufacturer's recommendations", isCorrect: true),
                QuizChoice(id: "ppe-q8-b", text: "Only during the annual safety inspection", isCorrect: false),
                QuizChoice(id: "ppe-q8-c", text: "Monthly by the safety officer", isCorrect: false),
                QuizChoice(id: "ppe-q8-d", text: "Only when visible damage is noticed", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "ppe-q9",
            prompt: "A worker is required to wear a respirator. Under OSHA, what must happen before they can use it?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "ppe-q9-a", text: "Medical evaluation, fit testing, and training on proper use, maintenance, and limitations", isCorrect: true),
                QuizChoice(id: "ppe-q9-b", text: "Only a fit test to ensure proper seal", isCorrect: false),
                QuizChoice(id: "ppe-q9-c", text: "Supervisor approval and a signed waiver", isCorrect: false),
                QuizChoice(id: "ppe-q9-d", text: "Completing an online respiratory protection course", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "ppe-q10",
            prompt: "Damaged PPE is discovered during a pre-use inspection. What is the correct action?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "ppe-q10-a", text: "Remove it from service immediately and replace it before beginning work", isCorrect: true),
                QuizChoice(id: "ppe-q10-b", text: "Use it for the current shift and replace it at the end of the day", isCorrect: false),
                QuizChoice(id: "ppe-q10-c", text: "Repair it with tape or adhesive and continue using it", isCorrect: false),
                QuizChoice(id: "ppe-q10-d", text: "Tag it for inspection by the manufacturer before deciding", isCorrect: false)
            ]
        )
    ]
}

// swiftlint:enable file_length type_body_length
