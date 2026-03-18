import Foundation

struct CodeLookupQuestion: Identifiable {
    let id: String
    let violationDescription: String
    let category: String
    let correctCitation: String
    let correctTitle: String
    let distractors: [String]       // 3 wrong citations
    let explanation: String
}

enum CodeLookupDifficulty: String, CaseIterable {
    case quick = "Quick"
    case standard = "Standard"
    case expert = "Expert"

    var questionCount: Int {
        switch self {
        case .quick: return 10
        case .standard: return 20
        case .expert: return 30
        }
    }

    var timePerQuestion: TimeInterval {
        switch self {
        case .quick: return 15
        case .standard: return 12
        case .expert: return 8
        }
    }
}

enum CodeLookupContent {
    static let questions: [CodeLookupQuestion] = [
        // MARK: - Electrical (6 questions)
        CodeLookupQuestion(
            id: "cl-elec-01",
            violationDescription: "Electrical panel door left open with exposed live parts accessible to unqualified workers.",
            category: "Electrical",
            correctCitation: "29 CFR 1910.303(b)(2)",
            correctTitle: "Guarding of Live Parts",
            distractors: [
                "29 CFR 1910.305(b)(1)",
                "29 CFR 1910.147(c)(4)",
                "29 CFR 1926.405(b)(1)"
            ],
            explanation: "1910.303(b)(2) requires live parts of electrical equipment operating at 50 volts or more to be guarded against accidental contact by enclosures or other effective means."
        ),
        CodeLookupQuestion(
            id: "cl-elec-02",
            violationDescription: "Only 24 inches of clearance in front of an energized 480V electrical panel. Storage boxes encroaching into the required workspace.",
            category: "Electrical",
            correctCitation: "29 CFR 1910.303(g)(1)",
            correctTitle: "Working Space About Electrical Equipment",
            distractors: [
                "29 CFR 1910.303(b)(1)",
                "29 CFR 1910.305(g)(1)",
                "29 CFR 1910.304(f)(1)"
            ],
            explanation: "1910.303(g)(1) requires a minimum of 36 inches of clear working space in front of electrical panels to permit safe operation and maintenance."
        ),
        CodeLookupQuestion(
            id: "cl-elec-03",
            violationDescription: "Temporary wiring on a construction site using extension cords without ground-fault circuit interrupter protection.",
            category: "Electrical",
            correctCitation: "29 CFR 1926.405(a)(2)(ii)",
            correctTitle: "GFCI Protection for Construction",
            distractors: [
                "29 CFR 1910.304(b)(3)(ii)",
                "29 CFR 1926.404(b)(1)(ii)",
                "29 CFR 1910.305(a)(2)(iii)"
            ],
            explanation: "1926.405(a)(2)(ii) requires GFCI protection for all 120-volt, single-phase, 15- and 20-ampere receptacle outlets on construction sites that are not part of the permanent wiring."
        ),
        CodeLookupQuestion(
            id: "cl-elec-04",
            violationDescription: "Switchgear in a manufacturing facility not labeled with arc flash boundary information or required PPE level.",
            category: "Electrical",
            correctCitation: "NFPA 70E 130.5(H)",
            correctTitle: "Arc Flash Warning Labels",
            distractors: [
                "NFPA 70E 120.5(1)",
                "NFPA 70E 130.7(A)",
                "NFPA 70E 110.1(H)"
            ],
            explanation: "NFPA 70E 130.5(H) requires equipment likely to require examination while energized to be field-marked with an arc flash label indicating the arc flash boundary and required PPE."
        ),
        CodeLookupQuestion(
            id: "cl-elec-05",
            violationDescription: "Flexible cord used as a substitute for fixed wiring, run through a hole in a wall to power equipment in the next room.",
            category: "Electrical",
            correctCitation: "29 CFR 1910.305(g)(1)(iii)",
            correctTitle: "Flexible Cord Misuse",
            distractors: [
                "29 CFR 1910.303(b)(2)(iv)",
                "29 CFR 1926.405(a)(1)(ii)",
                "29 CFR 1910.304(b)(3)(i)"
            ],
            explanation: "1910.305(g)(1)(iii) prohibits flexible cords from being used as a substitute for fixed wiring, run through holes in walls/ceilings, or concealed behind building elements."
        ),
        CodeLookupQuestion(
            id: "cl-elec-06",
            violationDescription: "Energized electrical work being performed without establishing an electrically safe work condition, and no energized work permit on file.",
            category: "Electrical",
            correctCitation: "NFPA 70E 110.3",
            correctTitle: "Electrically Safe Work Conditions",
            distractors: [
                "NFPA 70E 130.2(A)",
                "NFPA 70E 120.1",
                "NFPA 70E 110.1(A)"
            ],
            explanation: "NFPA 70E 110.3 establishes that all electrical conductors and circuit parts shall be put into an electrically safe work condition before work is performed, unless energized work is justified and an energized work permit is completed."
        ),

        // MARK: - Fall Protection (6 questions)
        CodeLookupQuestion(
            id: "cl-fall-01",
            violationDescription: "Workers on a residential rooftop at 22 feet with no guardrails, safety nets, or personal fall arrest systems in use.",
            category: "Fall Protection",
            correctCitation: "29 CFR 1926.501(b)(13)",
            correctTitle: "Residential Construction Fall Protection",
            distractors: [
                "29 CFR 1926.502(b)(15)",
                "29 CFR 1926.501(b)(10)",
                "29 CFR 1910.28(b)(11)"
            ],
            explanation: "1926.501(b)(13) covers residential construction specifically — each employee engaged in residential construction activities 6 feet or more above lower levels shall be protected by conventional fall protection or an alternative plan."
        ),
        CodeLookupQuestion(
            id: "cl-fall-02",
            violationDescription: "Floor hole in a warehouse mezzanine left uncovered with no guardrail system around the opening.",
            category: "Fall Protection",
            correctCitation: "29 CFR 1910.28(b)(3)",
            correctTitle: "Protection from Floor Holes",
            distractors: [
                "29 CFR 1926.502(i)(1)",
                "29 CFR 1910.22(a)(1)",
                "29 CFR 1926.501(b)(4)"
            ],
            explanation: "1910.28(b)(3) requires that each employee on a walking-working surface near a hole must be protected from falling through the hole by a cover or guardrail system."
        ),
        CodeLookupQuestion(
            id: "cl-fall-03",
            violationDescription: "Portable extension ladder set up at a 30-degree angle with no upper tie-off and the top resting against a gutter.",
            category: "Fall Protection",
            correctCitation: "29 CFR 1926.1053(b)(1)",
            correctTitle: "Ladder Safety Requirements",
            distractors: [
                "29 CFR 1926.1053(a)(4)",
                "29 CFR 1926.1060(a)(1)",
                "29 CFR 1926.1053(b)(6)"
            ],
            explanation: "1926.1053(b)(1) requires non-self-supporting ladders to be placed at an angle where the horizontal distance from the top support is approximately one-quarter the working length (75.5 degree angle). Must also be secured against displacement."
        ),
        CodeLookupQuestion(
            id: "cl-fall-04",
            violationDescription: "Guardrail on a scaffold platform with a top rail height of only 36 inches above the platform surface.",
            category: "Fall Protection",
            correctCitation: "29 CFR 1926.451(g)(4)(i)",
            correctTitle: "Scaffold Guardrail Height",
            distractors: [
                "29 CFR 1926.502(b)(3)(ii)",
                "29 CFR 1910.29(b)(1)(i)",
                "29 CFR 1926.451(e)(2)(i)"
            ],
            explanation: "1926.451(g)(4)(i) requires the height of scaffold toprails to be between 38 inches and 45 inches above the platform surface. 36 inches is below the minimum."
        ),
        CodeLookupQuestion(
            id: "cl-fall-05",
            violationDescription: "Construction worker's personal fall arrest system anchor point is connected to a horizontal lifeline at knee height.",
            category: "Fall Protection",
            correctCitation: "29 CFR 1926.502(d)(15)",
            correctTitle: "Anchorage Requirements",
            distractors: [
                "29 CFR 1926.502(d)(16)",
                "29 CFR 1926.501(b)(11)",
                "29 CFR 1926.502(d)(21)"
            ],
            explanation: "1926.502(d)(15) requires anchorages used for personal fall arrest to be capable of supporting at least 5,000 lbs per employee and to be independent. Anchorages should be at or above the D-ring level to limit free fall distance."
        ),
        CodeLookupQuestion(
            id: "cl-fall-06",
            violationDescription: "Worker standing on the top cap of a 6-foot stepladder to reach overhead ductwork.",
            category: "Fall Protection",
            correctCitation: "29 CFR 1926.1053(b)(13)",
            correctTitle: "Top of Stepladder Use",
            distractors: [
                "29 CFR 1926.1053(b)(5)",
                "29 CFR 1926.1053(a)(11)",
                "29 CFR 1926.1060(a)(1)"
            ],
            explanation: "1926.1053(b)(13) prohibits the use of the top step or top cap of a stepladder as a step. Workers must not stand on the top two rungs/steps of a portable ladder."
        ),

        // MARK: - Machine Guarding (4 questions)
        CodeLookupQuestion(
            id: "cl-mach-01",
            violationDescription: "Bench grinder operating with the tongue guard adjusted 3/4 inch from the grinding wheel instead of the maximum 1/4 inch.",
            category: "Machine Guarding",
            correctCitation: "29 CFR 1910.215(a)(4)",
            correctTitle: "Abrasive Wheel Tongue Guards",
            distractors: [
                "29 CFR 1910.212(a)(1)",
                "29 CFR 1910.215(b)(9)",
                "29 CFR 1910.219(d)(1)"
            ],
            explanation: "1910.215(a)(4) requires tongue guards on bench grinders to be adjusted to within 1/4 inch of the wheel. Excessive clearance allows material or fingers to be drawn between the guard and wheel."
        ),
        CodeLookupQuestion(
            id: "cl-mach-02",
            violationDescription: "Mechanical power press with the point-of-operation guard removed so the operator can feed stock faster.",
            category: "Machine Guarding",
            correctCitation: "29 CFR 1910.217(c)(2)",
            correctTitle: "Point of Operation Guarding — Power Presses",
            distractors: [
                "29 CFR 1910.212(a)(1)",
                "29 CFR 1910.212(a)(3)(ii)",
                "29 CFR 1910.219(c)(2)"
            ],
            explanation: "1910.217(c)(2) requires every point of operation on a mechanical power press to be guarded. Removing guards to increase production speed is a serious violation exposing workers to amputation hazards."
        ),
        CodeLookupQuestion(
            id: "cl-mach-03",
            violationDescription: "Rotating shaft with exposed set screws and keyways that could catch clothing. No guard or enclosure installed.",
            category: "Machine Guarding",
            correctCitation: "29 CFR 1910.219(c)(2)",
            correctTitle: "Projecting Shaft Ends and Keyways",
            distractors: [
                "29 CFR 1910.212(a)(1)",
                "29 CFR 1910.215(a)(2)",
                "29 CFR 1910.217(c)(1)"
            ],
            explanation: "1910.219(c)(2) requires that projecting shaft ends, set screws, and keys on revolving parts be guarded by enclosures to prevent clothing or body contact."
        ),
        CodeLookupQuestion(
            id: "cl-mach-04",
            violationDescription: "One or more machines in a woodworking shop lack point-of-operation guards, exposing workers to the cutting action of blades.",
            category: "Machine Guarding",
            correctCitation: "29 CFR 1910.212(a)(1)",
            correctTitle: "General Machine Guarding",
            distractors: [
                "29 CFR 1910.213(a)(1)",
                "29 CFR 1910.217(c)(2)",
                "29 CFR 1910.219(a)(1)"
            ],
            explanation: "1910.212(a)(1) is the general machine guarding standard: one or more methods of guarding shall protect the operator and other employees from hazards such as point of operation, nip points, rotating parts, and flying particles."
        ),

        // MARK: - LOTO (4 questions)
        CodeLookupQuestion(
            id: "cl-loto-01",
            violationDescription: "Lockout device applied to a machine disconnect but no tag attached identifying the authorized employee or reason for lockout.",
            category: "LOTO",
            correctCitation: "29 CFR 1910.147(c)(5)(ii)",
            correctTitle: "Tagout Device Requirements",
            distractors: [
                "29 CFR 1910.147(c)(4)(i)",
                "29 CFR 1910.147(d)(2)(i)",
                "29 CFR 1910.147(f)(1)(i)"
            ],
            explanation: "1910.147(c)(5)(ii) requires tagout devices to indicate the identity of the employee applying the device and to warn against hazardous conditions if the machine is energized."
        ),
        CodeLookupQuestion(
            id: "cl-loto-02",
            violationDescription: "Multiple maintenance workers servicing a machine with no documented group lockout procedure. Each worker applied their own lock without coordination.",
            category: "LOTO",
            correctCitation: "29 CFR 1910.147(f)(3)",
            correctTitle: "Group Lockout/Tagout",
            distractors: [
                "29 CFR 1910.147(c)(4)",
                "29 CFR 1910.147(d)(5)",
                "29 CFR 1910.147(c)(7)"
            ],
            explanation: "1910.147(f)(3) requires that when servicing involves more than one authorized employee, a procedure shall be utilized to afford a level of protection equivalent to personal lockout, including a primary authorized employee coordinating the group lockout."
        ),
        CodeLookupQuestion(
            id: "cl-loto-03",
            violationDescription: "After locking out a hydraulic press, the maintenance worker began work without first attempting to restart the machine to verify zero energy state.",
            category: "LOTO",
            correctCitation: "29 CFR 1910.147(d)(6)",
            correctTitle: "Verification of Isolation",
            distractors: [
                "29 CFR 1910.147(d)(4)",
                "29 CFR 1910.147(d)(1)",
                "29 CFR 1910.147(c)(6)"
            ],
            explanation: "1910.147(d)(6) requires that before starting work on locked-out equipment, the authorized employee shall verify that isolation and deenergization have been accomplished — typically by attempting to restart the machine."
        ),
        CodeLookupQuestion(
            id: "cl-loto-04",
            violationDescription: "Annual periodic inspection of the LOTO program has not been conducted. No records of any inspection within the last 18 months.",
            category: "LOTO",
            correctCitation: "29 CFR 1910.147(c)(6)",
            correctTitle: "Periodic LOTO Inspection",
            distractors: [
                "29 CFR 1910.147(c)(4)",
                "29 CFR 1910.147(c)(7)",
                "29 CFR 1910.147(f)(1)"
            ],
            explanation: "1910.147(c)(6) requires a periodic inspection of the energy control procedure at least annually to ensure employees are following proper LOTO procedures."
        ),

        // MARK: - Confined Space (4 questions)
        CodeLookupQuestion(
            id: "cl-cs-01",
            violationDescription: "Worker entered a permit-required confined space to inspect a tank interior. No attendant stationed at the entry point.",
            category: "Confined Space",
            correctCitation: "29 CFR 1910.146(d)(6)",
            correctTitle: "Attendant Duties",
            distractors: [
                "29 CFR 1910.146(d)(3)",
                "29 CFR 1910.146(c)(5)",
                "29 CFR 1910.146(d)(9)"
            ],
            explanation: "1910.146(d)(6) requires the employer to provide at least one attendant outside the permit space for the duration of entry operations. The attendant must remain at the entry point."
        ),
        CodeLookupQuestion(
            id: "cl-cs-02",
            violationDescription: "Atmospheric testing was performed in a permit-required confined space but only tested for oxygen. No tests for combustible gases or toxic substances.",
            category: "Confined Space",
            correctCitation: "29 CFR 1910.146(d)(5)(ii)",
            correctTitle: "Atmospheric Testing Sequence",
            distractors: [
                "29 CFR 1910.146(c)(5)(ii)",
                "29 CFR 1910.146(d)(3)(iii)",
                "29 CFR 1910.146(d)(9)(i)"
            ],
            explanation: "1910.146(d)(5)(ii) requires atmospheric testing for oxygen content first, then combustible gases, then toxic gases/vapors — in that specific order, and all three must be checked."
        ),
        CodeLookupQuestion(
            id: "cl-cs-03",
            violationDescription: "Confined space entry in progress but no signed entry permit posted at or near the entrance to the space.",
            category: "Confined Space",
            correctCitation: "29 CFR 1910.146(d)(9)",
            correctTitle: "Entry Permit Posting",
            distractors: [
                "29 CFR 1910.146(d)(6)",
                "29 CFR 1910.146(c)(4)",
                "29 CFR 1910.146(d)(3)"
            ],
            explanation: "1910.146(d)(9) requires that the completed permit be made available at the time of entry to all authorized entrants by posting it at the entry portal or by any other equally effective means."
        ),
        CodeLookupQuestion(
            id: "cl-cs-04",
            violationDescription: "Rescue team designated for a confined space entry has never practiced the rescue procedure or conducted drills for this type of space.",
            category: "Confined Space",
            correctCitation: "29 CFR 1910.146(k)(1)(iv)",
            correctTitle: "Rescue Team Practice",
            distractors: [
                "29 CFR 1910.146(k)(2)(iii)",
                "29 CFR 1910.146(d)(4)(ii)",
                "29 CFR 1910.146(k)(1)(ii)"
            ],
            explanation: "1910.146(k)(1)(iv) requires that the designated rescue service practice making permit space rescues at least once every 12 months using simulated conditions that represent the actual permit spaces."
        ),

        // MARK: - Fire Protection (4 questions)
        CodeLookupQuestion(
            id: "cl-fire-01",
            violationDescription: "Fire extinguisher in a warehouse is mounted on a wall with its handle at 6 feet above the floor. Pallets are stacked within 2 feet of it.",
            category: "Fire Protection",
            correctCitation: "29 CFR 1910.157(c)(1)",
            correctTitle: "Extinguisher Access and Mounting",
            distractors: [
                "29 CFR 1910.157(d)(1)",
                "29 CFR 1910.37(a)(3)",
                "29 CFR 1910.157(e)(1)"
            ],
            explanation: "1910.157(c)(1) requires fire extinguishers to be conspicuously located, readily accessible, and immediately available. Extinguishers over 40 lbs must have tops no higher than 3.5 feet; lighter ones no higher than 5 feet. Obstructed access is a violation."
        ),
        CodeLookupQuestion(
            id: "cl-fire-02",
            violationDescription: "Materials and equipment stored in front of an emergency exit door, blocking the egress path in a manufacturing facility.",
            category: "Fire Protection",
            correctCitation: "29 CFR 1910.37(a)(3)",
            correctTitle: "Exit Route Maintenance",
            distractors: [
                "29 CFR 1910.36(b)(1)",
                "29 CFR 1910.157(c)(1)",
                "29 CFR 1910.37(b)(1)"
            ],
            explanation: "1910.37(a)(3) requires that exit routes be kept free and unobstructed. No materials or equipment may block or reduce the width of an exit route."
        ),
        CodeLookupQuestion(
            id: "cl-fire-03",
            violationDescription: "Hot work (welding) being performed in a maintenance area without a fire watch posted and no hot work permit on file.",
            category: "Fire Protection",
            correctCitation: "29 CFR 1910.252(a)(2)(iii)",
            correctTitle: "Fire Watch for Hot Work",
            distractors: [
                "29 CFR 1910.252(a)(2)(i)",
                "29 CFR 1910.252(b)(4)(ii)",
                "29 CFR 1926.352(c)(1)(i)"
            ],
            explanation: "1910.252(a)(2)(iii) requires a fire watch during and for at least 30 minutes after hot work operations when combustible materials are closer than 35 feet and cannot be moved."
        ),
        CodeLookupQuestion(
            id: "cl-fire-04",
            violationDescription: "Portable fire extinguishers have not received annual maintenance inspections. Last documented inspection was over 18 months ago.",
            category: "Fire Protection",
            correctCitation: "29 CFR 1910.157(e)(2)",
            correctTitle: "Annual Extinguisher Maintenance",
            distractors: [
                "29 CFR 1910.157(c)(1)",
                "29 CFR 1910.157(e)(3)",
                "29 CFR 1910.157(d)(1)"
            ],
            explanation: "1910.157(e)(2) requires that portable fire extinguishers be subjected to an annual maintenance check and that the date of maintenance be recorded on the tag attached to each extinguisher."
        ),

        // MARK: - Housekeeping (3 questions)
        CodeLookupQuestion(
            id: "cl-hk-01",
            violationDescription: "Warehouse aisles have no permanent markings to separate pedestrian walkways from forklift travel lanes.",
            category: "Housekeeping",
            correctCitation: "29 CFR 1910.176(a)",
            correctTitle: "Aisle Markings for Storage Areas",
            distractors: [
                "29 CFR 1910.22(a)(1)",
                "29 CFR 1910.178(n)(1)",
                "29 CFR 1910.176(b)"
            ],
            explanation: "1910.176(a) requires permanent aisles and passageways to be kept clear and in good repair with no obstruction. Where mechanical handling equipment is used, sufficient safe clearances shall be allowed and aisles marked."
        ),
        CodeLookupQuestion(
            id: "cl-hk-02",
            violationDescription: "Oil spill on a workshop floor left unaddressed for the duration of the shift. No absorbent deployed, no wet floor signs posted.",
            category: "Housekeeping",
            correctCitation: "29 CFR 1910.22(a)(1)",
            correctTitle: "General Walking-Working Surfaces",
            distractors: [
                "29 CFR 1910.176(a)",
                "29 CFR 1910.141(a)(3)",
                "29 CFR 1910.22(d)(1)"
            ],
            explanation: "1910.22(a)(1) requires all places of employment, passageways, storerooms, and service rooms to be kept clean, orderly, and in a sanitary condition. Floors must be kept free from hazards such as oil and grease."
        ),
        CodeLookupQuestion(
            id: "cl-hk-03",
            violationDescription: "Heavy boxes stacked six feet high on a shelf with the heaviest items on top. No securing or banding to prevent shifting.",
            category: "Housekeeping",
            correctCitation: "29 CFR 1910.176(b)",
            correctTitle: "Safe Storage Practices",
            distractors: [
                "29 CFR 1910.176(a)",
                "29 CFR 1910.22(a)(1)",
                "29 CFR 1910.178(o)(1)"
            ],
            explanation: "1910.176(b) requires that storage of material shall not create a hazard. Bags, containers, bundles, etc. stored in tiers shall be stacked, blocked, interlocked, and limited in height so they are stable and secure."
        ),

        // MARK: - AF-Specific (4 questions)
        CodeLookupQuestion(
            id: "cl-af-01",
            violationDescription: "Foreign Object Debris found on the aircraft taxi area during flight operations. No FOD walk completed prior to flight line opening.",
            category: "AF-Specific",
            correctCitation: "AFI 21-101 para 14.19",
            correctTitle: "FOD Prevention Program",
            distractors: [
                "AFI 21-101 para 10.8",
                "AFI 91-202 para 9.12",
                "AFI 21-101 para 2.15"
            ],
            explanation: "AFI 21-101 paragraph 14.19 establishes FOD prevention procedures including required FOD walks, inspection of all areas where aircraft operate, and accountability for FOD-related damage."
        ),
        CodeLookupQuestion(
            id: "cl-af-02",
            violationDescription: "Aircraft parked on the flight line without wheel chocks installed on both main landing gear.",
            category: "AF-Specific",
            correctCitation: "T.O. 00-25-172",
            correctTitle: "Ground Servicing of Aircraft",
            distractors: [
                "T.O. 00-25-195",
                "T.O. 00-20-1",
                "T.O. 00-25-107"
            ],
            explanation: "T.O. 00-25-172 provides procedures for ground servicing of aircraft and aerospace equipment, including the requirement for proper chocking of aircraft wheels to prevent uncontrolled movement."
        ),
        CodeLookupQuestion(
            id: "cl-af-03",
            violationDescription: "Personnel on the active flight line without double hearing protection in a posted high-noise area during engine runs.",
            category: "AF-Specific",
            correctCitation: "AFMAN 91-203 para 15.3",
            correctTitle: "Hearing Conservation on Flight Line",
            distractors: [
                "AFMAN 91-203 para 24.8",
                "AFMAN 91-203 para 12.6",
                "AFMAN 91-203 para 15.9"
            ],
            explanation: "AFMAN 91-203 paragraph 15.3 addresses hearing conservation requirements, including double hearing protection (plugs plus muffs) in high-noise environments such as the flight line during engine operations."
        ),
        CodeLookupQuestion(
            id: "cl-af-04",
            violationDescription: "Fuel servicing operation in progress with no fire extinguisher positioned within 50 feet of the fueling point. Aircraft not grounded.",
            category: "AF-Specific",
            correctCitation: "AFMAN 91-203 para 24.11",
            correctTitle: "Aircraft Fueling Safety",
            distractors: [
                "AFMAN 91-203 para 24.3",
                "AFMAN 91-203 para 22.7",
                "AFMAN 91-203 para 24.18"
            ],
            explanation: "AFMAN 91-203 paragraph 24.11 establishes aircraft fuel servicing safety requirements including fire extinguisher positioning, grounding/bonding, and safety zone restrictions during fueling operations."
        ),
    ]
}
