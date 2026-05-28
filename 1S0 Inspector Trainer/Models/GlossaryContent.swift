import Foundation

enum GlossaryCategory: String, CaseIterable, Identifiable {
    case airForceProgram = "Air Force Program"
    case riskManagement = "Risk Management"
    case lockoutTagout = "Lockout/Tagout"
    case fallProtection = "Fall Protection"
    case confinedSpace = "Confined Space"
    case ppeHealth = "PPE & Health"
    case inspection = "Inspection"

    var id: String { rawValue }
}

struct GlossaryTerm: Identifiable, Hashable {
    let id: String
    let term: String
    let abbreviation: String?
    let category: GlossaryCategory
    let definition: String
    let fieldUse: String
    let sourceCitation: String
    let moduleIds: [String]
    let keywords: [String]

    var displayTitle: String {
        if let abbreviation {
            return "\(term) (\(abbreviation))"
        }
        return term
    }

    func matches(_ query: String) -> Bool {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else { return true }

        let haystack = [
            term,
            abbreviation ?? "",
            category.rawValue,
            definition,
            fieldUse,
            sourceCitation
        ] + keywords

        return haystack.contains { value in
            value.localizedCaseInsensitiveContains(trimmedQuery)
        }
    }
}

enum GlossaryContent {
    static let terms: [GlossaryTerm] = [
        GlossaryTerm(
            id: "daf-form-457",
            term: "DAF Form 457",
            abbreviation: nil,
            category: .airForceProgram,
            definition: "Department of the Air Force hazard report form used to report unsafe conditions or practices for investigation and tracking.",
            fieldUse: "Use the current DAF Form 457 name when processing hazard reports; some older material may use AF Form 457.",
            sourceCitation: "DAFI 91-202_DAFGM2026-01, Hazard Reporting and DAF Form 457 guidance",
            moduleIds: ["mishap-reporting"],
            keywords: ["hazard report", "unsafe condition", "unsafe practice", "form 457"]
        ),
        GlossaryTerm(
            id: "mishap",
            term: "Mishap",
            abbreviation: nil,
            category: .airForceProgram,
            definition: "An unplanned event or series of events that causes injury, illness, death, or damage to equipment, property, or the environment.",
            fieldUse: "Separate mishap reporting from routine hazard reporting. A hazard report identifies a condition; a mishap records an event that already occurred.",
            sourceCitation: "DAFI 91-202, The Department of the Air Force Mishap Prevention Program",
            moduleIds: ["mishap-reporting"],
            keywords: ["event", "injury", "damage", "reporting"]
        ),
        GlossaryTerm(
            id: "hazard",
            term: "Hazard",
            abbreviation: nil,
            category: .airForceProgram,
            definition: "A real or potential condition that can cause injury, illness, death, property damage, mission degradation, or environmental harm.",
            fieldUse: "Write hazards as conditions with credible consequences, not just as administrative concerns or preferences.",
            sourceCitation: "DAFPAM 90-803, Risk Management Guidelines and Tools",
            moduleIds: ["risk-management", "mishap-reporting", "deployed-orm"],
            keywords: ["unsafe condition", "risk", "threat", "exposure"]
        ),
        GlossaryTerm(
            id: "job-safety-training-outline",
            term: "Job Safety Training Outline",
            abbreviation: "JSTO",
            category: .airForceProgram,
            definition: "A documented outline that identifies job safety training requirements for a duty position or task.",
            fieldUse: "Use JSTOs to confirm workers were trained on hazards, controls, PPE, and local procedures before judging a program gap.",
            sourceCitation: "DAFMAN 91-203, Chapter 1 safety training program requirements",
            moduleIds: ["roles-responsibilities", "ppe-decision"],
            keywords: ["training", "outline", "supervisor", "worker"]
        ),
        GlossaryTerm(
            id: "risk-management",
            term: "Risk Management",
            abbreviation: "RM",
            category: .riskManagement,
            definition: "A decision-making process used to identify hazards, assess risk, develop controls, make decisions, implement controls, and supervise results.",
            fieldUse: "Use RM language when briefing commanders: hazard, initial risk, controls, residual risk, and acceptance authority.",
            sourceCitation: "DAFPAM 90-803, Department of the Air Force Risk Management process",
            moduleIds: ["risk-management", "deployed-orm"],
            keywords: ["ORM", "process", "controls", "commander"]
        ),
        GlossaryTerm(
            id: "risk-assessment-code",
            term: "Risk Assessment Code",
            abbreviation: "RAC",
            category: .riskManagement,
            definition: "A numeric risk priority derived from hazard severity and probability. RAC 1 is the highest priority and RAC 5 is the lowest.",
            fieldUse: "Assign RAC from the matrix after deciding the worst credible severity and likelihood, then use it to drive investigation priority.",
            sourceCitation: "DAFI 91-202 and DAFMAN 91-203 hazard abatement guidance",
            moduleIds: ["risk-management", "mishap-reporting"],
            keywords: ["severity", "probability", "matrix", "priority"]
        ),
        GlossaryTerm(
            id: "initial-risk",
            term: "Initial Risk",
            abbreviation: nil,
            category: .riskManagement,
            definition: "The assessed risk level before new controls are applied.",
            fieldUse: "Record initial risk before selecting controls so leaders can see the original exposure and the value of mitigation.",
            sourceCitation: "DAFPAM 90-803, Risk Management Guidelines and Tools",
            moduleIds: ["risk-management", "deployed-orm"],
            keywords: ["before controls", "baseline", "assessment"]
        ),
        GlossaryTerm(
            id: "residual-risk",
            term: "Residual Risk",
            abbreviation: nil,
            category: .riskManagement,
            definition: "The risk that remains after controls are selected and implemented.",
            fieldUse: "Residual risk is what the appropriate leader accepts, rejects, or elevates.",
            sourceCitation: "DAFPAM 90-803, Risk Management Guidelines and Tools",
            moduleIds: ["risk-management", "deployed-orm"],
            keywords: ["remaining risk", "controls", "acceptance"]
        ),
        GlossaryTerm(
            id: "risk-acceptance-authority",
            term: "Risk Acceptance Authority",
            abbreviation: nil,
            category: .riskManagement,
            definition: "The commander or leader authorized by policy or local direction to accept a given level of residual risk.",
            fieldUse: "A 1S0 inspector informs the decision and documents the assessment; the inspector does not personally accept organizational risk.",
            sourceCitation: "DAFPAM 90-803, Risk Management Guidelines and Tools",
            moduleIds: ["risk-management", "deployed-orm", "roles-responsibilities"],
            keywords: ["commander", "residual risk", "authority", "decision"]
        ),
        GlossaryTerm(
            id: "lockout",
            term: "Lockout",
            abbreviation: nil,
            category: .lockoutTagout,
            definition: "Placement of a lockout device on an energy-isolating device so equipment cannot be operated until the device is removed.",
            fieldUse: "Lockout provides physical restraint. It is the preferred control when equipment can be locked out.",
            sourceCitation: "OSHA 29 CFR 1910.147(b), Definitions",
            moduleIds: ["loto"],
            keywords: ["LOTO", "lock", "energy control", "device"]
        ),
        GlossaryTerm(
            id: "tagout",
            term: "Tagout",
            abbreviation: nil,
            category: .lockoutTagout,
            definition: "Placement of a warning tag on an energy-isolating device to show the equipment may not be operated until the tag is removed.",
            fieldUse: "A tag is a warning device, not a physical restraint. Use it only under an approved tagout process.",
            sourceCitation: "OSHA 29 CFR 1910.147(b), Definitions",
            moduleIds: ["loto"],
            keywords: ["LOTO", "tag", "warning", "energy control"]
        ),
        GlossaryTerm(
            id: "authorized-employee",
            term: "Authorized Employee",
            abbreviation: nil,
            category: .lockoutTagout,
            definition: "A person who locks out or tags out equipment to perform servicing or maintenance.",
            fieldUse: "The authorized employee controls the lock or tag and verifies isolation before work begins.",
            sourceCitation: "OSHA 29 CFR 1910.147(b), Definitions",
            moduleIds: ["loto"],
            keywords: ["LOTO", "worker", "servicing", "maintenance"]
        ),
        GlossaryTerm(
            id: "affected-employee",
            term: "Affected Employee",
            abbreviation: nil,
            category: .lockoutTagout,
            definition: "An employee whose job involves operating or using equipment being serviced under lockout/tagout, or working in the area where servicing occurs.",
            fieldUse: "Notify affected employees before lockout/tagout begins and before equipment returns to service.",
            sourceCitation: "OSHA 29 CFR 1910.147(b), Definitions",
            moduleIds: ["loto"],
            keywords: ["LOTO", "operator", "notification", "area"]
        ),
        GlossaryTerm(
            id: "energy-isolating-device",
            term: "Energy-Isolating Device",
            abbreviation: nil,
            category: .lockoutTagout,
            definition: "A mechanical device that physically prevents transmission or release of energy, such as a disconnect switch, valve, or block.",
            fieldUse: "Start LOTO planning by identifying every energy-isolating device and stored energy source.",
            sourceCitation: "OSHA 29 CFR 1910.147(b), Definitions",
            moduleIds: ["loto"],
            keywords: ["disconnect", "valve", "block", "hazardous energy"]
        ),
        GlossaryTerm(
            id: "zero-energy-verification",
            term: "Zero Energy Verification",
            abbreviation: nil,
            category: .lockoutTagout,
            definition: "A verification step confirming equipment isolation and release of stored energy before servicing or maintenance starts.",
            fieldUse: "Do not treat a lock as proof by itself. Verify isolation with the approved try-out or test method before exposure.",
            sourceCitation: "OSHA 29 CFR 1910.147(d)(6), Verification of Isolation",
            moduleIds: ["loto"],
            keywords: ["try-out", "stored energy", "verification", "isolation"]
        ),
        GlossaryTerm(
            id: "walking-working-surface",
            term: "Walking-Working Surface",
            abbreviation: nil,
            category: .fallProtection,
            definition: "Any horizontal or vertical surface on or through which an employee walks, works, or gains access to a work area.",
            fieldUse: "Use this term for floors, roofs, ladders, stairs, ramps, scaffolds, and similar access surfaces.",
            sourceCitation: "OSHA 29 CFR 1910.21(b), Definitions",
            moduleIds: ["fall-protection"],
            keywords: ["floor", "roof", "ladder", "surface"]
        ),
        GlossaryTerm(
            id: "fall-hazard",
            term: "Fall Hazard",
            abbreviation: nil,
            category: .fallProtection,
            definition: "Any condition on a walking-working surface that exposes a worker to a fall to a lower level or into a dangerous area.",
            fieldUse: "Identify fall hazards before picking controls. The hazard may be an edge, hole, ladder setup, roof work, or scaffold condition.",
            sourceCitation: "OSHA 29 CFR 1910 Subpart D, Walking-Working Surfaces",
            moduleIds: ["fall-protection"],
            keywords: ["edge", "hole", "lower level", "roof"]
        ),
        GlossaryTerm(
            id: "personal-fall-arrest-system",
            term: "Personal Fall Arrest System",
            abbreviation: "PFAS",
            category: .fallProtection,
            definition: "A system used to arrest a worker in a fall from a walking-working surface, typically including anchorage, body harness, and connectors.",
            fieldUse: "PFAS reduces injury after a fall starts. It must be paired with rescue planning and inspected before use.",
            sourceCitation: "OSHA 29 CFR 1910.21(b) and 1910.140, Fall protection definitions and systems",
            moduleIds: ["fall-protection"],
            keywords: ["harness", "lanyard", "connector", "arrest"]
        ),
        GlossaryTerm(
            id: "anchorage",
            term: "Anchorage",
            abbreviation: nil,
            category: .fallProtection,
            definition: "A secure point of attachment for equipment such as lifelines, lanyards, or deceleration devices.",
            fieldUse: "Check that anchorages are independent, compatible with the system, and strong enough for the required fall protection use.",
            sourceCitation: "OSHA 29 CFR 1910.21(b) and 1910.140(c), Anchorage requirements",
            moduleIds: ["fall-protection"],
            keywords: ["anchor", "lifeline", "lanyard", "connector"]
        ),
        GlossaryTerm(
            id: "guardrail-system",
            term: "Guardrail System",
            abbreviation: nil,
            category: .fallProtection,
            definition: "A barrier installed along an unprotected side, edge, or opening to prevent workers from falling to a lower level.",
            fieldUse: "Guardrails are passive controls and are often preferred when they can remove the need for individual tie-off.",
            sourceCitation: "OSHA 29 CFR 1910.21(b) and 1910.29, Guardrail systems",
            moduleIds: ["fall-protection"],
            keywords: ["top rail", "midrail", "edge", "opening"]
        ),
        GlossaryTerm(
            id: "hole",
            term: "Hole",
            abbreviation: nil,
            category: .fallProtection,
            definition: "A gap or open space in a floor, roof, horizontal walking-working surface, or similar surface.",
            fieldUse: "Guard or cover holes when workers can fall through them or trip into them.",
            sourceCitation: "OSHA 29 CFR 1910.21(b), Definitions; 1910.28(b)(3), Hole protection",
            moduleIds: ["fall-protection"],
            keywords: ["opening", "cover", "floor", "roof"]
        ),
        GlossaryTerm(
            id: "confined-space",
            term: "Confined Space",
            abbreviation: nil,
            category: .confinedSpace,
            definition: "A space large enough to enter, with limited or restricted entry or exit, and not designed for continuous employee occupancy.",
            fieldUse: "Do not call every small area a confined space. Confirm all three criteria before applying confined space controls.",
            sourceCitation: "OSHA 29 CFR 1910.146(b), Definitions",
            moduleIds: ["confined-space"],
            keywords: ["tank", "vault", "limited entry", "not designed for occupancy"]
        ),
        GlossaryTerm(
            id: "permit-required-confined-space",
            term: "Permit-Required Confined Space",
            abbreviation: "PRCS",
            category: .confinedSpace,
            definition: "A confined space with a hazardous atmosphere, engulfment hazard, inwardly converging walls or sloped floor, or another serious safety or health hazard.",
            fieldUse: "Treat unknown atmospheres and serious hazards as permit-space triggers until evaluated by competent personnel.",
            sourceCitation: "OSHA 29 CFR 1910.146(b), Definitions",
            moduleIds: ["confined-space"],
            keywords: ["permit space", "hazardous atmosphere", "engulfment", "IDLH"]
        ),
        GlossaryTerm(
            id: "authorized-entrant",
            term: "Authorized Entrant",
            abbreviation: nil,
            category: .confinedSpace,
            definition: "An employee authorized by the employer to enter a permit-required confined space.",
            fieldUse: "Entrants must understand the hazards, communicate with the attendant, and evacuate when warning signs or orders require it.",
            sourceCitation: "OSHA 29 CFR 1910.146(b) and 1910.146(h), Entrant duties",
            moduleIds: ["confined-space"],
            keywords: ["entrant", "permit space", "entry", "worker"]
        ),
        GlossaryTerm(
            id: "attendant",
            term: "Attendant",
            abbreviation: nil,
            category: .confinedSpace,
            definition: "A person stationed outside a permit space who monitors entrants and performs assigned duties under the permit-space program.",
            fieldUse: "The attendant maintains accountability, communication, and emergency response coordination without entering for rescue unless trained and relieved.",
            sourceCitation: "OSHA 29 CFR 1910.146(b) and 1910.146(i), Attendant duties",
            moduleIds: ["confined-space"],
            keywords: ["permit space", "monitor", "rescue", "accountability"]
        ),
        GlossaryTerm(
            id: "entry-supervisor",
            term: "Entry Supervisor",
            abbreviation: nil,
            category: .confinedSpace,
            definition: "The person responsible for determining whether acceptable entry conditions exist, authorizing entry, overseeing entry operations, and terminating entry.",
            fieldUse: "The entry supervisor verifies permits, tests, controls, rescue arrangements, and personnel before entry begins.",
            sourceCitation: "OSHA 29 CFR 1910.146(b) and 1910.146(j), Entry supervisor duties",
            moduleIds: ["confined-space"],
            keywords: ["permit", "supervisor", "authorization", "terminate entry"]
        ),
        GlossaryTerm(
            id: "idlh-atmosphere",
            term: "Immediately Dangerous to Life or Health Atmosphere",
            abbreviation: "IDLH",
            category: .confinedSpace,
            definition: "An atmosphere that poses an immediate threat to life, would cause irreversible health effects, or would impair escape.",
            fieldUse: "Unknown, oxygen-deficient, or suspected IDLH atmospheres require controls such as supplied-air protection and rescue planning.",
            sourceCitation: "OSHA 29 CFR 1910.146(b) and 1910.134(b), Definitions",
            moduleIds: ["confined-space", "ppe-decision"],
            keywords: ["atmosphere", "oxygen deficient", "respirator", "escape"]
        ),
        GlossaryTerm(
            id: "personal-protective-equipment",
            term: "Personal Protective Equipment",
            abbreviation: "PPE",
            category: .ppeHealth,
            definition: "Equipment worn to minimize exposure to hazards that can cause workplace injury or illness.",
            fieldUse: "PPE is selected after assessing the hazard and should not replace feasible engineering or administrative controls.",
            sourceCitation: "OSHA 29 CFR 1910.132, General PPE requirements; DAFMAN 91-203, Chapter 14",
            moduleIds: ["ppe-decision", "roles-responsibilities"],
            keywords: ["gloves", "eye protection", "boots", "helmet"]
        ),
        GlossaryTerm(
            id: "safety-data-sheet",
            term: "Safety Data Sheet",
            abbreviation: "SDS",
            category: .ppeHealth,
            definition: "A standardized chemical hazard document that communicates identification, hazards, safe handling, exposure controls, and emergency measures.",
            fieldUse: "Use the SDS to select PPE, storage controls, spill response actions, and worker training topics for chemical hazards.",
            sourceCitation: "OSHA 29 CFR 1910.1200(g), Safety Data Sheets",
            moduleIds: ["ppe-decision", "roles-responsibilities"],
            keywords: ["chemical", "hazcom", "spill", "exposure"]
        ),
        GlossaryTerm(
            id: "hazard-communication",
            term: "Hazard Communication",
            abbreviation: "HazCom",
            category: .ppeHealth,
            definition: "A program for classifying chemical hazards and communicating them through labels, safety data sheets, and employee training.",
            fieldUse: "Use HazCom checks to confirm workers can identify chemical hazards, find SDSs, understand labels, and apply protective measures.",
            sourceCitation: "OSHA 29 CFR 1910.1200, Hazard Communication",
            moduleIds: ["hazcom", "ppe-decision"],
            keywords: ["chemical", "label", "SDS", "training"]
        ),
        GlossaryTerm(
            id: "chemical-label",
            term: "Chemical Label",
            abbreviation: nil,
            category: .ppeHealth,
            definition: "Hazard communication information on a chemical container, including identity and required hazard information for safe use.",
            fieldUse: "Missing, damaged, or incomplete labels are inspection findings because workers lose immediate hazard and handling information.",
            sourceCitation: "OSHA 29 CFR 1910.1200(f), Labels and other forms of warning",
            moduleIds: ["hazcom"],
            keywords: ["container", "pictogram", "signal word", "hazard statement"]
        ),
        GlossaryTerm(
            id: "self-contained-breathing-apparatus",
            term: "Self-Contained Breathing Apparatus",
            abbreviation: "SCBA",
            category: .ppeHealth,
            definition: "A respirator with a portable supply of breathing air carried by the wearer.",
            fieldUse: "SCBA is used when an atmosphere is unknown, oxygen-deficient, or IDLH and air-purifying respirators are not acceptable.",
            sourceCitation: "OSHA 29 CFR 1910.134(b), Respiratory protection definitions",
            moduleIds: ["confined-space", "ppe-decision"],
            keywords: ["respirator", "breathing air", "IDLH", "unknown atmosphere"]
        ),
        GlossaryTerm(
            id: "air-purifying-respirator",
            term: "Air-Purifying Respirator",
            abbreviation: "APR",
            category: .ppeHealth,
            definition: "A respirator that removes contaminants from ambient air with filters, cartridges, or canisters.",
            fieldUse: "APR use requires a known contaminant, adequate oxygen, correct cartridge selection, fit testing, and program controls.",
            sourceCitation: "OSHA 29 CFR 1910.134(b), Respiratory protection definitions",
            moduleIds: ["ppe-decision", "confined-space"],
            keywords: ["respirator", "cartridge", "filter", "non-IDLH"]
        ),
        GlossaryTerm(
            id: "time-weighted-average",
            term: "Time-Weighted Average",
            abbreviation: "TWA",
            category: .ppeHealth,
            definition: "An average exposure level over a specified period, commonly an eight-hour work shift for occupational exposure limits.",
            fieldUse: "Use TWA when judging noise and chemical exposure against exposure limits, not just short peak readings.",
            sourceCitation: "OSHA 29 CFR 1910.95 and 1910.1000 exposure limit structure",
            moduleIds: ["hearing-conservation"],
            keywords: ["noise", "exposure", "eight hour", "average"]
        ),
        GlossaryTerm(
            id: "standard-threshold-shift",
            term: "Standard Threshold Shift",
            abbreviation: "STS",
            category: .ppeHealth,
            definition: "A reportable change in hearing threshold under OSHA hearing conservation rules when measured against the employee baseline audiogram.",
            fieldUse: "STS findings trigger required follow-up actions in a hearing conservation program.",
            sourceCitation: "OSHA 29 CFR 1910.95(g)(10), Standard threshold shift",
            moduleIds: ["hearing-conservation"],
            keywords: ["hearing", "audiogram", "noise", "threshold"]
        ),
        GlossaryTerm(
            id: "hearing-conservation-program",
            term: "Hearing Conservation Program",
            abbreviation: "HCP",
            category: .ppeHealth,
            definition: "A program required when worker noise exposure meets or exceeds the action level, including monitoring, audiometry, hearing protection, training, and records.",
            fieldUse: "Look for a complete program, not just earplugs, when noise exposure reaches action-level criteria.",
            sourceCitation: "OSHA 29 CFR 1910.95(c), Hearing conservation program",
            moduleIds: ["hearing-conservation"],
            keywords: ["noise", "audiometry", "earplugs", "training"]
        ),
        GlossaryTerm(
            id: "exposed-live-parts",
            term: "Exposed Live Parts",
            abbreviation: nil,
            category: .inspection,
            definition: "Energized electrical conductors or circuit parts that are not adequately guarded from accidental contact.",
            fieldUse: "Treat exposed live parts as an immediate control issue. Restrict access and involve qualified electrical personnel.",
            sourceCitation: "OSHA 29 CFR 1910.303(b)(2), Guarding of live parts",
            moduleIds: ["electrical"],
            keywords: ["electrical", "shock", "energized", "guarding"]
        ),
        GlossaryTerm(
            id: "ground-fault-circuit-interrupter",
            term: "Ground-Fault Circuit Interrupter",
            abbreviation: "GFCI",
            category: .inspection,
            definition: "A protective device that interrupts electric current when a ground fault is detected.",
            fieldUse: "Look for GFCI protection in wet, temporary, construction, or other required-use conditions where shock risk is elevated.",
            sourceCitation: "OSHA 29 CFR 1910 Subpart S and 29 CFR 1926.404(b)(1), Ground-fault protection",
            moduleIds: ["electrical"],
            keywords: ["electrical", "shock", "wet location", "temporary wiring"]
        ),
        GlossaryTerm(
            id: "electrical-working-space",
            term: "Electrical Working Space",
            abbreviation: nil,
            category: .inspection,
            definition: "Clear space around electrical equipment needed for safe operation, inspection, and maintenance.",
            fieldUse: "Storage in panel working space is not just housekeeping. It blocks access and can increase shock or arc exposure during work.",
            sourceCitation: "OSHA 29 CFR 1910.303(g), Space about electric equipment",
            moduleIds: ["electrical"],
            keywords: ["panel", "clearance", "access", "storage"]
        ),
        GlossaryTerm(
            id: "machine-guard",
            term: "Machine Guard",
            abbreviation: nil,
            category: .inspection,
            definition: "A barrier or device that protects operators and other workers from machine hazards such as point of operation, nip points, rotating parts, chips, and sparks.",
            fieldUse: "Do not accept PPE, signs, or experience as substitutes for required guards when workers can contact moving parts.",
            sourceCitation: "OSHA 29 CFR 1910.212(a)(1), General machine guarding",
            moduleIds: ["machine-guarding"],
            keywords: ["guarding", "rotating parts", "flying chips", "sparks"]
        ),
        GlossaryTerm(
            id: "point-of-operation",
            term: "Point of Operation",
            abbreviation: nil,
            category: .inspection,
            definition: "The area on a machine where work is performed on the material being processed.",
            fieldUse: "Point-of-operation exposure is a high-value inspection focus because it is where hands often approach cutting, shaping, or pressing hazards.",
            sourceCitation: "OSHA 29 CFR 1910.212(a)(3), Point of operation guarding",
            moduleIds: ["machine-guarding"],
            keywords: ["machine", "cutting", "pressing", "operator"]
        ),
        GlossaryTerm(
            id: "ingoing-nip-point",
            term: "Ingoing Nip Point",
            abbreviation: nil,
            category: .inspection,
            definition: "A pinch point created where moving parts, or a moving part and fixed object, can draw in a body part, clothing, or material.",
            fieldUse: "Inspect belts, pulleys, rollers, gears, and conveyor drives for exposed nip points.",
            sourceCitation: "OSHA 29 CFR 1910.212(a)(1), Machine guarding hazards",
            moduleIds: ["machine-guarding", "loto"],
            keywords: ["pinch point", "belt", "pulley", "roller"]
        ),
        GlossaryTerm(
            id: "tongue-guard",
            term: "Tongue Guard",
            abbreviation: nil,
            category: .inspection,
            definition: "An adjustable guard at the top of an abrasive wheel opening that limits the gap between the guard and grinding wheel.",
            fieldUse: "On bench grinders, verify tongue guards and work rests are adjusted close to the wheel and corrected as the wheel wears.",
            sourceCitation: "OSHA 29 CFR 1910.215(a)(4), Abrasive wheel work rests and tongue guards",
            moduleIds: ["machine-guarding"],
            keywords: ["bench grinder", "abrasive wheel", "work rest", "gap"]
        ),
        GlossaryTerm(
            id: "powered-industrial-truck",
            term: "Powered Industrial Truck",
            abbreviation: "PIT",
            category: .inspection,
            definition: "A powered mobile industrial vehicle used to carry, push, pull, lift, stack, or tier materials.",
            fieldUse: "Forklift findings often involve authorization, refresher training, inspections, attachments, loads, and traffic controls.",
            sourceCitation: "OSHA 29 CFR 1910.178, Powered industrial trucks",
            moduleIds: ["material-handling"],
            keywords: ["forklift", "operator", "warehouse", "load"]
        ),
        GlossaryTerm(
            id: "capacity-plate",
            term: "Capacity Plate",
            abbreviation: nil,
            category: .inspection,
            definition: "Manufacturer load-capacity information on powered industrial trucks and similar equipment that tells operators what the equipment can safely handle.",
            fieldUse: "Missing or unreadable capacity information means operators may guess at safe loads. Remove equipment from service until capacity is verified.",
            sourceCitation: "OSHA 29 CFR 1910.178(a)(4) and 1910.178(q), Markings and deficient equipment",
            moduleIds: ["material-handling"],
            keywords: ["forklift", "nameplate", "load", "attachment"]
        ),
        GlossaryTerm(
            id: "elevated-load",
            term: "Elevated Load",
            abbreviation: nil,
            category: .inspection,
            definition: "A suspended or raised material load that can strike, crush, or trap personnel if it falls or shifts.",
            fieldUse: "Keep personnel clear of raised forks, suspended loads, hoist paths, and any area where a load could drop or swing.",
            sourceCitation: "OSHA 29 CFR 1910.178(m)(2), Personnel under elevated portions of trucks",
            moduleIds: ["material-handling"],
            keywords: ["forklift", "hoist", "suspended load", "crush"]
        ),
        GlossaryTerm(
            id: "hot-work",
            term: "Hot Work",
            abbreviation: nil,
            category: .inspection,
            definition: "Work such as welding, cutting, brazing, soldering, or grinding that can create flame, sparks, or enough heat to ignite combustibles.",
            fieldUse: "Before hot work starts, verify authorization, combustible control, fire watch needs, ventilation, PPE, and emergency equipment.",
            sourceCitation: "OSHA 29 CFR 1910.252, Welding, cutting, and brazing",
            moduleIds: ["fire-hot-work"],
            keywords: ["welding", "cutting", "grinding", "spark"]
        ),
        GlossaryTerm(
            id: "fire-watch",
            term: "Fire Watch",
            abbreviation: nil,
            category: .inspection,
            definition: "A person assigned to watch for and respond to fire hazards during and after hot work when combustibles or ignition pathways remain.",
            fieldUse: "A fire watch is an active control. It does not replace combustible removal, shielding, extinguisher access, or hot work authorization.",
            sourceCitation: "OSHA 29 CFR 1910.252(a)(2)(iii), Fire watchers",
            moduleIds: ["fire-hot-work"],
            keywords: ["hot work", "combustibles", "extinguisher", "post work"]
        ),
        GlossaryTerm(
            id: "portable-fire-extinguisher",
            term: "Portable Fire Extinguisher",
            abbreviation: nil,
            category: .inspection,
            definition: "A portable fire protection device intended for use on incipient-stage fires when personnel are trained and it is safe to respond.",
            fieldUse: "Inspect access, mounting, inspection status, maintenance, correct class, and whether employees are expected and trained to use it.",
            sourceCitation: "OSHA 29 CFR 1910.157, Portable fire extinguishers",
            moduleIds: ["fire-hot-work"],
            keywords: ["fire", "inspection", "access", "training"]
        ),
        GlossaryTerm(
            id: "exit-route",
            term: "Exit Route",
            abbreviation: nil,
            category: .inspection,
            definition: "A continuous, unobstructed path from any point in a workplace to a place of safety.",
            fieldUse: "Blocked exits and obstructed paths are immediate findings because they can trap personnel during fire or emergency evacuation.",
            sourceCitation: "OSHA 29 CFR 1910 Subpart E, Exit routes and emergency planning",
            moduleIds: ["fire-hot-work", "material-handling"],
            keywords: ["egress", "blocked exit", "evacuation", "path"]
        ),
        GlossaryTerm(
            id: "hierarchy-of-controls",
            term: "Hierarchy of Controls",
            abbreviation: nil,
            category: .inspection,
            definition: "A control selection framework that prioritizes elimination, substitution, engineering controls, administrative controls, and PPE.",
            fieldUse: "Use the hierarchy to push beyond PPE-only fixes and recommend controls that reduce exposure at the source.",
            sourceCitation: "OSHA Recommended Practices for Safety and Health Programs; DAF RM control selection principles",
            moduleIds: ["risk-management", "ppe-decision", "roles-responsibilities"],
            keywords: ["elimination", "substitution", "engineering", "administrative"]
        ),
        GlossaryTerm(
            id: "interim-control",
            term: "Interim Control",
            abbreviation: nil,
            category: .inspection,
            definition: "A temporary control used to reduce exposure while permanent corrective action is developed and completed.",
            fieldUse: "Interim controls should be immediate, documented, and monitored so the hazard is not left active during abatement.",
            sourceCitation: "DAFI 91-202 and DAFMAN 91-203 hazard abatement guidance",
            moduleIds: ["mishap-reporting", "risk-management"],
            keywords: ["temporary control", "abatement", "corrective action"]
        ),
        GlossaryTerm(
            id: "corrective-action",
            term: "Corrective Action",
            abbreviation: nil,
            category: .inspection,
            definition: "An action intended to eliminate a hazard or reduce its risk to an acceptable level.",
            fieldUse: "Write corrective actions as observable fixes with owners and due dates, not as vague reminders to be careful.",
            sourceCitation: "DAFI 91-202 and DAFMAN 91-203 hazard abatement guidance",
            moduleIds: ["mishap-reporting", "roles-responsibilities"],
            keywords: ["fix", "abatement", "owner", "due date"]
        ),
        GlossaryTerm(
            id: "qualified-person",
            term: "Qualified Person",
            abbreviation: nil,
            category: .inspection,
            definition: "A person who has the recognized degree, certificate, professional standing, knowledge, training, or experience needed to solve or resolve problems related to the work.",
            fieldUse: "Use this term carefully: qualified person status depends on the hazard and task, not rank or general experience alone.",
            sourceCitation: "OSHA 29 CFR 1910.21(b), Definitions",
            moduleIds: ["fall-protection", "roles-responsibilities"],
            keywords: ["training", "competency", "experience", "certification"]
        )
    ]
}
