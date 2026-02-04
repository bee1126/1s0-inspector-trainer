import Foundation

enum QuizBank {
    // NOTE: These quizzes are intentionally geared toward 5/7-level pros.
    // They focus on decision-making, sequencing, and edge cases versus simple recall.

    // MARK: Lockout / Tagout (LOTO)

    static let loto: [QuizQuestion] = [
        QuizQuestion(
            id: "loto-q1",
            prompt: "During a group LOTO, a technician arrives late after isolation is established. What must they do before starting work?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "loto-q1-a", text: "Work under the lead’s lock as long as the lead is present", isCorrect: false),
                QuizChoice(id: "loto-q1-b", text: "Add their personal lock to the group lockbox/device before work", isCorrect: true),
                QuizChoice(id: "loto-q1-c", text: "Sign the existing tag and proceed", isCorrect: false),
                QuizChoice(id: "loto-q1-d", text: "Wait until the end of the shift to apply a lock", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "loto-q2",
            prompt: "An energy control procedure lists only the electrical disconnect for a hydraulic press. What is the key deficiency?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "loto-q2-a", text: "It doesn’t identify the machine by serial number", isCorrect: false),
                QuizChoice(id: "loto-q2-b", text: "It fails to address stored/accumulated energy (hydraulic pressure)", isCorrect: true),
                QuizChoice(id: "loto-q2-c", text: "Hydraulic systems are exempt if power is removed", isCorrect: false),
                QuizChoice(id: "loto-q2-d", text: "It should be a tagout-only procedure for hydraulics", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "loto-q3",
            prompt: "After applying LOTO, the next verification step should include:",
            difficulty: .easy,
            choices: [
                QuizChoice(id: "loto-q3-a", text: "Try-out using normal controls, then return controls to neutral/off", isCorrect: true),
                QuizChoice(id: "loto-q3-b", text: "Beginning disassembly to confirm the machine won’t move", isCorrect: false),
                QuizChoice(id: "loto-q3-c", text: "Relying on the tag as proof isolation is complete", isCorrect: false),
                QuizChoice(id: "loto-q3-d", text: "Removing guards to visually confirm de-energized components", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "loto-q4",
            prompt: "LOTO devices must be temporarily removed to test positioning. What is the correct control sequence?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "loto-q4-a", text: "Remove locks, energize, test, leave energized if test passes", isCorrect: false),
                QuizChoice(id: "loto-q4-b", text: "Clear tools/personnel, remove devices, energize/test, de-energize, reapply LOTO", isCorrect: true),
                QuizChoice(id: "loto-q4-c", text: "Keep tags in place; tags substitute for locks during testing", isCorrect: false),
                QuizChoice(id: "loto-q4-d", text: "Skip try-out; testing itself is the verification", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "loto-q5",
            prompt: "A contractor and host shop both perform servicing under LOTO. The most important coordination requirement is:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "loto-q5-a", text: "Contractor uses only the host’s locks and tags", isCorrect: false),
                QuizChoice(id: "loto-q5-b", text: "Each employer informs the other of procedures and enforces their own program", isCorrect: true),
                QuizChoice(id: "loto-q5-c", text: "Only the host safety office can approve the contractor’s locks", isCorrect: false),
                QuizChoice(id: "loto-q5-d", text: "Contractors are exempt if escorted", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "loto-q6",
            prompt: "On shift change during a group lockout, the safest transfer method is:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "loto-q6-a", text: "Remove all locks, brief the oncoming shift, then reapply locks", isCorrect: false),
                QuizChoice(id: "loto-q6-b", text: "Oncoming workers apply locks before outgoing workers remove theirs", isCorrect: true),
                QuizChoice(id: "loto-q6-c", text: "Leave the lead lock only; personal locks are optional during transfer", isCorrect: false),
                QuizChoice(id: "loto-q6-d", text: "Use a tag to cover the gap between shifts", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "loto-q7",
            prompt: "A lock is found on an isolating device, but the employee is not available. When can someone else remove it?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "loto-q7-a", text: "Any supervisor may remove it if production is behind", isCorrect: false),
                QuizChoice(id: "loto-q7-b", text: "Only under a formal removal procedure with verification and notification steps", isCorrect: true),
                QuizChoice(id: "loto-q7-c", text: "After replacing the lock with a tag", isCorrect: false),
                QuizChoice(id: "loto-q7-d", text: "Immediately, if the machine is off", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "loto-q8",
            prompt: "Tagout is used because the isolating device cannot be locked. What is required to reach equivalent protection?",
            difficulty: .easy,
            choices: [
                QuizChoice(id: "loto-q8-a", text: "A tag plus additional measures that provide physical restraint or control", isCorrect: true),
                QuizChoice(id: "loto-q8-b", text: "Two tags on the same device", isCorrect: false),
                QuizChoice(id: "loto-q8-c", text: "A tag and a written reminder at the tool crib", isCorrect: false),
                QuizChoice(id: "loto-q8-d", text: "A tag is equivalent if it is signed, dated, and includes a warning", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "loto-q9",
            prompt: "Which situation is MOST likely to invalidate the “minor servicing” exception and require full LOTO?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "loto-q9-a", text: "Routine clearing of a jam that requires reaching into a point of operation", isCorrect: true),
                QuizChoice(id: "loto-q9-b", text: "A repetitive, integral adjustment using an effective alternative method", isCorrect: false),
                QuizChoice(id: "loto-q9-c", text: "A task done during normal operations with no exposure to hazardous energy", isCorrect: false),
                QuizChoice(id: "loto-q9-d", text: "A minor adjustment performed with guarding in place", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "loto-q10",
            prompt: "Which action best reduces “unexpected energization” risk beyond devices and paperwork?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "loto-q10-a", text: "Clear affected-employee notifications before and after lock removal", isCorrect: true),
                QuizChoice(id: "loto-q10-b", text: "Only tagging the main control panel", isCorrect: false),
                QuizChoice(id: "loto-q10-c", text: "Allowing operators to remove locks for troubleshooting", isCorrect: false),
                QuizChoice(id: "loto-q10-d", text: "Restarting equipment to confirm repairs before notifying anyone", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "loto-q11",
            prompt: "You’re verifying absence of voltage on a de-energized 480V circuit. Which meter check sequence best prevents a false “dead” reading?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "loto-q11-a", text: "Test the circuit, then test the meter on a known live source (one check is enough)", isCorrect: false),
                QuizChoice(id: "loto-q11-b", text: "Test the meter on a known live source, test the circuit, then re-test the meter on a known live source", isCorrect: true),
                QuizChoice(id: "loto-q11-c", text: "Rely on the disconnect handle position if it’s locked and tagged", isCorrect: false),
                QuizChoice(id: "loto-q11-d", text: "Use non-contact voltage detection only to avoid exposure", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "loto-q12",
            prompt: "A machine has a large flywheel and pneumatic assist. After isolating electrical power, what should an effective ECP require before servicing begins?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "loto-q12-a", text: "Bleed/secure stored energy (mechanical and pneumatic) and verify zero-energy state", isCorrect: true),
                QuizChoice(id: "loto-q12-b", text: "Post a warning sign and begin work if the controls are off", isCorrect: false),
                QuizChoice(id: "loto-q12-c", text: "Only lock out the primary electrical disconnect; stored energy is secondary", isCorrect: false),
                QuizChoice(id: "loto-q12-d", text: "Skip verification if the machine is not scheduled to run that shift", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "loto-q13",
            prompt: "Periodic inspections of energy control procedures are primarily intended to verify:",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "loto-q13-a", text: "That the procedure is being followed and remains effective for the equipment and task", isCorrect: true),
                QuizChoice(id: "loto-q13-b", text: "That equipment downtime meets production targets", isCorrect: false),
                QuizChoice(id: "loto-q13-c", text: "That tags are the same color across the unit", isCorrect: false),
                QuizChoice(id: "loto-q13-d", text: "That only supervisors sign off on LOTO activities", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "loto-q14",
            prompt: "A supervisor needs a lock removed because the owner is unavailable. Which element is essential to a compliant lock removal procedure?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "loto-q14-a", text: "Verify the employee is not on-site, verify equipment is safe to energize, and ensure the employee is notified before they return to work", isCorrect: true),
                QuizChoice(id: "loto-q14-b", text: "Cut the lock, restart the equipment, and document the action later", isCorrect: false),
                QuizChoice(id: "loto-q14-c", text: "Replace the lock with a tag signed by the supervisor", isCorrect: false),
                QuizChoice(id: "loto-q14-d", text: "Wait 24 hours; after that, any lock can be removed", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "loto-q15",
            prompt: "Cord-and-plug equipment may be controlled without a full written ECP when:",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "loto-q15-a", text: "The plug is unplugged and kept under the exclusive control of the employee performing the service", isCorrect: true),
                QuizChoice(id: "loto-q15-b", text: "A tag is placed on the cord within 10 feet of the plug", isCorrect: false),
                QuizChoice(id: "loto-q15-c", text: "The equipment is less than 120V", isCorrect: false),
                QuizChoice(id: "loto-q15-d", text: "Two employees agree the device will not be plugged back in", isCorrect: false)
            ]
        )
    ]

    // MARK: Fall Protection

    static let fallProtection: [QuizQuestion] = [
        QuizQuestion(
            id: "fall-q1",
            prompt: "A fall restraint system must be rigged to:",
            difficulty: .easy,
            choices: [
                QuizChoice(id: "fall-q1-a", text: "Limit free fall to 6 feet or less", isCorrect: false),
                QuizChoice(id: "fall-q1-b", text: "Prevent the worker from reaching the hazard/edge", isCorrect: true),
                QuizChoice(id: "fall-q1-c", text: "Reduce arresting force below 1,800 lbs", isCorrect: false),
                QuizChoice(id: "fall-q1-d", text: "Provide rescue capability without additional planning", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "fall-q2",
            prompt: "Which factor is MOST critical when selecting an anchorage location for PFAS?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "fall-q2-a", text: "Convenience for movement", isCorrect: false),
                QuizChoice(id: "fall-q2-b", text: "Capability/approval of the anchorage for fall-arrest loading", isCorrect: true),
                QuizChoice(id: "fall-q2-c", text: "Proximity to a ladder", isCorrect: false),
                QuizChoice(id: "fall-q2-d", text: "Minimizing free-fall distance even if the point is not rated as an anchorage", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "fall-q3",
            prompt: "A worker ties off at waist level near an edge. The biggest added hazard created is:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "fall-q3-a", text: "Reduced visibility", isCorrect: false),
                QuizChoice(id: "fall-q3-b", text: "Swing fall with lateral impact against structure", isCorrect: true),
                QuizChoice(id: "fall-q3-c", text: "Overheating of the harness webbing", isCorrect: false),
                QuizChoice(id: "fall-q3-d", text: "Elimination of the need for rescue planning", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "fall-q4",
            prompt: "Clearance planning for PFAS should account for:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "fall-q4-a", text: "Free fall + deceleration + harness stretch + worker height + safety margin", isCorrect: true),
                QuizChoice(id: "fall-q4-b", text: "Free fall only", isCorrect: false),
                QuizChoice(id: "fall-q4-c", text: "Arresting force only", isCorrect: false),
                QuizChoice(id: "fall-q4-d", text: "Lanyard length only", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "fall-q5",
            prompt: "A roof has a skylight. What control best meets the “passive first” approach?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "fall-q5-a", text: "Cover/guard the opening so it can’t be stepped or fallen through", isCorrect: true),
                QuizChoice(id: "fall-q5-b", text: "Tell workers to stay away from the skylight", isCorrect: false),
                QuizChoice(id: "fall-q5-c", text: "Use only warning signs", isCorrect: false),
                QuizChoice(id: "fall-q5-d", text: "Rely on a spotter", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "fall-q6",
            prompt: "A PFAS harness has cuts, broken stitching, or missing labels. What is the correct disposition?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "fall-q6-a", text: "Return to service if it passed last month’s inspection", isCorrect: false),
                QuizChoice(id: "fall-q6-b", text: "Remove from service until evaluated/handled per the manufacturer program", isCorrect: true),
                QuizChoice(id: "fall-q6-c", text: "Tape over the damaged area and limit use to short tasks", isCorrect: false),
                QuizChoice(id: "fall-q6-d", text: "Use it only with a spotter", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "fall-q7",
            prompt: "When does fall protection training typically require retraining?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "fall-q7-a", text: "When changes occur or performance indicates the worker doesn’t understand", isCorrect: true),
                QuizChoice(id: "fall-q7-b", text: "Only every 5 years", isCorrect: false),
                QuizChoice(id: "fall-q7-c", text: "Only after a fall occurs", isCorrect: false),
                QuizChoice(id: "fall-q7-d", text: "Only when a new harness brand is purchased", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "fall-q8",
            prompt: "A rescue plan for fall arrest is necessary because:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "fall-q8-a", text: "Suspension after arrest introduces time-critical medical/operational risk", isCorrect: true),
                QuizChoice(id: "fall-q8-b", text: "It eliminates the need for anchor approval", isCorrect: false),
                QuizChoice(id: "fall-q8-c", text: "It replaces pre-use equipment inspection", isCorrect: false),
                QuizChoice(id: "fall-q8-d", text: "It allows use of damaged equipment", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "fall-q9",
            prompt: "A worker is on a ladder performing a brief task. The best inspection focus is:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "fall-q9-a", text: "Ladder condition, setup/angle, secure footing, and safe climbing practices", isCorrect: true),
                QuizChoice(id: "fall-q9-b", text: "PFAS tie-off is always required on portable ladders", isCorrect: false),
                QuizChoice(id: "fall-q9-c", text: "Only ensuring the worker is wearing gloves", isCorrect: false),
                QuizChoice(id: "fall-q9-d", text: "Only ensuring a supervisor is nearby", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "fall-q10",
            prompt: "Why is a body harness required versus a body belt for fall arrest?",
            difficulty: .easy,
            choices: [
                QuizChoice(id: "fall-q10-a", text: "A harness distributes arrest forces to reduce injury risk", isCorrect: true),
                QuizChoice(id: "fall-q10-b", text: "A belt is only for cold weather", isCorrect: false),
                QuizChoice(id: "fall-q10-c", text: "Belts cannot be tagged with user names", isCorrect: false),
                QuizChoice(id: "fall-q10-d", text: "A belt is only used for ladder climbing", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "fall-q11",
            prompt: "A horizontal lifeline is proposed across a bay to support multiple workers. The most correct requirement is that it be:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "fall-q11-a", text: "Designed/installed/used under a qualified person’s oversight due to system forces and deflection", isCorrect: true),
                QuizChoice(id: "fall-q11-b", text: "Installed by any worker as long as the cable is tight", isCorrect: false),
                QuizChoice(id: "fall-q11-c", text: "Used only with body belts to reduce harness stretch", isCorrect: false),
                QuizChoice(id: "fall-q11-d", text: "Allowed without design review if used for fewer than 30 minutes", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "fall-q12",
            prompt: "For fall arrest, anchorage selection is best described as:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "fall-q12-a", text: "A rated anchorage or an engineered solution meeting required strength and safety factors", isCorrect: true),
                QuizChoice(id: "fall-q12-b", text: "Any structural member that “looks solid” to the user", isCorrect: false),
                QuizChoice(id: "fall-q12-c", text: "Any handrail if the lanyard is short", isCorrect: false),
                QuizChoice(id: "fall-q12-d", text: "Any point above shoulder height, regardless of structural capacity", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "fall-q13",
            prompt: "In an aerial lift (manlift), the best tie-off practice for a harnessed worker is to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "fall-q13-a", text: "Connect to the manufacturer-approved anchor point in the basket/boom", isCorrect: true),
                QuizChoice(id: "fall-q13-b", text: "Tie off to a nearby building column for extra security", isCorrect: false),
                QuizChoice(id: "fall-q13-c", text: "Tie off to the lift’s guardrail to keep the lanyard out of the way", isCorrect: false),
                QuizChoice(id: "fall-q13-d", text: "Not tie off; the guardrail replaces PFAS in all lift operations", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "fall-q14",
            prompt: "To reduce swing-fall risk when using PFAS near an edge, the BEST method is to:",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "fall-q14-a", text: "Keep the anchorage as overhead as feasible and limit lateral travel from the tie-off point", isCorrect: true),
                QuizChoice(id: "fall-q14-b", text: "Use a longer lanyard so the user clears the structure", isCorrect: false),
                QuizChoice(id: "fall-q14-c", text: "Tie off at foot level to reduce line-of-sight hazards", isCorrect: false),
                QuizChoice(id: "fall-q14-d", text: "Rely on the deceleration device to prevent swing", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "fall-q15",
            prompt: "After any fall arrest event where the system has been loaded, the correct disposition of the equipment is generally to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "fall-q15-a", text: "Remove from service and handle per manufacturer guidance/competent inspection before any reuse", isCorrect: true),
                QuizChoice(id: "fall-q15-b", text: "Return to service if no visible damage is present", isCorrect: false),
                QuizChoice(id: "fall-q15-c", text: "Return to service after cleaning and drying only", isCorrect: false),
                QuizChoice(id: "fall-q15-d", text: "Use only for fall restraint from then on", isCorrect: false)
            ]
        )
    ]

    // MARK: Risk Management

    static let riskManagement: [QuizQuestion] = [
        QuizQuestion(
            id: "rm-q1",
            prompt: "Controls are selected and briefed. Mid-task, conditions change (new hazard). What is the correct RM action?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "rm-q1-a", text: "Continue; controls were already approved", isCorrect: false),
                QuizChoice(id: "rm-q1-b", text: "Re-identify/assess hazards and update controls before proceeding", isCorrect: true),
                QuizChoice(id: "rm-q1-c", text: "Skip reassessment if PPE is worn", isCorrect: false),
                QuizChoice(id: "rm-q1-d", text: "Only document it after the task is complete", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "rm-q2",
            prompt: "Which statement best reflects RM decision discipline?",
            difficulty: .easy,
            choices: [
                QuizChoice(id: "rm-q2-a", text: "Accept risk at the appropriate level of authority", isCorrect: true),
                QuizChoice(id: "rm-q2-b", text: "Accept risk at the lowest level to move fast", isCorrect: false),
                QuizChoice(id: "rm-q2-c", text: "Skip formal risk acceptance when the task is routine and has been done before", isCorrect: false),
                QuizChoice(id: "rm-q2-d", text: "Treat all hazards as identical to simplify planning", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "rm-q3",
            prompt: "A control reduces probability but increases exposure time. What should you do next in the RM process?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "rm-q3-a", text: "Implement immediately; probability is lower", isCorrect: false),
                QuizChoice(id: "rm-q3-b", text: "Reassess residual risk and determine if the tradeoff is acceptable", isCorrect: true),
                QuizChoice(id: "rm-q3-c", text: "Ignore exposure time; only severity matters", isCorrect: false),
                QuizChoice(id: "rm-q3-d", text: "Document later; execution should not be interrupted", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "rm-q4",
            prompt: "Which control is strongest for a recurring hazard when feasible?",
            difficulty: .easy,
            choices: [
                QuizChoice(id: "rm-q4-a", text: "Eliminate the hazard or engineer it out", isCorrect: true),
                QuizChoice(id: "rm-q4-b", text: "Post a warning sign", isCorrect: false),
                QuizChoice(id: "rm-q4-c", text: "Rely on PPE and reminders only", isCorrect: false),
                QuizChoice(id: "rm-q4-d", text: "Ask for more experienced workers only", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "rm-q5",
            prompt: "In a pre-task brief, “stop work” criteria should be:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "rm-q5-a", text: "Clear, observable triggers tied to hazards/controls", isCorrect: true),
                QuizChoice(id: "rm-q5-b", text: "Left vague so the team can decide later", isCorrect: false),
                QuizChoice(id: "rm-q5-c", text: "Only based on schedule impact", isCorrect: false),
                QuizChoice(id: "rm-q5-d", text: "Limited to weather events only", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "rm-q6",
            prompt: "A team is fatigued but wants to “push through.” Which RM principle is being violated first?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "rm-q6-a", text: "Accept no unnecessary risk", isCorrect: true),
                QuizChoice(id: "rm-q6-b", text: "Make risk decisions at the appropriate level", isCorrect: false),
                QuizChoice(id: "rm-q6-c", text: "Integrate RM into planning", isCorrect: false),
                QuizChoice(id: "rm-q6-d", text: "Apply process cyclically", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "rm-q7",
            prompt: "What is the most common failure mode in RM controls during execution?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "rm-q7-a", text: "Controls drift: shortcuts/changes without reassessment or supervision", isCorrect: true),
                QuizChoice(id: "rm-q7-b", text: "Too many signatures on the brief", isCorrect: false),
                QuizChoice(id: "rm-q7-c", text: "Using PPE in addition to other controls", isCorrect: false),
                QuizChoice(id: "rm-q7-d", text: "Documenting hazards in writing", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "rm-q8",
            prompt: "In Real-Time RM (ABCD), recognizing a sudden environmental change is primarily which step?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "rm-q8-a", text: "Assess", isCorrect: true),
                QuizChoice(id: "rm-q8-b", text: "Balance", isCorrect: false),
                QuizChoice(id: "rm-q8-c", text: "Communicate", isCorrect: false),
                QuizChoice(id: "rm-q8-d", text: "Do/Debrief", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "rm-q9",
            prompt: "Residual risk is the risk that remains after controls. The correct handling is to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "rm-q9-a", text: "Reassess and accept at the proper level before execution", isCorrect: true),
                QuizChoice(id: "rm-q9-b", text: "Ignore it if initial risk was accepted", isCorrect: false),
                QuizChoice(id: "rm-q9-c", text: "Treat it as zero because controls exist", isCorrect: false),
                QuizChoice(id: "rm-q9-d", text: "Document it only after the task completes", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "rm-q10",
            prompt: "Which is the best indicator that controls are effective?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "rm-q10-a", text: "Observed compliance and reduced hazard exposure during supervision", isCorrect: true),
                QuizChoice(id: "rm-q10-b", text: "No mishaps occurred last week", isCorrect: false),
                QuizChoice(id: "rm-q10-c", text: "The JHA exists in a binder", isCorrect: false),
                QuizChoice(id: "rm-q10-d", text: "Workers can’t recall the hazards but wear PPE", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "rm-q11",
            prompt: "A hazard has high potential severity but low probability. What is the most professional RM approach?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "rm-q11-a", text: "Treat it as low risk because the probability is low", isCorrect: false),
                QuizChoice(id: "rm-q11-b", text: "Use the matrix, but ensure controls and acceptance reflect worst-credible consequence and mission context", isCorrect: true),
                QuizChoice(id: "rm-q11-c", text: "Ignore it unless a near-miss already occurred", isCorrect: false),
                QuizChoice(id: "rm-q11-d", text: "Lower the severity category because probability is low", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "rm-q12",
            prompt: "A team implemented controls but supervision finds they are not followed in practice. Which RM step is failing first?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "rm-q12-a", text: "Implement Controls", isCorrect: true),
                QuizChoice(id: "rm-q12-b", text: "Identify Hazards", isCorrect: false),
                QuizChoice(id: "rm-q12-c", text: "Assess Hazards", isCorrect: false),
                QuizChoice(id: "rm-q12-d", text: "Make Decisions", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "rm-q13",
            prompt: "Which statement best distinguishes a hazard from risk?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "rm-q13-a", text: "A hazard is a condition with potential to cause harm; risk is severity and probability given exposure and controls", isCorrect: true),
                QuizChoice(id: "rm-q13-b", text: "Risk is the same as hazard; they are interchangeable terms", isCorrect: false),
                QuizChoice(id: "rm-q13-c", text: "Hazard is the RAC; risk is the probability only", isCorrect: false),
                QuizChoice(id: "rm-q13-d", text: "Hazard is an injury; risk is the paperwork used to report it", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "rm-q14",
            prompt: "In Real-Time RM (ABCD), the step most directly associated with updating the team’s shared mental model is:",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "rm-q14-a", text: "Communicate", isCorrect: true),
                QuizChoice(id: "rm-q14-b", text: "Assess", isCorrect: false),
                QuizChoice(id: "rm-q14-c", text: "Balance", isCorrect: false),
                QuizChoice(id: "rm-q14-d", text: "Do/Debrief", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "rm-q15",
            prompt: "A proposed control reduces risk but significantly degrades mission output. The most correct RM action is to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "rm-q15-a", text: "Reject the control without discussion because mission comes first", isCorrect: false),
                QuizChoice(id: "rm-q15-b", text: "Evaluate alternative controls and elevate the residual risk decision to the appropriate acceptance authority", isCorrect: true),
                QuizChoice(id: "rm-q15-c", text: "Implement the control anyway; all risk must be eliminated", isCorrect: false),
                QuizChoice(id: "rm-q15-d", text: "Delay the decision until after the task is complete", isCorrect: false)
            ]
        )
    ]

    // MARK: Roles & Responsibilities

    static let rolesResponsibilities: [QuizQuestion] = [
        QuizQuestion(
            id: "roles-q1",
            prompt: "During an inspection, who is normally responsible for correcting shop-level deficiencies?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "roles-q1-a", text: "The shop supervisor/functional owner with authority over the process", isCorrect: true),
                QuizChoice(id: "roles-q1-b", text: "The inspector who found the issue", isCorrect: false),
                QuizChoice(id: "roles-q1-c", text: "The newest worker in the area", isCorrect: false),
                QuizChoice(id: "roles-q1-d", text: "Only the installation safety office", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "roles-q2",
            prompt: "A credible imminent danger is identified. The correct immediate action is to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "roles-q2-a", text: "Stop/limit exposure, notify supervision, and control the area", isCorrect: true),
                QuizChoice(id: "roles-q2-b", text: "Document it and let the job finish to avoid delays", isCorrect: false),
                QuizChoice(id: "roles-q2-c", text: "Ask the worker to “be careful” and continue", isCorrect: false),
                QuizChoice(id: "roles-q2-d", text: "Wait to elevate until the weekly staff meeting", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "roles-q3",
            prompt: "The most effective role of a Unit Safety Representative (USR) is to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "roles-q3-a", text: "Enable the commander/supervisor program by tracking, advising, and following up", isCorrect: true),
                QuizChoice(id: "roles-q3-b", text: "Own all hazard fixes and fund all abatement", isCorrect: false),
                QuizChoice(id: "roles-q3-c", text: "Replace the supervisor’s responsibility for safety", isCorrect: false),
                QuizChoice(id: "roles-q3-d", text: "Only write reports; avoid field engagement", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "roles-q4",
            prompt: "Which is a supervisor responsibility that inspectors should verify?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "roles-q4-a", text: "Training, safe procedures/JHA, PPE enforcement, and hazard correction follow-up", isCorrect: true),
                QuizChoice(id: "roles-q4-b", text: "Only ensuring the shop looks clean during inspections", isCorrect: false),
                QuizChoice(id: "roles-q4-c", text: "Only reporting mishaps to external agencies", isCorrect: false),
                QuizChoice(id: "roles-q4-d", text: "Delegating all safety tasks to junior personnel", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "roles-q5",
            prompt: "Employees contribute most to the safety program by:",
            difficulty: .easy,
            choices: [
                QuizChoice(id: "roles-q5-a", text: "Following procedures, using PPE, and reporting hazards/near-misses early", isCorrect: true),
                QuizChoice(id: "roles-q5-b", text: "Waiting until inspections to mention hazards", isCorrect: false),
                QuizChoice(id: "roles-q5-c", text: "Only reporting hazards after an injury", isCorrect: false),
                QuizChoice(id: "roles-q5-d", text: "Fixing hazards without telling anyone to avoid paperwork", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "roles-q6",
            prompt: "A safety office typically adds the most value by:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "roles-q6-a", text: "Oversight, analysis, inspections, guidance, and program improvement", isCorrect: true),
                QuizChoice(id: "roles-q6-b", text: "Doing all shop corrective actions directly", isCorrect: false),
                QuizChoice(id: "roles-q6-c", text: "Avoiding leadership engagement to remain neutral", isCorrect: false),
                QuizChoice(id: "roles-q6-d", text: "Only writing policies without field validation", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "roles-q7",
            prompt: "When safety requirements conflict with mission urgency, the correct approach is to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "roles-q7-a", text: "Assess risk, apply controls, and elevate acceptance to the right authority", isCorrect: true),
                QuizChoice(id: "roles-q7-b", text: "Ignore safety to meet the deadline", isCorrect: false),
                QuizChoice(id: "roles-q7-c", text: "Let the most experienced worker decide alone", isCorrect: false),
                QuizChoice(id: "roles-q7-d", text: "Defer all decisions to an external agency", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "roles-q8",
            prompt: "A contractor is performing work in your area. A key host-unit responsibility is to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "roles-q8-a", text: "Coordinate hazards/rules and ensure safe integration into the worksite", isCorrect: true),
                QuizChoice(id: "roles-q8-b", text: "Assume the contractor’s program covers everything", isCorrect: false),
                QuizChoice(id: "roles-q8-c", text: "Prohibit the contractor from reporting hazards to the host", isCorrect: false),
                QuizChoice(id: "roles-q8-d", text: "Allow work without briefings if a COR is present", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "roles-q9",
            prompt: "During an inspection, your strongest influence tool for sustained change is:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "roles-q9-a", text: "Clear findings with actionable recommendations and accountable suspense/OPR", isCorrect: true),
                QuizChoice(id: "roles-q9-b", text: "Publicly calling out individuals for mistakes", isCorrect: false),
                QuizChoice(id: "roles-q9-c", text: "Only informal verbal feedback", isCorrect: false),
                QuizChoice(id: "roles-q9-d", text: "Letting the shop decide if the finding matters", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "roles-q10",
            prompt: "Which statement best defines the inspector’s role in abatement?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "roles-q10-a", text: "Verify corrective actions, document closure, and re-elevate if controls fail", isCorrect: true),
                QuizChoice(id: "roles-q10-b", text: "Close hazards once a plan is written", isCorrect: false),
                QuizChoice(id: "roles-q10-c", text: "Close hazards once funding is approved", isCorrect: false),
                QuizChoice(id: "roles-q10-d", text: "Transfer all hazards to safety office ownership permanently", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "roles-q11",
            prompt: "A supervisor disputes your inspection finding and argues “we’ve always done it this way.” The most effective professional response is to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "roles-q11-a", text: "Restate objective criteria, describe the hazard and risk, propose viable controls, and elevate through the chain if needed", isCorrect: true),
                QuizChoice(id: "roles-q11-b", text: "Close the finding to preserve relationships", isCorrect: false),
                QuizChoice(id: "roles-q11-c", text: "Argue until the supervisor agrees", isCorrect: false),
                QuizChoice(id: "roles-q11-d", text: "Document “disagreed” and take no further action", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "roles-q12",
            prompt: "A Unit Safety Rep identifies a high-risk hazard that cannot be corrected quickly. The correct next step is to ensure:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "roles-q12-a", text: "The hazard is documented, interim controls are applied, and it is tracked through the formal abatement process with leadership visibility", isCorrect: true),
                QuizChoice(id: "roles-q12-b", text: "It is handled informally inside the shop with no tracking to avoid attention", isCorrect: false),
                QuizChoice(id: "roles-q12-c", text: "It is closed once a purchase request is submitted", isCorrect: false),
                QuizChoice(id: "roles-q12-d", text: "It is delayed until the next annual inspection cycle", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "roles-q13",
            prompt: "Which scenario most clearly requires coordination with Bioenvironmental Engineering/Industrial Hygiene?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "roles-q13-a", text: "A suspected airborne exposure (noise, fumes, dust) where monitoring and exposure controls are needed", isCorrect: true),
                QuizChoice(id: "roles-q13-b", text: "A chipped paint mark on the floor boundary line", isCorrect: false),
                QuizChoice(id: "roles-q13-c", text: "A missing training slide in a briefing deck", isCorrect: false),
                QuizChoice(id: "roles-q13-d", text: "A mislabeled toolbox drawer", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "roles-q14",
            prompt: "From a program accountability standpoint, who owns ensuring workers are trained and standards are enforced day-to-day?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "roles-q14-a", text: "Supervisors and commanders; safety staff advise and verify but do not replace command responsibility", isCorrect: true),
                QuizChoice(id: "roles-q14-b", text: "Safety office only; supervisors are not responsible once a USR is appointed", isCorrect: false),
                QuizChoice(id: "roles-q14-c", text: "Workers only; leadership cannot enforce safety beyond policy memos", isCorrect: false),
                QuizChoice(id: "roles-q14-d", text: "Contractors; host-unit responsibility ends once a contract is awarded", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "roles-q15",
            prompt: "A best-practice inspection strategy for limited manpower is to prioritize:",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "roles-q15-a", text: "High-risk tasks/areas (severity and exposure) and recurrent deficiency trends", isCorrect: true),
                QuizChoice(id: "roles-q15-b", text: "Only easy wins that can be closed same-day", isCorrect: false),
                QuizChoice(id: "roles-q15-c", text: "Only administrative paperwork compliance", isCorrect: false),
                QuizChoice(id: "roles-q15-d", text: "Only areas that were recently inspected", isCorrect: false)
            ]
        )
    ]

    // MARK: Hazard Abatement

    static let hazardAbatement: [QuizQuestion] = [
        QuizQuestion(
            id: "abatement-q1",
            prompt: "Posting a warning sign for a serious hazard is best described as:",
            difficulty: .easy,
            choices: [
                QuizChoice(id: "abatement-q1-a", text: "Interim risk control, not permanent abatement", isCorrect: true),
                QuizChoice(id: "abatement-q1-b", text: "Permanent abatement", isCorrect: false),
                QuizChoice(id: "abatement-q1-c", text: "A substitute for engineering controls", isCorrect: false),
                QuizChoice(id: "abatement-q1-d", text: "A replacement for documentation", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "abatement-q2",
            prompt: "A hazard is “closed” when:",
            difficulty: .easy,
            choices: [
                QuizChoice(id: "abatement-q2-a", text: "Corrective action is completed and verified effective", isCorrect: true),
                QuizChoice(id: "abatement-q2-b", text: "A work order is submitted", isCorrect: false),
                QuizChoice(id: "abatement-q2-c", text: "Funding is approved", isCorrect: false),
                QuizChoice(id: "abatement-q2-d", text: "The next inspection is scheduled", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "abatement-q3",
            prompt: "The most important element of an abatement suspense is that it is:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "abatement-q3-a", text: "Owned by an OPR who has authority/resources to fix the issue", isCorrect: true),
                QuizChoice(id: "abatement-q3-b", text: "Assigned to any available person", isCorrect: false),
                QuizChoice(id: "abatement-q3-c", text: "Left open-ended to avoid pressure", isCorrect: false),
                QuizChoice(id: "abatement-q3-d", text: "Only set after the next inspection", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "abatement-q4",
            prompt: "Interim controls are most appropriate when:",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "abatement-q4-a", text: "Immediate elimination isn’t possible and exposure must be reduced now", isCorrect: true),
                QuizChoice(id: "abatement-q4-b", text: "They are easier than fixing the hazard", isCorrect: false),
                QuizChoice(id: "abatement-q4-c", text: "They allow closure of the hazard permanently", isCorrect: false),
                QuizChoice(id: "abatement-q4-d", text: "They replace the need for follow-up", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "abatement-q5",
            prompt: "If an interim control becomes the long-term “solution,” the most likely program failure is:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "abatement-q5-a", text: "Normalization of deviance (risk accepted by habit, not decision)", isCorrect: true),
                QuizChoice(id: "abatement-q5-b", text: "Over-documentation", isCorrect: false),
                QuizChoice(id: "abatement-q5-c", text: "Too many inspections", isCorrect: false),
                QuizChoice(id: "abatement-q5-d", text: "Excessive engineering controls", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "abatement-q6",
            prompt: "A repeat finding indicates the corrective action was:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "abatement-q6-a", text: "Ineffective, not sustained, or not implemented as intended", isCorrect: true),
                QuizChoice(id: "abatement-q6-b", text: "Automatically acceptable if the area is busy", isCorrect: false),
                QuizChoice(id: "abatement-q6-c", text: "Only a documentation problem", isCorrect: false),
                QuizChoice(id: "abatement-q6-d", text: "Evidence the inspector is too strict", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "abatement-q7",
            prompt: "The best closure verification method for a complex hazard is:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "abatement-q7-a", text: "Field validation: observe the process/equipment under normal conditions", isCorrect: true),
                QuizChoice(id: "abatement-q7-b", text: "A photo of a work order number", isCorrect: false),
                QuizChoice(id: "abatement-q7-c", text: "A verbal assurance from a technician", isCorrect: false),
                QuizChoice(id: "abatement-q7-d", text: "Waiting for the next annual inspection", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "abatement-q8",
            prompt: "If abatement is delayed due to mission constraints, the correct path is to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "abatement-q8-a", text: "Document risk, implement interim controls, and elevate acceptance as required", isCorrect: true),
                QuizChoice(id: "abatement-q8-b", text: "Close the hazard because it cannot be fixed now", isCorrect: false),
                QuizChoice(id: "abatement-q8-c", text: "Stop tracking until funds arrive", isCorrect: false),
                QuizChoice(id: "abatement-q8-d", text: "Lower the risk code to justify delay", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "abatement-q9",
            prompt: "Which detail makes abatement tracking most actionable?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "abatement-q9-a", text: "Specific corrective action, OPR, suspense, and verification method", isCorrect: true),
                QuizChoice(id: "abatement-q9-b", text: "A generic statement: “fix ASAP”", isCorrect: false),
                QuizChoice(id: "abatement-q9-c", text: "Only the hazard title", isCorrect: false),
                QuizChoice(id: "abatement-q9-d", text: "Only the inspector’s opinion on urgency", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "abatement-q10",
            prompt: "For high-risk hazards, the most effective near-term approach is to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "abatement-q10-a", text: "Reduce exposure immediately and drive permanent correction in parallel", isCorrect: true),
                QuizChoice(id: "abatement-q10-b", text: "Wait for the next budget cycle before acting", isCorrect: false),
                QuizChoice(id: "abatement-q10-c", text: "Rely on PPE only and close the hazard", isCorrect: false),
                QuizChoice(id: "abatement-q10-d", text: "Avoid documenting until the fix is complete", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "abatement-q11",
            prompt: "A hazard has been identified and cannot be permanently corrected within the near term. The most correct program action is to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "abatement-q11-a", text: "Enter it into formal tracking, apply interim controls, and manage to a documented suspense and verification plan", isCorrect: true),
                QuizChoice(id: "abatement-q11-b", text: "Wait to document until the fix is funded", isCorrect: false),
                QuizChoice(id: "abatement-q11-c", text: "Close the hazard since the unit cannot fix it immediately", isCorrect: false),
                QuizChoice(id: "abatement-q11-d", text: "Remove the finding if no mishap has occurred", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "abatement-q12",
            prompt: "Which statement best reflects the difference between interim controls and abatement?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "abatement-q12-a", text: "Interim controls reduce exposure; abatement eliminates or permanently controls the hazard", isCorrect: true),
                QuizChoice(id: "abatement-q12-b", text: "Interim controls eliminate the hazard; abatement just documents it", isCorrect: false),
                QuizChoice(id: "abatement-q12-c", text: "There is no difference if a supervisor accepts the risk", isCorrect: false),
                QuizChoice(id: "abatement-q12-d", text: "A sign is always considered abatement if it’s posted at the entrance", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "abatement-q13",
            prompt: "An abatement project is funded and scheduled but not yet executed. The hazard status should remain:",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "abatement-q13-a", text: "Open (with interim controls tracked) until the corrective action is completed and verified", isCorrect: true),
                QuizChoice(id: "abatement-q13-b", text: "Closed because funds are committed", isCorrect: false),
                QuizChoice(id: "abatement-q13-c", text: "Closed if a work order exists", isCorrect: false),
                QuizChoice(id: "abatement-q13-d", text: "Transfered to “no longer a hazard” status automatically", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "abatement-q14",
            prompt: "If interim controls degrade over time and the risk increases, the best action is to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "abatement-q14-a", text: "Reassess the hazard/RAC, strengthen controls, and elevate acceptance/abatement priority as required", isCorrect: true),
                QuizChoice(id: "abatement-q14-b", text: "Keep the same RAC to avoid changing the paperwork", isCorrect: false),
                QuizChoice(id: "abatement-q14-c", text: "Wait until the next scheduled inspection to revisit", isCorrect: false),
                QuizChoice(id: "abatement-q14-d", text: "Close it; interim controls indicate it’s manageable", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "abatement-q15",
            prompt: "Which element most often makes abatement succeed in the real world when resources are constrained?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "abatement-q15-a", text: "Clear leadership prioritization tied to risk, a real suspense, and accountability for execution and verification", isCorrect: true),
                QuizChoice(id: "abatement-q15-b", text: "An email stating “fix this” with no owner or suspense", isCorrect: false),
                QuizChoice(id: "abatement-q15-c", text: "Relying solely on PPE because it is faster to issue", isCorrect: false),
                QuizChoice(id: "abatement-q15-d", text: "Only documenting hazards after they are corrected", isCorrect: false)
            ]
        )
    ]

    // MARK: RAC System

    static let racSystem: [QuizQuestion] = [
        QuizQuestion(
            id: "rac-q1",
            prompt: "RAC is derived primarily from:",
            difficulty: .easy,
            choices: [
                QuizChoice(id: "rac-q1-a", text: "Severity and probability", isCorrect: true),
                QuizChoice(id: "rac-q1-b", text: "Cost of abatement only", isCorrect: false),
                QuizChoice(id: "rac-q1-c", text: "Who reported the hazard", isCorrect: false),
                QuizChoice(id: "rac-q1-d", text: "Number of inspections completed", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "rac-q2",
            prompt: "Severity should be assessed as the:",
            difficulty: .easy,
            choices: [
                QuizChoice(id: "rac-q2-a", text: "Worst credible consequence if the hazard occurs", isCorrect: true),
                QuizChoice(id: "rac-q2-b", text: "Average consequence based on history", isCorrect: false),
                QuizChoice(id: "rac-q2-c", text: "Least likely consequence", isCorrect: false),
                QuizChoice(id: "rac-q2-d", text: "Cost of the fix", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "rac-q3",
            prompt: "Probability assessment should consider exposure and likelihood. The most defensible method is to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "rac-q3-a", text: "Use defined criteria consistently and document the rationale", isCorrect: true),
                QuizChoice(id: "rac-q3-b", text: "Assign based on gut feel only", isCorrect: false),
                QuizChoice(id: "rac-q3-c", text: "Pick the most optimistic category to avoid elevating the issue", isCorrect: false),
                QuizChoice(id: "rac-q3-d", text: "Only consider how often the inspector sees it", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "rac-q4",
            prompt: "A control reduces probability but not severity. The RAC should generally:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "rac-q4-a", text: "Decrease (lower risk) if the probability reduction is real and sustained", isCorrect: true),
                QuizChoice(id: "rac-q4-b", text: "Increase because controls add complexity", isCorrect: false),
                QuizChoice(id: "rac-q4-c", text: "Remain the same automatically", isCorrect: false),
                QuizChoice(id: "rac-q4-d", text: "Be set to the highest value regardless", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "rac-q5",
            prompt: "A missing machine guard in a high-traffic area is discovered. The best initial RAC action is to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "rac-q5-a", text: "Assess severity/probability and apply the approved matrix before assigning", isCorrect: true),
                QuizChoice(id: "rac-q5-b", text: "Assign the highest RAC immediately without assessment", isCorrect: false),
                QuizChoice(id: "rac-q5-c", text: "Assign the lowest RAC until an injury occurs", isCorrect: false),
                QuizChoice(id: "rac-q5-d", text: "Skip RAC and focus only on corrective action", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "rac-q6",
            prompt: "A higher-risk RAC should primarily drive:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "rac-q6-a", text: "Urgency, leadership attention, and required acceptance/abatement actions", isCorrect: true),
                QuizChoice(id: "rac-q6-b", text: "Less documentation and fewer inspections", isCorrect: false),
                QuizChoice(id: "rac-q6-c", text: "Lower priority to avoid disrupting operations", isCorrect: false),
                QuizChoice(id: "rac-q6-d", text: "Automatic closure once interim controls are posted", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "rac-q7",
            prompt: "Which is the MOST common reason two inspectors assign different RACs to the same hazard?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "rac-q7-a", text: "Different assumptions about exposure/probability criteria", isCorrect: true),
                QuizChoice(id: "rac-q7-b", text: "Different uniform items", isCorrect: false),
                QuizChoice(id: "rac-q7-c", text: "Matrix use is optional", isCorrect: false),
                QuizChoice(id: "rac-q7-d", text: "Probability is never part of RAC", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "rac-q8",
            prompt: "Residual RAC should be reassessed when:",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "rac-q8-a", text: "Controls change, conditions change, or performance indicates drift", isCorrect: true),
                QuizChoice(id: "rac-q8-b", text: "Only at annual program reviews", isCorrect: false),
                QuizChoice(id: "rac-q8-c", text: "Only after an injury", isCorrect: false),
                QuizChoice(id: "rac-q8-d", text: "Only if the unit requests it", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "rac-q9",
            prompt: "If you are unsure about severity/probability categories, the best professional action is to:",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "rac-q9-a", text: "Align with the safety office/standard criteria to stay consistent", isCorrect: true),
                QuizChoice(id: "rac-q9-b", text: "Pick a number that feels safe", isCorrect: false),
                QuizChoice(id: "rac-q9-c", text: "Assign the lowest RAC to avoid escalation", isCorrect: false),
                QuizChoice(id: "rac-q9-d", text: "Avoid documenting assumptions", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "rac-q10",
            prompt: "Which statement best reflects RAC integrity?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "rac-q10-a", text: "RAC reflects the hazard, not mission pressure or convenience", isCorrect: true),
                QuizChoice(id: "rac-q10-b", text: "RAC can be adjusted down if the mission is behind schedule", isCorrect: false),
                QuizChoice(id: "rac-q10-c", text: "RAC is only used after mishaps", isCorrect: false),
                QuizChoice(id: "rac-q10-d", text: "RAC is optional if the shop is high performing", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "rac-q11",
            prompt: "When assessing severity, the best practice is to base it on:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "rac-q11-a", text: "Worst credible consequence, given the hazard and exposure scenario", isCorrect: true),
                QuizChoice(id: "rac-q11-b", text: "Best-case outcome if everything goes right", isCorrect: false),
                QuizChoice(id: "rac-q11-c", text: "What happened last time", isCorrect: false),
                QuizChoice(id: "rac-q11-d", text: "The inspector’s preference for conservative ratings without justification", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "rac-q12",
            prompt: "Two plausible outcomes exist: (1) minor first-aid, (2) severe injury under credible worst-case conditions. Which severity should drive the RAC?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "rac-q12-a", text: "The worst credible consequence, not the most common minor outcome", isCorrect: true),
                QuizChoice(id: "rac-q12-b", text: "The minor first-aid outcome because it is most likely", isCorrect: false),
                QuizChoice(id: "rac-q12-c", text: "Always pick the middle category to be fair", isCorrect: false),
                QuizChoice(id: "rac-q12-d", text: "Severity doesn’t matter if probability is low", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "rac-q13",
            prompt: "Initial risk versus residual risk is best described as:",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "rac-q13-a", text: "Initial = before controls; residual = after controls; acceptance should be based on residual risk", isCorrect: true),
                QuizChoice(id: "rac-q13-b", text: "Initial = after controls; residual = before controls", isCorrect: false),
                QuizChoice(id: "rac-q13-c", text: "Residual risk is always zero if a JHA exists", isCorrect: false),
                QuizChoice(id: "rac-q13-d", text: "Initial and residual are the same; only documentation changes", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "rac-q14",
            prompt: "If a shop’s RAC assignments are inconsistent across similar hazards, the strongest corrective action is to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "rac-q14-a", text: "Standardize criteria, calibrate with examples, and require documented justification", isCorrect: true),
                QuizChoice(id: "rac-q14-b", text: "Let each supervisor define their own matrix", isCorrect: false),
                QuizChoice(id: "rac-q14-c", text: "Stop assigning RAC to avoid conflict", isCorrect: false),
                QuizChoice(id: "rac-q14-d", text: "Default every hazard to a mid-level RAC", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "rac-q15",
            prompt: "RAC is most useful to leadership because it helps drive:",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "rac-q15-a", text: "Prioritization of resources, acceptance authority, and abatement urgency", isCorrect: true),
                QuizChoice(id: "rac-q15-b", text: "The number of inspections required per quarter", isCorrect: false),
                QuizChoice(id: "rac-q15-c", text: "Which individual to blame for a hazard", isCorrect: false),
                QuizChoice(id: "rac-q15-d", text: "Only the formatting of the hazard report", isCorrect: false)
            ]
        )
    ]

    // MARK: Confined Space

    static let confinedSpace: [QuizQuestion] = [
        QuizQuestion(
            id: "cs-q1",
            prompt: "A confined space becomes “permit-required” primarily when it:",
            difficulty: .easy,
            choices: [
                QuizChoice(id: "cs-q1-a", text: "Contains or has potential to contain a serious hazard", isCorrect: true),
                QuizChoice(id: "cs-q1-b", text: "Has a ladder inside", isCorrect: false),
                QuizChoice(id: "cs-q1-c", text: "Is below ground level", isCorrect: false),
                QuizChoice(id: "cs-q1-d", text: "Has limited means of entry or exit", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "cs-q2",
            prompt: "Atmospheric testing order for confined space entry should be:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "cs-q2-a", text: "Oxygen, flammables, toxics", isCorrect: true),
                QuizChoice(id: "cs-q2-b", text: "Flammables, oxygen, toxics", isCorrect: false),
                QuizChoice(id: "cs-q2-c", text: "Toxics, oxygen, flammables", isCorrect: false),
                QuizChoice(id: "cs-q2-d", text: "Any order as long as you test all three", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "cs-q3",
            prompt: "A permit space has only an atmospheric hazard controlled by forced-air ventilation. A compliant approach is:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "cs-q3-a", text: "Use alternate procedures with ventilation and continuous/periodic monitoring", isCorrect: true),
                QuizChoice(id: "cs-q3-b", text: "Reclassify permanently with no monitoring", isCorrect: false),
                QuizChoice(id: "cs-q3-c", text: "Skip documentation if the fan is running", isCorrect: false),
                QuizChoice(id: "cs-q3-d", text: "Allow entry without an attendant if the entrant is experienced", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "cs-q4",
            prompt: "Reclassification from permit-required to non-permit is allowed only when hazards are:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "cs-q4-a", text: "Eliminated (not just controlled) and the basis is documented", isCorrect: true),
                QuizChoice(id: "cs-q4-b", text: "Reduced by PPE", isCorrect: false),
                QuizChoice(id: "cs-q4-c", text: "Reduced by warning signs", isCorrect: false),
                QuizChoice(id: "cs-q4-d", text: "Accepted by the supervisor", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "cs-q5",
            prompt: "Primary attendant responsibility is to:",
            difficulty: .easy,
            choices: [
                QuizChoice(id: "cs-q5-a", text: "Monitor entrants/conditions and order evacuation when hazards arise", isCorrect: true),
                QuizChoice(id: "cs-q5-b", text: "Enter the space to assist when needed", isCorrect: false),
                QuizChoice(id: "cs-q5-c", text: "Perform the work while the entrant rests", isCorrect: false),
                QuizChoice(id: "cs-q5-d", text: "Leave the area if conditions appear stable", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "cs-q6",
            prompt: "A key permit element that often gets missed but drives effectiveness is:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "cs-q6-a", text: "Isolation/energy control method and verification", isCorrect: true),
                QuizChoice(id: "cs-q6-b", text: "The entrant’s rank", isCorrect: false),
                QuizChoice(id: "cs-q6-c", text: "Tool brand selection", isCorrect: false),
                QuizChoice(id: "cs-q6-d", text: "A generic “be careful” note", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "cs-q7",
            prompt: "A meter reads O2 at 19.2%. Correct entry decision is:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "cs-q7-a", text: "Do not enter; treat as oxygen-deficient until corrected and re-tested", isCorrect: true),
                QuizChoice(id: "cs-q7-b", text: "Enter; any value near 21% is fine", isCorrect: false),
                QuizChoice(id: "cs-q7-c", text: "Enter with ear protection only", isCorrect: false),
                QuizChoice(id: "cs-q7-d", text: "Enter and retest later", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "cs-q8",
            prompt: "When a vertical entry has potential for rescue, the best pre-planned rescue control is:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "cs-q8-a", text: "Retrieval system/tripod when it won’t increase risk", isCorrect: true),
                QuizChoice(id: "cs-q8-b", text: "Rely only on calling emergency services", isCorrect: false),
                QuizChoice(id: "cs-q8-c", text: "Have the attendant enter to lift the entrant", isCorrect: false),
                QuizChoice(id: "cs-q8-d", text: "Wait to plan rescue until after entry starts", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "cs-q9",
            prompt: "Why is “continuous monitoring” often required even after acceptable pre-entry tests?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "cs-q9-a", text: "Atmospheres can stratify/shift during work and create new hazards", isCorrect: true),
                QuizChoice(id: "cs-q9-b", text: "It’s only required to satisfy paperwork requirements", isCorrect: false),
                QuizChoice(id: "cs-q9-c", text: "Meters are never accurate at the start", isCorrect: false),
                QuizChoice(id: "cs-q9-d", text: "It replaces ventilation", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "cs-q10",
            prompt: "The strongest control for a hazardous line feeding a permit space is to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "cs-q10-a", text: "Physically isolate (blank/blind or equivalent) and verify isolation", isCorrect: true),
                QuizChoice(id: "cs-q10-b", text: "Post a sign to warn workers", isCorrect: false),
                QuizChoice(id: "cs-q10-c", text: "Rely on PPE only", isCorrect: false),
                QuizChoice(id: "cs-q10-d", text: "Ask operators to “not use the line”", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "cs-q11",
            prompt: "Which is an attendant’s critical duty during permit-required confined space entry?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "cs-q11-a", text: "Remain outside, maintain accountability, communicate, and initiate rescue response without entering", isCorrect: true),
                QuizChoice(id: "cs-q11-b", text: "Enter immediately if the entrant stops responding", isCorrect: false),
                QuizChoice(id: "cs-q11-c", text: "Perform the work inside while entrants take breaks", isCorrect: false),
                QuizChoice(id: "cs-q11-d", text: "Cancel the permit once the entrant says it feels safe", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "cs-q12",
            prompt: "Reclassifying a permit-required confined space to non-permit is appropriate only when hazards are:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "cs-q12-a", text: "Eliminated (not just controlled) for the duration of the entry", isCorrect: true),
                QuizChoice(id: "cs-q12-b", text: "Controlled by PPE for the duration of the entry", isCorrect: false),
                QuizChoice(id: "cs-q12-c", text: "Reduced by warning signs and an experienced entrant", isCorrect: false),
                QuizChoice(id: "cs-q12-d", text: "Below the action level without ventilation", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "cs-q13",
            prompt: "A multi-gas meter shows acceptable readings. Which practice best protects against bad instrumentation?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "cs-q13-a", text: "Verify meter function per program (e.g., bump test/verification) and follow required monitoring frequency", isCorrect: true),
                QuizChoice(id: "cs-q13-b", text: "Skip verification if the meter has a current calibration sticker", isCorrect: false),
                QuizChoice(id: "cs-q13-c", text: "Test only for oxygen; other sensors are optional", isCorrect: false),
                QuizChoice(id: "cs-q13-d", text: "Rely on smell to confirm safe atmosphere", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "cs-q14",
            prompt: "An engulfment hazard exists from a gravity-fed product line. The strongest control before entry is to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "cs-q14-a", text: "Isolate using positive means (blanking/blinding, double block and bleed where approved) and verify", isCorrect: true),
                QuizChoice(id: "cs-q14-b", text: "Post a barricade at the space entrance", isCorrect: false),
                QuizChoice(id: "cs-q14-c", text: "Have the entrant hold the valve handle during entry", isCorrect: false),
                QuizChoice(id: "cs-q14-d", text: "Use only respiratory protection to prevent engulfment", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "cs-q15",
            prompt: "A permit space entry is in progress. Monitoring shows oxygen dropping and LEL rising. The best immediate action is to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "cs-q15-a", text: "Order evacuation and reassess controls before resuming entry", isCorrect: true),
                QuizChoice(id: "cs-q15-b", text: "Continue; the initial readings were acceptable", isCorrect: false),
                QuizChoice(id: "cs-q15-c", text: "Have the attendant enter to check the meter reading", isCorrect: false),
                QuizChoice(id: "cs-q15-d", text: "Switch to a different meter and keep working", isCorrect: false)
            ]
        )
    ]

    // MARK: Hot Work

    static let hotWork: [QuizQuestion] = [
        QuizQuestion(
            id: "hot-q1",
            prompt: "Hot work outside a designated area generally requires:",
            difficulty: .easy,
            choices: [
                QuizChoice(id: "hot-q1-a", text: "A permit after site evaluation and controls are confirmed", isCorrect: true),
                QuizChoice(id: "hot-q1-b", text: "No controls if a fire extinguisher is nearby", isCorrect: false),
                QuizChoice(id: "hot-q1-c", text: "Only ear protection", isCorrect: false),
                QuizChoice(id: "hot-q1-d", text: "No permit if a supervisor is physically present", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "hot-q2",
            prompt: "Combustible materials within the typical hot work danger zone must be:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "hot-q2-a", text: "Removed or protected/shielded to prevent ignition", isCorrect: true),
                QuizChoice(id: "hot-q2-b", text: "Left in place if the operator believes sparks will not reach them", isCorrect: false),
                QuizChoice(id: "hot-q2-c", text: "Allowed if a sign is posted", isCorrect: false),
                QuizChoice(id: "hot-q2-d", text: "Wet down only; shielding is unnecessary", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "hot-q3",
            prompt: "The fire watch should be equipped and empowered to:",
            difficulty: .easy,
            choices: [
                QuizChoice(id: "hot-q3-a", text: "Stop work and extinguish incipient fires; monitor after completion per permit", isCorrect: true),
                QuizChoice(id: "hot-q3-b", text: "Weld when the welder needs a break", isCorrect: false),
                QuizChoice(id: "hot-q3-c", text: "Leave once sparks stop", isCorrect: false),
                QuizChoice(id: "hot-q3-d", text: "Only call a supervisor if flames appear", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "hot-q4",
            prompt: "A common hidden hot work hazard is sparks traveling through:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "hot-q4-a", text: "Openings/penetrations to adjacent areas or levels", isCorrect: true),
                QuizChoice(id: "hot-q4-b", text: "Only welded seams", isCorrect: false),
                QuizChoice(id: "hot-q4-c", text: "Only concrete floors", isCorrect: false),
                QuizChoice(id: "hot-q4-d", text: "Only enclosed rooms", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "hot-q5",
            prompt: "Before welding/cutting on a container that held flammables, the most critical requirement is to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "hot-q5-a", text: "Clean/purge/verify it is safe; treat as hazardous until proven otherwise", isCorrect: true),
                QuizChoice(id: "hot-q5-b", text: "Open the lid and start welding to “burn off” residue", isCorrect: false),
                QuizChoice(id: "hot-q5-c", text: "Rely on a fire watch only", isCorrect: false),
                QuizChoice(id: "hot-q5-d", text: "Paint over labels to prevent confusion", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "hot-q6",
            prompt: "The correct handling of oxygen regulator fittings is to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "hot-q6-a", text: "Keep free of oil/grease and open valves slowly", isCorrect: true),
                QuizChoice(id: "hot-q6-b", text: "Lubricate threads for a better seal", isCorrect: false),
                QuizChoice(id: "hot-q6-c", text: "Use any wrench regardless of damage", isCorrect: false),
                QuizChoice(id: "hot-q6-d", text: "Store regulators attached with valves open", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "hot-q7",
            prompt: "Why do designated hot work areas reduce permit burden?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "hot-q7-a", text: "They are engineered/managed to control combustibles and ventilation by design", isCorrect: true),
                QuizChoice(id: "hot-q7-b", text: "They eliminate all fire risk automatically", isCorrect: false),
                QuizChoice(id: "hot-q7-c", text: "They allow welding without PPE", isCorrect: false),
                QuizChoice(id: "hot-q7-d", text: "They replace the need for training", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "hot-q8",
            prompt: "If hot work must occur near combustibles that cannot be moved, the best control is:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "hot-q8-a", text: "Shield with fire-resistant barriers and manage sparks/slag travel", isCorrect: true),
                QuizChoice(id: "hot-q8-b", text: "Rely on a fire watch only", isCorrect: false),
                QuizChoice(id: "hot-q8-c", text: "Speed up welding to reduce heat", isCorrect: false),
                QuizChoice(id: "hot-q8-d", text: "Skip the permit if the job is short", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "hot-q9",
            prompt: "A key reason hot work permits fail is they:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "hot-q9-a", text: "Confirm controls on paper but aren’t validated in the field before start", isCorrect: true),
                QuizChoice(id: "hot-q9-b", text: "Include too much technical detail", isCorrect: false),
                QuizChoice(id: "hot-q9-c", text: "Do not assign clear roles (fire watch, monitoring) and stop-work criteria", isCorrect: false),
                QuizChoice(id: "hot-q9-d", text: "Require PPE selection", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "hot-q10",
            prompt: "For hot work in an enclosed area, the primary added control often required is:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "hot-q10-a", text: "Ventilation and monitoring for fumes/oxygen displacement as applicable", isCorrect: true),
                QuizChoice(id: "hot-q10-b", text: "Posting additional signage without changing ventilation", isCorrect: false),
                QuizChoice(id: "hot-q10-c", text: "Only increasing lighting", isCorrect: false),
                QuizChoice(id: "hot-q10-d", text: "Only adding a second welder", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "hot-q11",
            prompt: "A common baseline for the hot work hazard zone (combustible control radius) is approximately:",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "hot-q11-a", text: "About 35 feet, unless the area is engineered/controlled as a designated hot work area", isCorrect: true),
                QuizChoice(id: "hot-q11-b", text: "About 5 feet; sparks don’t travel far", isCorrect: false),
                QuizChoice(id: "hot-q11-c", text: "About 10 feet; anything beyond is safe", isCorrect: false),
                QuizChoice(id: "hot-q11-d", text: "No radius is needed if a fire watch is present", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "hot-q12",
            prompt: "After hot work stops, the fire watch should generally remain long enough to detect smoldering ignition—typically:",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "hot-q12-a", text: "At least 30 minutes (or per local permit/program requirements)", isCorrect: true),
                QuizChoice(id: "hot-q12-b", text: "0 minutes; once the arc stops there is no ignition risk", isCorrect: false),
                QuizChoice(id: "hot-q12-c", text: "Only until the welder packs up tools", isCorrect: false),
                QuizChoice(id: "hot-q12-d", text: "Only if flames were observed", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "hot-q13",
            prompt: "Welding/cutting on coated metals (e.g., painted, galvanized) often requires additional controls because:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "hot-q13-a", text: "Fumes can be hazardous; local exhaust ventilation and exposure controls may be required", isCorrect: true),
                QuizChoice(id: "hot-q13-b", text: "The coating makes sparks colder", isCorrect: false),
                QuizChoice(id: "hot-q13-c", text: "It eliminates the need for PPE", isCorrect: false),
                QuizChoice(id: "hot-q13-d", text: "Permits are not required on coated metals", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "hot-q14",
            prompt: "The most correct statement about oxygen/fuel gas cylinders for welding operations is:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "hot-q14-a", text: "Store/secure cylinders, separate oxygen and fuel gas per program, and protect valves/caps during transport", isCorrect: true),
                QuizChoice(id: "hot-q14-b", text: "Store cylinders lying down to reduce tipping risk", isCorrect: false),
                QuizChoice(id: "hot-q14-c", text: "Keep oxygen regulators greased to prevent sticking", isCorrect: false),
                QuizChoice(id: "hot-q14-d", text: "Open cylinder valves fully and leave them open when unattended", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "hot-q15",
            prompt: "A hot work permit is being prepared in a facility with aircraft fuel system work nearby. The most correct additional control focus is to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "hot-q15-a", text: "Validate the area is free of flammable vapors and isolate/purge as required before authorizing hot work", isCorrect: true),
                QuizChoice(id: "hot-q15-b", text: "Proceed if the welder wears thicker gloves", isCorrect: false),
                QuizChoice(id: "hot-q15-c", text: "Rely on a fire extinguisher only", isCorrect: false),
                QuizChoice(id: "hot-q15-d", text: "Skip coordination; hot work permits are self-contained", isCorrect: false)
            ]
        )
    ]

    // MARK: Hearing Conservation

    static let hearingConservation: [QuizQuestion] = [
        QuizQuestion(
            id: "hc-q1",
            prompt: "The hearing conservation program action level is generally triggered at:",
            difficulty: .easy,
            choices: [
                QuizChoice(id: "hc-q1-a", text: "85 dBA (8-hr TWA) exposure", isCorrect: true),
                QuizChoice(id: "hc-q1-b", text: "70 dBA exposure", isCorrect: false),
                QuizChoice(id: "hc-q1-c", text: "95 dBA exposure", isCorrect: false),
                QuizChoice(id: "hc-q1-d", text: "Any single loud noise event", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "hc-q2",
            prompt: "Before relying on hearing PPE, the first priority controls for hazardous noise are:",
            difficulty: .easy,
            choices: [
                QuizChoice(id: "hc-q2-a", text: "Engineering controls (enclosure/damping) and feasible administrative controls", isCorrect: true),
                QuizChoice(id: "hc-q2-b", text: "Posters reminding people to wear earplugs", isCorrect: false),
                QuizChoice(id: "hc-q2-c", text: "Only warning signs", isCorrect: false),
                QuizChoice(id: "hc-q2-d", text: "Only rotating workers without assessing exposure", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "hc-q3",
            prompt: "A Standard Threshold Shift (STS) is identified. The immediate program response should include:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "hc-q3-a", text: "Notify, refit/retrain on protectors, and evaluate attenuation adequacy", isCorrect: true),
                QuizChoice(id: "hc-q3-b", text: "Remove the worker from employment", isCorrect: false),
                QuizChoice(id: "hc-q3-c", text: "Ignore it if they wore PPE", isCorrect: false),
                QuizChoice(id: "hc-q3-d", text: "Only post a sign at the shop door", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "hc-q4",
            prompt: "Why is posted “hazardous noise area” signage a weak standalone control?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "hc-q4-a", text: "It depends on behavior; it doesn’t reduce noise at the source", isCorrect: true),
                QuizChoice(id: "hc-q4-b", text: "It is not allowed in any program", isCorrect: false),
                QuizChoice(id: "hc-q4-c", text: "It automatically eliminates need for training", isCorrect: false),
                QuizChoice(id: "hc-q4-d", text: "It is stronger than engineering controls", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "hc-q5",
            prompt: "The best indicator that hearing protectors are “working” is:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "hc-q5-a", text: "Verified fit/attenuation and observed consistent wear in noise areas", isCorrect: true),
                QuizChoice(id: "hc-q5-b", text: "Employees say they ‘feel fine’", isCorrect: false),
                QuizChoice(id: "hc-q5-c", text: "Plugs are available at the tool crib", isCorrect: false),
                QuizChoice(id: "hc-q5-d", text: "Signs are posted", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "hc-q6",
            prompt: "A common field failure with earplugs that drives poor protection is:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "hc-q6-a", text: "Improper insertion/fit (not rolled/seated correctly)", isCorrect: true),
                QuizChoice(id: "hc-q6-b", text: "Using foam plugs instead of custom plugs", isCorrect: false),
                QuizChoice(id: "hc-q6-c", text: "Wearing plugs and muffs together", isCorrect: false),
                QuizChoice(id: "hc-q6-d", text: "Cleaning reusable plugs", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "hc-q7",
            prompt: "When new equipment changes shop noise levels, the correct program action is to:",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "hc-q7-a", text: "Reassess noise exposure and update controls/PPE requirements", isCorrect: true),
                QuizChoice(id: "hc-q7-b", text: "Keep the old program because signs already exist", isCorrect: false),
                QuizChoice(id: "hc-q7-c", text: "Wait for the next injury to confirm the hazard", isCorrect: false),
                QuizChoice(id: "hc-q7-d", text: "Assume PPE is sufficient without evaluation", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "hc-q8",
            prompt: "If an employee provides their own hearing protection, the employer must:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "hc-q8-a", text: "Ensure it is adequate, maintained, and used correctly", isCorrect: true),
                QuizChoice(id: "hc-q8-b", text: "Accept it without review", isCorrect: false),
                QuizChoice(id: "hc-q8-c", text: "Only ensure it is worn; adequacy is the employee’s responsibility", isCorrect: false),
                QuizChoice(id: "hc-q8-d", text: "Only track it if an STS occurs", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "hc-q9",
            prompt: "Administrative controls for noise most often include:",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "hc-q9-a", text: "Scheduling/rotation to reduce dose and limiting time in high-noise areas", isCorrect: true),
                QuizChoice(id: "hc-q9-b", text: "Assigning “experienced-only” personnel to noisy tasks without changing exposure", isCorrect: false),
                QuizChoice(id: "hc-q9-c", text: "Replacing audiograms with self-reports", isCorrect: false),
                QuizChoice(id: "hc-q9-d", text: "Only posting posters", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "hc-q10",
            prompt: "The most “expert-level” hearing conservation habit is to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "hc-q10-a", text: "Treat fit/attenuation as a performance item and verify it like any other control", isCorrect: true),
                QuizChoice(id: "hc-q10-b", text: "Assume NRR equals real-world protection", isCorrect: false),
                QuizChoice(id: "hc-q10-c", text: "Focus only on annual audiograms", isCorrect: false),
                QuizChoice(id: "hc-q10-d", text: "Use PPE only after a threshold shift occurs", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "hc-q11",
            prompt: "The action level for starting a hearing conservation program is typically lower than the permissible exposure limit because it:",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "hc-q11-a", text: "Triggers early monitoring/training to prevent degradation before limits are exceeded", isCorrect: true),
                QuizChoice(id: "hc-q11-b", text: "Eliminates the need for engineering controls", isCorrect: false),
                QuizChoice(id: "hc-q11-c", text: "Applies only to new workers", isCorrect: false),
                QuizChoice(id: "hc-q11-d", text: "Is optional if workers “feel fine”", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "hc-q12",
            prompt: "A common reason earmuffs underperform in the field is:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "hc-q12-a", text: "Poor seal from eyewear, hair, hard-hat interface, or damaged cushions", isCorrect: true),
                QuizChoice(id: "hc-q12-b", text: "They block too much sound and cause headaches", isCorrect: false),
                QuizChoice(id: "hc-q12-c", text: "They require annual calibration", isCorrect: false),
                QuizChoice(id: "hc-q12-d", text: "Foam plugs are always better than muffs", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "hc-q13",
            prompt: "When communicating hearing protection requirements, the most effective framing for experienced personnel is:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "hc-q13-a", text: "Dose management: time in noise + attenuation + fit, verified through observation and program checks", isCorrect: true),
                QuizChoice(id: "hc-q13-b", text: "“Wear them because the sign says so” only", isCorrect: false),
                QuizChoice(id: "hc-q13-c", text: "“NRR on the box means you’re safe in any noise”", isCorrect: false),
                QuizChoice(id: "hc-q13-d", text: "“Hearing loss is unavoidable in this job”", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "hc-q14",
            prompt: "If measured noise exposures increase due to process changes, the correct program response is to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "hc-q14-a", text: "Reassess risk, update controls/PPE, and ensure training and monitoring remain current", isCorrect: true),
                QuizChoice(id: "hc-q14-b", text: "Keep existing requirements because the program already exists", isCorrect: false),
                QuizChoice(id: "hc-q14-c", text: "Rely solely on annual audiograms to detect the problem later", isCorrect: false),
                QuizChoice(id: "hc-q14-d", text: "Stop measuring noise to avoid changing requirements", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "hc-q15",
            prompt: "When selecting hearing protection for a high-noise task with comms requirements, the best approach is to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "hc-q15-a", text: "Select PPE that meets attenuation needs while preserving critical communication, then verify fit and performance", isCorrect: true),
                QuizChoice(id: "hc-q15-b", text: "Pick the highest NRR product without regard to fit or task needs", isCorrect: false),
                QuizChoice(id: "hc-q15-c", text: "Allow any personal device as long as it is comfortable", isCorrect: false),
                QuizChoice(id: "hc-q15-d", text: "Skip hearing PPE if comms are more important", isCorrect: false)
            ]
        )
    ]

    // MARK: Mishap Reporting

    static let mishapReporting: [QuizQuestion] = [
        QuizQuestion(
            id: "mishap-q1",
            prompt: "Immediately after a serious mishap, the first priority sequence is:",
            difficulty: .easy,
            choices: [
                QuizChoice(id: "mishap-q1-a", text: "Life/limb, prevent further injury, secure scene, notify", isCorrect: true),
                QuizChoice(id: "mishap-q1-b", text: "Interview witnesses, estimate damage, notify", isCorrect: false),
                QuizChoice(id: "mishap-q1-c", text: "Release details to the public quickly", isCorrect: false),
                QuizChoice(id: "mishap-q1-d", text: "Move equipment to resume operations", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "mishap-q2",
            prompt: "The Safety Investigation Board (SIB) exists primarily to:",
            difficulty: .easy,
            choices: [
                QuizChoice(id: "mishap-q2-a", text: "Prevent future mishaps through root-cause learning", isCorrect: true),
                QuizChoice(id: "mishap-q2-b", text: "Assign blame and discipline", isCorrect: false),
                QuizChoice(id: "mishap-q2-c", text: "Handle public affairs releases", isCorrect: false),
                QuizChoice(id: "mishap-q2-d", text: "Determine legal liability", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "mishap-q3",
            prompt: "Why is preserving the mishap scene so critical (after emergency response needs)?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "mishap-q3-a", text: "Evidence is perishable; changes can destroy causal indicators", isCorrect: true),
                QuizChoice(id: "mishap-q3-b", text: "It’s mainly for convenience so investigators don’t have to interview witnesses", isCorrect: false),
                QuizChoice(id: "mishap-q3-c", text: "It prevents all future mishaps automatically", isCorrect: false),
                QuizChoice(id: "mishap-q3-d", text: "It replaces witness interviews", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "mishap-q4",
            prompt: "Privileged safety information is protected to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "mishap-q4-a", text: "Encourage full, candid disclosure to improve prevention", isCorrect: true),
                QuizChoice(id: "mishap-q4-b", text: "Hide mistakes from leadership", isCorrect: false),
                QuizChoice(id: "mishap-q4-c", text: "Ensure mishaps are not reported externally", isCorrect: false),
                QuizChoice(id: "mishap-q4-d", text: "Avoid documenting recommendations", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "mishap-q5",
            prompt: "Which is the best practice for managing witness information immediately after a mishap?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "mishap-q5-a", text: "Prevent cross-talk/contamination; capture independent statements", isCorrect: true),
                QuizChoice(id: "mishap-q5-b", text: "Have witnesses agree on a single story for consistency", isCorrect: false),
                QuizChoice(id: "mishap-q5-c", text: "Delay interviews until weeks later", isCorrect: false),
                QuizChoice(id: "mishap-q5-d", text: "Only interview supervisors", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "mishap-q6",
            prompt: "A fatality associated with operations is generally classified as:",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "mishap-q6-a", text: "A highest-severity mishap category", isCorrect: true),
                QuizChoice(id: "mishap-q6-b", text: "A minor mishap if equipment damage is low", isCorrect: false),
                QuizChoice(id: "mishap-q6-c", text: "Not a mishap if it occurred off duty", isCorrect: false),
                QuizChoice(id: "mishap-q6-d", text: "A near miss", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "mishap-q7",
            prompt: "Which action most often compromises an investigation’s ability to find root causes?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "mishap-q7-a", text: "Moving/cleaning the scene before documentation", isCorrect: true),
                QuizChoice(id: "mishap-q7-b", text: "Photographing the scene from multiple angles", isCorrect: false),
                QuizChoice(id: "mishap-q7-c", text: "Securing records and maintenance logs", isCorrect: false),
                QuizChoice(id: "mishap-q7-d", text: "Documenting weather and environment", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "mishap-q8",
            prompt: "The Accident Investigation Board (AIB) differs from safety investigation because it focuses on:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "mishap-q8-a", text: "Accountability and releasable findings", isCorrect: true),
                QuizChoice(id: "mishap-q8-b", text: "Only privileged prevention lessons", isCorrect: false),
                QuizChoice(id: "mishap-q8-c", text: "Only equipment repair cost", isCorrect: false),
                QuizChoice(id: "mishap-q8-d", text: "Only training records", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "mishap-q9",
            prompt: "A “near-miss” report is valuable because it:",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "mishap-q9-a", text: "Captures weak signals before they become injuries/damage", isCorrect: true),
                QuizChoice(id: "mishap-q9-b", text: "Is only used for award packages", isCorrect: false),
                QuizChoice(id: "mishap-q9-c", text: "Replaces formal hazard abatement", isCorrect: false),
                QuizChoice(id: "mishap-q9-d", text: "Eliminates need for inspections", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "mishap-q10",
            prompt: "A strong immediate control after a mishap hazard is identified is to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "mishap-q10-a", text: "Implement containment/stop-work and communicate risk before resuming", isCorrect: true),
                QuizChoice(id: "mishap-q10-b", text: "Resume work quickly to prove it was a one-off", isCorrect: false),
                QuizChoice(id: "mishap-q10-c", text: "Rely on PPE only and proceed", isCorrect: false),
                QuizChoice(id: "mishap-q10-d", text: "Wait for annual training updates", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "mishap-q11",
            prompt: "After immediate hazards are contained, the next best investigation-support action is to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "mishap-q11-a", text: "Document the scene (photos/notes), preserve evidence, and capture initial facts before memories drift", isCorrect: true),
                QuizChoice(id: "mishap-q11-b", text: "Allow normal cleanup to restore operations quickly", isCorrect: false),
                QuizChoice(id: "mishap-q11-c", text: "Have the most senior person write a narrative from memory later", isCorrect: false),
                QuizChoice(id: "mishap-q11-d", text: "Focus only on estimating cost of damage", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "mishap-q12",
            prompt: "A “near miss” should still trigger action because it indicates:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "mishap-q12-a", text: "A control gap or latent condition that could produce injury/damage under slightly different circumstances", isCorrect: true),
                QuizChoice(id: "mishap-q12-b", text: "The hazard is resolved because no one was hurt", isCorrect: false),
                QuizChoice(id: "mishap-q12-c", text: "Only an administrative issue with no safety relevance", isCorrect: false),
                QuizChoice(id: "mishap-q12-d", text: "A reason to delay reporting until trends become obvious", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "mishap-q13",
            prompt: "Which practice most improves the quality of initial mishap notifications (before full investigation)?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "mishap-q13-a", text: "Communicate clear facts (who/what/where/when), immediate controls taken, and current hazards", isCorrect: true),
                QuizChoice(id: "mishap-q13-b", text: "Speculate on root cause to move faster", isCorrect: false),
                QuizChoice(id: "mishap-q13-c", text: "Assign blame early to prevent confusion", isCorrect: false),
                QuizChoice(id: "mishap-q13-d", text: "Delay notification until all details are confirmed", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "mishap-q14",
            prompt: "Which statement best describes why safety investigation privilege exists?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "mishap-q14-a", text: "To encourage candid witness input so prevention lessons are accurate and actionable", isCorrect: true),
                QuizChoice(id: "mishap-q14-b", text: "To protect individuals from all consequences in any process", isCorrect: false),
                QuizChoice(id: "mishap-q14-c", text: "To avoid documenting hazards in writing", isCorrect: false),
                QuizChoice(id: "mishap-q14-d", text: "To restrict commanders from making decisions", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "mishap-q15",
            prompt: "A best-practice immediate mitigation after a vehicle/powered equipment mishap is to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "mishap-q15-a", text: "Pause similar operations if needed, brief hazards/controls, and verify equipment/process safety before resuming", isCorrect: true),
                QuizChoice(id: "mishap-q15-b", text: "Continue operations to prove confidence and avoid downtime", isCorrect: false),
                QuizChoice(id: "mishap-q15-c", text: "Wait for the final report before taking any action", isCorrect: false),
                QuizChoice(id: "mishap-q15-d", text: "Only remind workers to be careful", isCorrect: false)
            ]
        )
    ]

    // MARK: Investigation Basics

    static let investigationBasics: [QuizQuestion] = [
        QuizQuestion(
            id: "invest-q1",
            prompt: "“Human error” is identified. The best next analytic step is to:",
            difficulty: .easy,
            choices: [
                QuizChoice(id: "invest-q1-a", text: "Use a method (e.g., 5 Whys) to find system contributors and root causes", isCorrect: true),
                QuizChoice(id: "invest-q1-b", text: "Stop analysis because cause is known", isCorrect: false),
                QuizChoice(id: "invest-q1-c", text: "Assign blame to prevent recurrence", isCorrect: false),
                QuizChoice(id: "invest-q1-d", text: "Ignore training/tech data factors", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "invest-q2",
            prompt: "Why is perishable evidence prioritized early in scene documentation?",
            difficulty: .easy,
            choices: [
                QuizChoice(id: "invest-q2-a", text: "It can disappear due to weather, cleanup, evaporation, or traffic", isCorrect: true),
                QuizChoice(id: "invest-q2-b", text: "It is less important than witness statements", isCorrect: false),
                QuizChoice(id: "invest-q2-c", text: "It always proves intent", isCorrect: false),
                QuizChoice(id: "invest-q2-d", text: "It reduces the need for photos", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "invest-q3",
            prompt: "Chain of custody matters because it:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "invest-q3-a", text: "Maintains integrity/traceability of evidence from collection to storage", isCorrect: true),
                QuizChoice(id: "invest-q3-b", text: "Is only needed for medical records", isCorrect: false),
                QuizChoice(id: "invest-q3-c", text: "Allows evidence to be altered for clarity", isCorrect: false),
                QuizChoice(id: "invest-q3-d", text: "Replaces scene diagrams", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "invest-q4",
            prompt: "The best interview technique to reduce bias is to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "invest-q4-a", text: "Start with open-ended questions and avoid leading language", isCorrect: true),
                QuizChoice(id: "invest-q4-b", text: "Tell the witness what you think happened and ask them to agree", isCorrect: false),
                QuizChoice(id: "invest-q4-c", text: "Interview witnesses together to save time", isCorrect: false),
                QuizChoice(id: "invest-q4-d", text: "Only ask yes/no questions", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "invest-q5",
            prompt: "A causal factor differs from a contributing factor because it:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "invest-q5-a", text: "Directly led to the mishap sequence; removing it breaks the chain", isCorrect: true),
                QuizChoice(id: "invest-q5-b", text: "Is always a policy violation", isCorrect: false),
                QuizChoice(id: "invest-q5-c", text: "Is always an individual mistake", isCorrect: false),
                QuizChoice(id: "invest-q5-d", text: "Is always equipment failure", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "invest-q6",
            prompt: "A strong corrective action recommendation is:",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "invest-q6-a", text: "Specific, measurable, owned, and aligned to root cause and controls hierarchy", isCorrect: true),
                QuizChoice(id: "invest-q6-b", text: "“Be more careful”", isCorrect: false),
                QuizChoice(id: "invest-q6-c", text: "“Conduct more inspections” (no target or focus)", isCorrect: false),
                QuizChoice(id: "invest-q6-d", text: "“Discipline the worker” as the primary fix", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "invest-q7",
            prompt: "The most useful “timeline” product for investigations is one that:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "invest-q7-a", text: "Integrates actions, conditions, and barriers/controls over time", isCorrect: true),
                QuizChoice(id: "invest-q7-b", text: "Lists only the final event", isCorrect: false),
                QuizChoice(id: "invest-q7-c", text: "Includes only witness opinions", isCorrect: false),
                QuizChoice(id: "invest-q7-d", text: "Avoids environmental factors", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "invest-q8",
            prompt: "If evidence suggests procedure was followed but outcome still occurred, the next best question is:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "invest-q8-a", text: "Were the procedure and barriers adequate for the hazard (design vs compliance)?", isCorrect: true),
                QuizChoice(id: "invest-q8-b", text: "Who can be blamed for the outcome?", isCorrect: false),
                QuizChoice(id: "invest-q8-c", text: "Whether the worker’s job title aligned with the task", isCorrect: false),
                QuizChoice(id: "invest-q8-d", text: "Whether the incident can be closed as “unavoidable” without further analysis", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "invest-q9",
            prompt: "Which data source is most likely to reveal latent organizational contributors?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "invest-q9-a", text: "Training records, tech data, staffing/tempo indicators, and prior similar events", isCorrect: true),
                QuizChoice(id: "invest-q9-b", text: "Uniform inspection results", isCorrect: false),
                QuizChoice(id: "invest-q9-c", text: "Only the damaged part number", isCorrect: false),
                QuizChoice(id: "invest-q9-d", text: "Only the supervisor’s opinion", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "invest-q10",
            prompt: "The best way to prevent “hindsight bias” is to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "invest-q10-a", text: "Reconstruct what information/pressures existed at the time decisions were made", isCorrect: true),
                QuizChoice(id: "invest-q10-b", text: "Assume decisions were obviously wrong after the outcome", isCorrect: false),
                QuizChoice(id: "invest-q10-c", text: "Ignore context to stay objective", isCorrect: false),
                QuizChoice(id: "invest-q10-d", text: "Only use final-report summaries", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "invest-q11",
            prompt: "A strong investigation finding statement should include:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "invest-q11-a", text: "What happened, why it mattered (risk), evidence basis, and the barrier/control that failed or was missing", isCorrect: true),
                QuizChoice(id: "invest-q11-b", text: "Only the name of the person involved", isCorrect: false),
                QuizChoice(id: "invest-q11-c", text: "Only a conclusion without evidence", isCorrect: false),
                QuizChoice(id: "invest-q11-d", text: "Only a policy quote with no context", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "invest-q12",
            prompt: "Which recommendation is most likely to prevent recurrence of a hazard sequence?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "invest-q12-a", text: "A barrier-based control change that is engineered or enforced and measurable", isCorrect: true),
                QuizChoice(id: "invest-q12-b", text: "“Be more careful”", isCorrect: false),
                QuizChoice(id: "invest-q12-c", text: "“Remind everyone” with no owner/suspense", isCorrect: false),
                QuizChoice(id: "invest-q12-d", text: "“Discipline the worker” as the primary fix", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "invest-q13",
            prompt: "Evidence “triangulation” in investigations means:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "invest-q13-a", text: "Corroborating conclusions using multiple independent sources (physical, records, interviews)", isCorrect: true),
                QuizChoice(id: "invest-q13-b", text: "Asking the same witness the same question repeatedly", isCorrect: false),
                QuizChoice(id: "invest-q13-c", text: "Using only the most confident testimony", isCorrect: false),
                QuizChoice(id: "invest-q13-d", text: "Selecting evidence that supports an early theory", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "invest-q14",
            prompt: "A “proximate cause” differs from a “root cause” because proximate cause:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "invest-q14-a", text: "Is closest in time/sequence to the event, while root cause addresses deeper system contributors", isCorrect: true),
                QuizChoice(id: "invest-q14-b", text: "Is always a policy violation", isCorrect: false),
                QuizChoice(id: "invest-q14-c", text: "Is always equipment failure", isCorrect: false),
                QuizChoice(id: "invest-q14-d", text: "Is not supported by evidence", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "invest-q15",
            prompt: "The best way to validate that corrective actions worked is to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "invest-q15-a", text: "Verify barrier performance in the field and track leading indicators (compliance/exposure), not just absence of mishaps", isCorrect: true),
                QuizChoice(id: "invest-q15-b", text: "Assume success if no one complains", isCorrect: false),
                QuizChoice(id: "invest-q15-c", text: "Close the finding once training is emailed out", isCorrect: false),
                QuizChoice(id: "invest-q15-d", text: "Rely only on next year’s annual inspection", isCorrect: false)
            ]
        )
    ]

    // MARK: JHA Fundamentals

    static let jhaFundamentals: [QuizQuestion] = [
        QuizQuestion(
            id: "jha-q1",
            prompt: "The first step in building a JHA is to:",
            difficulty: .easy,
            choices: [
                QuizChoice(id: "jha-q1-a", text: "Break the job into basic sequential steps", isCorrect: true),
                QuizChoice(id: "jha-q1-b", text: "Assign PPE", isCorrect: false),
                QuizChoice(id: "jha-q1-c", text: "Choose a RAC number", isCorrect: false),
                QuizChoice(id: "jha-q1-d", text: "Write a generic safety warning", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "jha-q2",
            prompt: "A good JHA control statement should be:",
            difficulty: .easy,
            choices: [
                QuizChoice(id: "jha-q2-a", text: "Specific and actionable (what, who, when), not “be careful”", isCorrect: true),
                QuizChoice(id: "jha-q2-b", text: "Short and vague to fit on one line", isCorrect: false),
                QuizChoice(id: "jha-q2-c", text: "Only PPE-based", isCorrect: false),
                QuizChoice(id: "jha-q2-d", text: "Optional if the supervisor is experienced", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "jha-q3",
            prompt: "Step granularity in a JHA should be:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "jha-q3-a", text: "Detailed enough to identify hazards, but not so granular it becomes unusable", isCorrect: true),
                QuizChoice(id: "jha-q3-b", text: "One step for the entire job", isCorrect: false),
                QuizChoice(id: "jha-q3-c", text: "A separate step for every hand movement", isCorrect: false),
                QuizChoice(id: "jha-q3-d", text: "Only based on tool names", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "jha-q4",
            prompt: "The most valuable SME input when building a JHA comes from:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "jha-q4-a", text: "The workers who actually perform the job under real conditions", isCorrect: true),
                QuizChoice(id: "jha-q4-b", text: "Only the safety office", isCorrect: false),
                QuizChoice(id: "jha-q4-c", text: "Only leadership staff", isCorrect: false),
                QuizChoice(id: "jha-q4-d", text: "Only a vendor representative", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "jha-q5",
            prompt: "When should a JHA be reviewed/updated?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "jha-q5-a", text: "When the process/tools/environment changes or when performance indicates a gap", isCorrect: true),
                QuizChoice(id: "jha-q5-b", text: "Only after an injury", isCorrect: false),
                QuizChoice(id: "jha-q5-c", text: "Only when a new supervisor arrives", isCorrect: false),
                QuizChoice(id: "jha-q5-d", text: "Never; it’s a one-time document", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "jha-q6",
            prompt: "The correct way to handle residual risk in a JHA is to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "jha-q6-a", text: "Assess after controls and ensure acceptance/briefing aligns with authority", isCorrect: true),
                QuizChoice(id: "jha-q6-b", text: "Ignore it if PPE is worn", isCorrect: false),
                QuizChoice(id: "jha-q6-c", text: "Assume it is zero if the JHA exists", isCorrect: false),
                QuizChoice(id: "jha-q6-d", text: "Only discuss it after the task is complete", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "jha-q7",
            prompt: "A common JHA failure mode is controls that are:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "jha-q7-a", text: "Not observable/verifiable during supervision", isCorrect: true),
                QuizChoice(id: "jha-q7-b", text: "Engineering-based", isCorrect: false),
                QuizChoice(id: "jha-q7-c", text: "Aligned with hazards", isCorrect: false),
                QuizChoice(id: "jha-q7-d", text: "Owned by an OPR", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "jha-q8",
            prompt: "Which is the strongest reason to build step-by-step hazard controls versus general rules?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "jha-q8-a", text: "Hazards change by step; controls must match exposure points", isCorrect: true),
                QuizChoice(id: "jha-q8-b", text: "It makes the document longer", isCorrect: false),
                QuizChoice(id: "jha-q8-c", text: "It makes it easier to file paperwork, regardless of job performance", isCorrect: false),
                QuizChoice(id: "jha-q8-d", text: "It allows skipping PPE selection", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "jha-q9",
            prompt: "A JHA is most effective when it is used as:",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "jha-q9-a", text: "A planning + briefing tool that matches real work, not a binder artifact", isCorrect: true),
                QuizChoice(id: "jha-q9-b", text: "A document created only for inspections", isCorrect: false),
                QuizChoice(id: "jha-q9-c", text: "A substitute for supervision", isCorrect: false),
                QuizChoice(id: "jha-q9-d", text: "A replacement for hazard reporting", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "jha-q10",
            prompt: "The best way to validate JHA controls is to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "jha-q10-a", text: "Observe the job and verify barriers/controls are actually used and effective", isCorrect: true),
                QuizChoice(id: "jha-q10-b", text: "Assume controls work if written clearly", isCorrect: false),
                QuizChoice(id: "jha-q10-c", text: "Only review paperwork", isCorrect: false),
                QuizChoice(id: "jha-q10-d", text: "Wait for a mishap to test the controls", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "jha-q11",
            prompt: "A high-quality JHA control is strongest when it is:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "jha-q11-a", text: "Observable/verifiable (a barrier or action a supervisor can confirm), with an owner and trigger point", isCorrect: true),
                QuizChoice(id: "jha-q11-b", text: "A reminder like “pay attention”", isCorrect: false),
                QuizChoice(id: "jha-q11-c", text: "Only a PPE list with no task context", isCorrect: false),
                QuizChoice(id: "jha-q11-d", text: "A generic statement that applies to all jobs equally", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "jha-q12",
            prompt: "When multiple trades work in the same area, the most common JHA miss is failing to address:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "jha-q12-a", text: "Interface hazards (simultaneous operations, energy interactions, shared access/egress)", isCorrect: true),
                QuizChoice(id: "jha-q12-b", text: "Font size on the document", isCorrect: false),
                QuizChoice(id: "jha-q12-c", text: "Whether the job is interesting", isCorrect: false),
                QuizChoice(id: "jha-q12-d", text: "Only which tool brand is used", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "jha-q13",
            prompt: "For dynamic work where conditions change, the best way to keep the JHA effective is to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "jha-q13-a", text: "Re-brief and update hazards/controls as conditions change (treat it as a living control)", isCorrect: true),
                QuizChoice(id: "jha-q13-b", text: "Lock the JHA after the first signature so it can’t change", isCorrect: false),
                QuizChoice(id: "jha-q13-c", text: "Skip the JHA and rely on experience", isCorrect: false),
                QuizChoice(id: "jha-q13-d", text: "Only update after a mishap", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "jha-q14",
            prompt: "If a job requires permits (e.g., LOTO, confined space, hot work), the JHA should:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "jha-q14-a", text: "Integrate permit triggers/steps and ensure controls are not duplicated or contradictory", isCorrect: true),
                QuizChoice(id: "jha-q14-b", text: "Ignore permits because they are separate paperwork", isCorrect: false),
                QuizChoice(id: "jha-q14-c", text: "Replace the permit entirely", isCorrect: false),
                QuizChoice(id: "jha-q14-d", text: "List “get permit” with no details or triggers", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "jha-q15",
            prompt: "The most professional way to express risk in a JHA is to:",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "jha-q15-a", text: "Describe hazards, controls, and residual risk in terms of exposure and credible severity/probability", isCorrect: true),
                QuizChoice(id: "jha-q15-b", text: "Use only subjective labels like “safe/unsafe” with no criteria", isCorrect: false),
                QuizChoice(id: "jha-q15-c", text: "Avoid mentioning risk to reduce anxiety", isCorrect: false),
                QuizChoice(id: "jha-q15-d", text: "Assume risk is zero when PPE is listed", isCorrect: false)
            ]
        )
    ]

    // MARK: Safety Briefing

    static let safetyBriefing: [QuizQuestion] = [
        QuizQuestion(
            id: "brief-q1",
            prompt: "A high-quality pre-task safety brief should always include:",
            difficulty: .easy,
            choices: [
                QuizChoice(id: "brief-q1-a", text: "Task hazards, controls, roles, emergency actions, and stop-work triggers", isCorrect: true),
                QuizChoice(id: "brief-q1-b", text: "Only a generic slogan", isCorrect: false),
                QuizChoice(id: "brief-q1-c", text: "Only PPE requirements", isCorrect: false),
                QuizChoice(id: "brief-q1-d", text: "Only last week’s mishap stats", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "brief-q2",
            prompt: "Why should a briefing be tailored to the day’s tasks instead of reused verbatim?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "brief-q2-a", text: "Hazards and controls change; relevance drives attention and compliance", isCorrect: true),
                QuizChoice(id: "brief-q2-b", text: "Tailoring is required only for new workers", isCorrect: false),
                QuizChoice(id: "brief-q2-c", text: "Reuse is always better because it’s consistent", isCorrect: false),
                QuizChoice(id: "brief-q2-d", text: "Briefings are only for documentation", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "brief-q3",
            prompt: "The most effective method to confirm understanding during a brief is to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "brief-q3-a", text: "Use two-way questions/reads-back (not just a signature)", isCorrect: true),
                QuizChoice(id: "brief-q3-b", text: "Assume understanding if no one asks questions", isCorrect: false),
                QuizChoice(id: "brief-q3-c", text: "Keep it one-way to save time", isCorrect: false),
                QuizChoice(id: "brief-q3-d", text: "Only brief supervisors", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "brief-q4",
            prompt: "Documentation of a brief primarily supports:",
            difficulty: .easy,
            choices: [
                QuizChoice(id: "brief-q4-a", text: "Accountability and proof the communication occurred", isCorrect: true),
                QuizChoice(id: "brief-q4-b", text: "Replacing the need for training", isCorrect: false),
                QuizChoice(id: "brief-q4-c", text: "Eliminating hazards", isCorrect: false),
                QuizChoice(id: "brief-q4-d", text: "Removing the need for supervision", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "brief-q5",
            prompt: "A visitor/contractor entering a hazard area should receive:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "brief-q5-a", text: "A hazard/PPE brief relevant to their exposure before entry", isCorrect: true),
                QuizChoice(id: "brief-q5-b", text: "No brief because they’re not employees", isCorrect: false),
                QuizChoice(id: "brief-q5-c", text: "Only a waiver form", isCorrect: false),
                QuizChoice(id: "brief-q5-d", text: "Only a map of the facility", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "brief-q6",
            prompt: "A strong brief includes “what will change/stop the job today” because it:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "brief-q6-a", text: "Defines triggers for reassessment and prevents normalization of risk", isCorrect: true),
                QuizChoice(id: "brief-q6-b", text: "Makes the brief longer for no benefit", isCorrect: false),
                QuizChoice(id: "brief-q6-c", text: "Reduces the need for PPE", isCorrect: false),
                QuizChoice(id: "brief-q6-d", text: "Is only needed for maintenance tasks", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "brief-q7",
            prompt: "Which is the best indicator a brief is effective rather than “checkbox”?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "brief-q7-a", text: "Workers can articulate hazards/controls and demonstrate them in the field", isCorrect: true),
                QuizChoice(id: "brief-q7-b", text: "Everyone signed the sheet", isCorrect: false),
                QuizChoice(id: "brief-q7-c", text: "It was exactly 10 minutes long", isCorrect: false),
                QuizChoice(id: "brief-q7-d", text: "No one asked questions", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "brief-q8",
            prompt: "If the planned control cannot be implemented (resource missing), the correct action is to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "brief-q8-a", text: "Pause and re-assess risk; update controls or elevate decision", isCorrect: true),
                QuizChoice(id: "brief-q8-b", text: "Proceed and document it later", isCorrect: false),
                QuizChoice(id: "brief-q8-c", text: "Replace the control with a sign", isCorrect: false),
                QuizChoice(id: "brief-q8-d", text: "Ignore the missing control if everyone is experienced", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "brief-q9",
            prompt: "A best practice for brief content sourcing is to include:",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "brief-q9-a", text: "Recent trends/near-misses and what changed since last shift or last job", isCorrect: true),
                QuizChoice(id: "brief-q9-b", text: "Only generic posters", isCorrect: false),
                QuizChoice(id: "brief-q9-c", text: "Only weather information", isCorrect: false),
                QuizChoice(id: "brief-q9-d", text: "Only the regulation title", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "brief-q10",
            prompt: "The most “expert-level” brief habit is to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "brief-q10-a", text: "Link hazards to specific controls and then actively supervise those controls", isCorrect: true),
                QuizChoice(id: "brief-q10-b", text: "Focus on speed so the brief doesn’t delay work", isCorrect: false),
                QuizChoice(id: "brief-q10-c", text: "Avoid discussing risk to prevent concern", isCorrect: false),
                QuizChoice(id: "brief-q10-d", text: "Treat the brief as proof of compliance only", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "brief-q11",
            prompt: "A briefing should be re-accomplished (or updated) when:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "brief-q11-a", text: "Hazards, controls, conditions, or personnel change in a way that affects exposure", isCorrect: true),
                QuizChoice(id: "brief-q11-b", text: "The previous brief was under 5 minutes", isCorrect: false),
                QuizChoice(id: "brief-q11-c", text: "The supervisor prefers not to repeat information", isCorrect: false),
                QuizChoice(id: "brief-q11-d", text: "Only if a mishap occurs", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "brief-q12",
            prompt: "For experienced crews, the best method to keep briefs from becoming “scripted noise” is to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "brief-q12-a", text: "Brief the deltas: what’s different today, known weak controls, and specific stop-work triggers", isCorrect: true),
                QuizChoice(id: "brief-q12-b", text: "Read the same brief verbatim every day for consistency", isCorrect: false),
                QuizChoice(id: "brief-q12-c", text: "Skip briefs; experience replaces communication", isCorrect: false),
                QuizChoice(id: "brief-q12-d", text: "Only brief the newest person and assume others know it", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "brief-q13",
            prompt: "Which is the best “stop work” trigger statement?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "brief-q13-a", text: "If the required barrier/control is missing or conditions change beyond the plan, stop and reassess", isCorrect: true),
                QuizChoice(id: "brief-q13-b", text: "Stop only if a supervisor is watching", isCorrect: false),
                QuizChoice(id: "brief-q13-c", text: "Stop only if someone feels uncomfortable but can’t articulate why", isCorrect: false),
                QuizChoice(id: "brief-q13-d", text: "Stop only after an injury occurs", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "brief-q14",
            prompt: "A brief for simultaneous operations (SIMOPS) should emphasize:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "brief-q14-a", text: "Interface hazards, shared boundaries, comms plan, and who controls changes/stop-work decisions", isCorrect: true),
                QuizChoice(id: "brief-q14-b", text: "Only PPE requirements", isCorrect: false),
                QuizChoice(id: "brief-q14-c", text: "Only the fastest way to finish", isCorrect: false),
                QuizChoice(id: "brief-q14-d", text: "Only the regulation number", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "brief-q15",
            prompt: "Documentation is useful, but the strongest indicator of briefing effectiveness is:",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "brief-q15-a", text: "Observed control performance in execution (barriers in place and used correctly)", isCorrect: true),
                QuizChoice(id: "brief-q15-b", text: "A perfectly completed sign-in sheet", isCorrect: false),
                QuizChoice(id: "brief-q15-c", text: "A long briefing duration", isCorrect: false),
                QuizChoice(id: "brief-q15-d", text: "A brief with no questions asked", isCorrect: false)
            ]
        )
    ]

    // MARK: PPE Decision

    static let ppeDecision: [QuizQuestion] = [
        QuizQuestion(
            id: "ppe-q1",
            prompt: "PPE is most appropriately selected after:",
            difficulty: .easy,
            choices: [
                QuizChoice(id: "ppe-q1-a", text: "Hazards are assessed and higher-order controls are applied when feasible", isCorrect: true),
                QuizChoice(id: "ppe-q1-b", text: "Cost comparisons only", isCorrect: false),
                QuizChoice(id: "ppe-q1-c", text: "The worker requests it", isCorrect: false),
                QuizChoice(id: "ppe-q1-d", text: "A mishap occurs", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "ppe-q2",
            prompt: "For chemical splash hazards, eye/face protection selection should emphasize:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "ppe-q2-a", text: "Sealed/appropriate protection (e.g., goggles/face shield) matched to exposure", isCorrect: true),
                QuizChoice(id: "ppe-q2-b", text: "Regular prescription glasses", isCorrect: false),
                QuizChoice(id: "ppe-q2-c", text: "Sunglasses", isCorrect: false),
                QuizChoice(id: "ppe-q2-d", text: "No protection if the chemical is diluted", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "ppe-q3",
            prompt: "If an employee wears prescription glasses in an impact hazard area, a compliant solution is:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "ppe-q3-a", text: "Over-the-glasses goggles or prescription-rated safety eyewear with side protection", isCorrect: true),
                QuizChoice(id: "ppe-q3-b", text: "Street glasses only", isCorrect: false),
                QuizChoice(id: "ppe-q3-c", text: "Remove glasses and work without vision correction", isCorrect: false),
                QuizChoice(id: "ppe-q3-d", text: "Any eyewear if it has clear lenses", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "ppe-q4",
            prompt: "If an employee provides their own PPE, the employer is still responsible to:",
            difficulty: .easy,
            choices: [
                QuizChoice(id: "ppe-q4-a", text: "Ensure PPE adequacy, maintenance, sanitation, and training", isCorrect: true),
                QuizChoice(id: "ppe-q4-b", text: "Ignore it because it’s employee-owned", isCorrect: false),
                QuizChoice(id: "ppe-q4-c", text: "Only document it if an injury occurs", isCorrect: false),
                QuizChoice(id: "ppe-q4-d", text: "Allow any PPE if it looks similar", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "ppe-q5",
            prompt: "PPE is most likely to fail when:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "ppe-q5-a", text: "Fit/compatibility/training are weak and supervision doesn’t verify use", isCorrect: true),
                QuizChoice(id: "ppe-q5-b", text: "It is issued in multiple sizes", isCorrect: false),
                QuizChoice(id: "ppe-q5-c", text: "It is inspected before use", isCorrect: false),
                QuizChoice(id: "ppe-q5-d", text: "It is selected based on hazard assessment", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "ppe-q6",
            prompt: "When choosing gloves for a chemical task, the strongest selection method is to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "ppe-q6-a", text: "Match glove material to the chemical and exposure time (per compatibility guidance)", isCorrect: true),
                QuizChoice(id: "ppe-q6-b", text: "Choose the thickest glove available for everything", isCorrect: false),
                QuizChoice(id: "ppe-q6-c", text: "Use cloth gloves because they are comfortable", isCorrect: false),
                QuizChoice(id: "ppe-q6-d", text: "Skip gloves if hands are washed after", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "ppe-q7",
            prompt: "A face shield is used for grinding. Which statement is most correct?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "ppe-q7-a", text: "A face shield typically supplements, not replaces, primary eye protection", isCorrect: true),
                QuizChoice(id: "ppe-q7-b", text: "A face shield alone is always sufficient", isCorrect: false),
                QuizChoice(id: "ppe-q7-c", text: "Eye protection is optional if the shield is tinted", isCorrect: false),
                QuizChoice(id: "ppe-q7-d", text: "Face shields are only for chemical hazards", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "ppe-q8",
            prompt: "PPE compatibility matters most when:",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "ppe-q8-a", text: "Multiple PPE items overlap (hard hat + muffs + eye/face + respirator)", isCorrect: true),
                QuizChoice(id: "ppe-q8-b", text: "Only one item is worn", isCorrect: false),
                QuizChoice(id: "ppe-q8-c", text: "PPE is stored in a locker", isCorrect: false),
                QuizChoice(id: "ppe-q8-d", text: "The PPE color matches the uniform", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "ppe-q9",
            prompt: "The correct time to replace PPE is:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "ppe-q9-a", text: "When damaged, degraded, contaminated, or no longer provides intended protection", isCorrect: true),
                QuizChoice(id: "ppe-q9-b", text: "Only when it looks old", isCorrect: false),
                QuizChoice(id: "ppe-q9-c", text: "Only after a mishap", isCorrect: false),
                QuizChoice(id: "ppe-q9-d", text: "Never; PPE lasts indefinitely", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "ppe-q10",
            prompt: "The most valuable inspection question for PPE is:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "ppe-q10-a", text: "Is it selected for the hazard AND actually worn correctly at the point of exposure?", isCorrect: true),
                QuizChoice(id: "ppe-q10-b", text: "Is PPE available somewhere in the building?", isCorrect: false),
                QuizChoice(id: "ppe-q10-c", text: "Is PPE the same brand across the shop?", isCorrect: false),
                QuizChoice(id: "ppe-q10-d", text: "Is PPE color consistent?", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "ppe-q11",
            prompt: "The requirement to perform and certify a workplace PPE hazard assessment is primarily to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "ppe-q11-a", text: "Ensure PPE selection is hazard-driven, documented, and accountable (not arbitrary)", isCorrect: true),
                QuizChoice(id: "ppe-q11-b", text: "Standardize PPE brands across all shops", isCorrect: false),
                QuizChoice(id: "ppe-q11-c", text: "Replace the need for engineering controls", isCorrect: false),
                QuizChoice(id: "ppe-q11-d", text: "Reduce the number of inspections required", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "ppe-q12",
            prompt: "Respirators are issued for a dust-producing process. Which requirement is most commonly missed in the field?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "ppe-q12-a", text: "Program controls like medical evaluation, fit testing (for tight-fitting), and training before use", isCorrect: true),
                QuizChoice(id: "ppe-q12-b", text: "Having the respirator stored in its original box", isCorrect: false),
                QuizChoice(id: "ppe-q12-c", text: "Using a larger size for comfort", isCorrect: false),
                QuizChoice(id: "ppe-q12-d", text: "Wearing the respirator only during inspections", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "ppe-q13",
            prompt: "If PPE is the only control proposed for a high-severity hazard, the most professional inspector response is to:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "ppe-q13-a", text: "Challenge the control strategy—seek elimination/engineering/admin controls or elevate residual risk appropriately", isCorrect: true),
                QuizChoice(id: "ppe-q13-b", text: "Approve immediately; PPE always solves the hazard", isCorrect: false),
                QuizChoice(id: "ppe-q13-c", text: "Close the hazard once PPE is issued", isCorrect: false),
                QuizChoice(id: "ppe-q13-d", text: "Ignore because PPE selection is a supply issue, not safety", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "ppe-q14",
            prompt: "When selecting cut-resistant gloves, the best balancing factor beyond cut rating is:",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "ppe-q14-a", text: "Dexterity/grip for the task (so the glove doesn’t create new risk), verified in use", isCorrect: true),
                QuizChoice(id: "ppe-q14-b", text: "Choosing the stiffest glove to “force” safe behavior", isCorrect: false),
                QuizChoice(id: "ppe-q14-c", text: "Selecting based on color so supervisors can see them", isCorrect: false),
                QuizChoice(id: "ppe-q14-d", text: "Selecting based on the lowest price", isCorrect: false)
            ]
        ),
        QuizQuestion(
            id: "ppe-q15",
            prompt: "PPE program effectiveness is best measured by:",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "ppe-q15-a", text: "Field verification (fit, correct wear at exposure point) plus exposure reduction, not issuance counts", isCorrect: true),
                QuizChoice(id: "ppe-q15-b", text: "How many boxes were issued this quarter", isCorrect: false),
                QuizChoice(id: "ppe-q15-c", text: "Whether PPE is stored neatly", isCorrect: false),
                QuizChoice(id: "ppe-q15-d", text: "Whether PPE is the same brand across the base", isCorrect: false)
            ]
        )
    ]
}
