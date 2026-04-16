import SwiftUI

// MARK: - Enums

enum ORMRiskLevel: String, CaseIterable, Identifiable {
    case low           = "Low"
    case medium        = "Medium"
    case high          = "High"
    case extremelyHigh = "Extremely High"

    var id: String { rawValue }
    var index: Int {
        switch self {
        case .low:           return 0
        case .medium:        return 1
        case .high:          return 2
        case .extremelyHigh: return 3
        }
    }

    var color: Color {
        switch self {
        case .low:           return AppTheme.primary
        case .medium:        return AppTheme.accent
        case .high:          return Color(red: 1.0, green: 0.45, blue: 0.0)
        case .extremelyHigh: return AppTheme.danger
        }
    }
}

enum RiskAcceptanceAuthority: String, CaseIterable, Identifiable {
    case flightCC = "Flight/CC or equivalent"
    case sqCC     = "Squadron/CC"
    case gpCC     = "Group/CC or above"
    case wingCC   = "Wing/CC or equivalent"

    var id: String { rawValue }
    var index: Int {
        switch self {
        case .flightCC: return 0
        case .sqCC:     return 1
        case .gpCC:     return 2
        case .wingCC:   return 3
        }
    }
}

// MARK: - Scenario

struct ORMScenario: Identifiable {
    let id: String
    let title: String
    let location: String
    let missionContext: String
    let situationBrief: String
    let complicatingFactors: [String]

    let hazardOptions: [String]
    let correctHazardIndex: Int

    let correctInitialRisk: ORMRiskLevel
    let mitigationOptions: [String]
    let correctMitigationIndex: Int
    let correctResidualRisk: ORMRiskLevel
    let correctAuthority: RiskAcceptanceAuthority

    let recommendedAction: String
    let explanations: [String: String]
}

// MARK: - Processing Step

struct ORMProcessingStep: Identifiable {
    let id: String
    let title: String
    let prompt: String
    let options: [String]
    let correctIndex: Int
    let explanation: String
}

// MARK: - Bank

enum DeployedORMBank {

    // MARK: - Scenarios

    static let allScenarios: [ORMScenario] = [
        generatorTent,
        expedientElectrical,
        damagedShelter,
        incompletePPE,
        hostNationWorkers,
        nightMovement,
    ]

    // MARK: - Step Builder

    static func steps(for scenario: ORMScenario) -> [ORMProcessingStep] {
        let riskOptions = ORMRiskLevel.allCases.map(\.rawValue)
        let authorityOptions = RiskAcceptanceAuthority.allCases.map(\.rawValue)

        return [
            ORMProcessingStep(
                id: "hazard",
                title: "IDENTIFY PRIMARY HAZARD",
                prompt: "Based on the situation brief, what is the primary hazard requiring immediate risk assessment?",
                options: scenario.hazardOptions,
                correctIndex: scenario.correctHazardIndex,
                explanation: scenario.explanations["hazard"] ?? ""
            ),
            ORMProcessingStep(
                id: "initial-risk",
                title: "ASSESS INITIAL RISK",
                prompt: "Before any controls are applied, what is the initial risk level for this hazard?",
                options: riskOptions,
                correctIndex: scenario.correctInitialRisk.index,
                explanation: scenario.explanations["initial-risk"] ?? ""
            ),
            ORMProcessingStep(
                id: "mitigation",
                title: "SELECT BEST MITIGATION",
                prompt: "Given the constraints of the deployed environment, which control measure best reduces risk?",
                options: scenario.mitigationOptions,
                correctIndex: scenario.correctMitigationIndex,
                explanation: scenario.explanations["mitigation"] ?? ""
            ),
            ORMProcessingStep(
                id: "residual-risk",
                title: "ASSESS RESIDUAL RISK",
                prompt: "After applying the selected mitigation, what is the residual risk level?",
                options: riskOptions,
                correctIndex: scenario.correctResidualRisk.index,
                explanation: scenario.explanations["residual-risk"] ?? ""
            ),
            ORMProcessingStep(
                id: "authority",
                title: "RISK ACCEPTANCE AUTHORITY",
                prompt: "Who is the lowest-level commander authorized to accept this residual risk?",
                options: authorityOptions,
                correctIndex: scenario.correctAuthority.index,
                explanation: scenario.explanations["authority"] ?? ""
            ),
        ]
    }

    // MARK: - Scenario 1: Generator Ops in Occupied Tent

    private static let generatorTent = ORMScenario(
        id: "orm-generator-tent",
        title: "Generator Operations Near Occupied Tent",
        location: "FOB Delta, Southwest Asia — temporary tent city",
        missionContext: "Base bed-down operations supporting a 500-person surge. Tent city is at 95% capacity. Daytime temps exceed 120°F, making AC essential for troop health and welfare.",
        situationBrief: "A 60kW diesel generator powering AC units for four sleeping tents is positioned 8 feet from the nearest occupied tent due to limited real estate. No CO monitors are installed. Personnel report exhaust odor inside the tents during low-wind conditions. The base commander says there is no room to relocate the generator and wants an expedient exhaust ducting solution built from salvaged materials.",
        complicatingFactors: [
            "No CO detection equipment available in theater",
            "No established setback distances posted for temporary power generation",
            "Extreme heat makes tent occupancy without AC a heat casualty risk",
            "Salvaged materials for ducting are untested and may not withstand exhaust temps"
        ],
        hazardOptions: [
            "Carbon monoxide exposure from generator exhaust infiltrating occupied tents",
            "Noise exposure from generator operations during sleep hours",
            "Electrical shock from temporary power distribution wiring",
            "Fire hazard from fuel storage near the generator"
        ],
        correctHazardIndex: 0,
        correctInitialRisk: .extremelyHigh,
        mitigationOptions: [
            "Relocate generator to minimum 25-foot setback, extend power cables, and order CO monitors",
            "Build expedient exhaust ducting from salvaged materials as the commander requested",
            "Issue a memo directing personnel to ventilate tents by opening flaps during generator operations",
            "Reduce generator run time to 6 hours per day and rotate which tents receive AC"
        ],
        correctMitigationIndex: 0,
        correctResidualRisk: .medium,
        correctAuthority: .sqCC,
        recommendedAction: "Immediately relocate generator to establish minimum 25-foot setback from occupied structures. Extend power cables as needed. Requisition CO monitors through emergency supply channels. Establish SOPs for generator positioning at deployed locations referencing AFMAN 32-1068 guidance.",
        explanations: [
            "hazard": "Carbon monoxide is an odorless, colorless gas that can be fatal at high concentrations. Personnel reporting exhaust odor indicates inadequate separation. CO poisoning in sleeping quarters is the most immediately dangerous to life and health (IDLH) hazard in this scenario.",
            "initial-risk": "Extremely High: CO exposure in enclosed sleeping areas can cause death. Personnel are exposed during sleep when they cannot detect symptoms. No monitoring capability means exposure levels are completely unknown. This is an uncontrolled IDLH atmosphere.",
            "mitigation": "Relocation with proper setback is the only control that addresses the root cause. Expedient ducting from untested materials could fail or melt, creating a false sense of safety. Administrative controls (memos, tent flaps) do not reliably prevent CO accumulation. Reducing run time still exposes personnel during operating hours.",
            "residual-risk": "Medium: With proper setback distance, CO exposure risk drops significantly but is not eliminated. Extended power cables introduce some electrical risk, and CO monitors are not yet on hand. The risk is manageable but requires monitoring until detection equipment arrives.",
            "authority": "Squadron/CC: Medium residual risk with a life-safety component requires Sq/CC-level acceptance. The inspector's role is to present the risk assessment — the commander decides whether to accept. Flight/CC authority is insufficient for residual risk that still involves potential CO exposure.",
        ]
    )

    // MARK: - Scenario 2: Expedient Electrical Repairs

    private static let expedientElectrical = ORMScenario(
        id: "orm-expedient-electrical",
        title: "Expedient Electrical Repair on Flightline",
        location: "Contingency airfield, deployed MXS — flightline power distribution",
        missionContext: "Night flying operations supporting ISR missions begin in 4 hours. The flightline lighting system is critical for safe aircraft movement and maintenance operations after dark.",
        situationBrief: "A power distribution panel feeding flightline lighting has a failed 200A breaker. No replacement parts are available in theater — the TCTO parts are 10 days out. A maintenance troop proposes installing jumper wires to bypass the failed breaker and restore power to the lighting circuit. The Wing Commander has expressed that night ops must continue on schedule.",
        complicatingFactors: [
            "No qualified electrician (3E0X1) currently assigned to the deployed location",
            "Replacement breaker is 10 days out through supply channels",
            "Wing/CC has made night operations a top mission priority",
            "The maintenance troop proposing the fix is a 2A6X6 (aircraft electrical) not a facilities electrician"
        ],
        hazardOptions: [
            "Electrical fire or arc flash from bypassing overcurrent protection on a 200A circuit",
            "Trip hazard from temporary lighting cables across the flightline",
            "Foreign Object Damage from repair debris left near the flight line",
            "Noise exposure from increased night operations tempo"
        ],
        correctHazardIndex: 0,
        correctInitialRisk: .high,
        mitigationOptions: [
            "Deploy portable light carts as temporary flightline lighting until breaker replacement arrives",
            "Allow the bypass with jumper wires but post a fire watch at the panel",
            "Reduce flightline operations to daylight hours only until repair is complete",
            "Have the aircraft electrician install the bypass under supervision of the maintenance officer"
        ],
        correctMitigationIndex: 0,
        correctResidualRisk: .low,
        correctAuthority: .flightCC,
        recommendedAction: "Deploy portable light carts from vehicle maintenance or CE assets for temporary flightline illumination. Maintain the damaged panel de-energized and locked out. Expedite breaker replacement through emergency supply request. Document the temporary lighting plan and brief all affected maintenance personnel.",
        explanations: [
            "hazard": "Bypassing a 200A breaker removes overcurrent protection from the entire downstream circuit. An arc flash at 200A can produce temperatures exceeding 35,000°F and can be fatal. This is the primary hazard — not the inconvenience of lost lighting, which has alternative solutions.",
            "initial-risk": "High: Arc flash and electrical fire risk from an unprotected 200A circuit is severe. The work would be performed by unqualified personnel (aircraft electrician, not facilities electrician), further increasing the probability of error. However, it is not Extremely High because the hazard only exists if the bypass is actually installed.",
            "mitigation": "Portable light carts eliminate the need for the expedient repair entirely. The mission continues (night ops supported) without introducing electrical hazards. This is a classic example of finding an alternative that satisfies both safety and mission requirements. A fire watch does not prevent arc flash. Canceling night ops may be unnecessary if alternatives exist.",
            "residual-risk": "Low: Portable lighting is a proven, safe alternative. The damaged panel remains de-energized. Residual risk is limited to normal portable equipment operations (cable routing, fuel for generators on light carts). These are routine, manageable hazards.",
            "authority": "Flight/CC: With low residual risk and a straightforward mitigation plan, Flight/CC-level acceptance is appropriate. The inspector provided the alternative that avoided the high-risk bypass — this is how safety professionals add value without being mission stoppers.",
        ]
    )

    // MARK: - Scenario 3: Damaged Temporary Structure

    private static let damagedShelter = ORMScenario(
        id: "orm-temp-structure",
        title: "Damaged Temporary Aircraft Shelter",
        location: "Bare base, Southwest Asia — temporary aircraft maintenance shelters",
        missionContext: "Aircraft maintenance operations on six F-16s require covered workspace. The shelters protect aircraft from sand/UV damage and provide shade for maintenance crews in extreme heat.",
        situationBrief: "A fabric tensioned aircraft shelter is showing stress tears along two main support seams after a severe sandstorm. The tears are 2-3 feet long and growing. No structural engineer is available — next visit is 14 days out. Maintenance crews continue working beneath the shelter. The Operations Group Commander wants to keep aircraft sheltered to prevent sand damage to avionics and UV degradation of canopy coatings.",
        complicatingFactors: [
            "No structural engineer available for assessment for 14 days",
            "Shelter is the only covered maintenance workspace at this location",
            "Extreme heat (115°F+) makes unsheltered maintenance a heat casualty risk",
            "Fabric tensioned structures can fail catastrophically without warning when seams tear"
        ],
        hazardOptions: [
            "Structural collapse of the fabric shelter onto personnel and aircraft",
            "Heat stress from reduced shade if the shelter is removed",
            "Sand/FOD ingestion damage to aircraft engines from unsheltered parking",
            "UV exposure risk for maintenance crews working without shade"
        ],
        correctHazardIndex: 0,
        correctInitialRisk: .high,
        mitigationOptions: [
            "Evacuate shelter, establish exclusion zone, relocate maintenance to alternate shade structures or work during cooler hours",
            "Install temporary fabric patches over the tears and continue operations with hourly visual inspections",
            "Reduce the number of personnel under the shelter to essential workers only",
            "Lower the tension on the shelter fabric to reduce stress on the torn seams"
        ],
        correctMitigationIndex: 0,
        correctResidualRisk: .medium,
        correctAuthority: .sqCC,
        recommendedAction: "Evacuate the damaged shelter immediately and establish an exclusion zone. Move aircraft to open parking. Establish an alternate work schedule utilizing cooler hours (early morning, evening, night). Deploy portable shade structures for maintenance spots. Request expedited structural engineering assessment. Document shelter condition with photos for engineering review.",
        explanations: [
            "hazard": "Fabric tensioned structures under load can fail suddenly and catastrophically when primary seams tear. A collapsing shelter can trap or crush personnel and damage aircraft. Growing tears indicate progressive failure — the structure is getting weaker, not stabilizing. This is the immediate life-safety hazard.",
            "initial-risk": "High: A structural collapse could cause serious injury or death (high severity). The tears are actively growing, indicating failure is progressing (moderate-to-high probability). However, it is not Extremely High because collapse is not imminent — the structure is still standing and personnel can be evacuated before it progresses further.",
            "mitigation": "Evacuation eliminates personnel exposure to the collapse hazard. Alternate work schedules and portable shade address the heat concern. Patching is not a reliable fix for structural fabric under tension — patches may not hold and give false confidence. Reducing personnel still exposes some workers. Lowering tension may accelerate the tear pattern unpredictably.",
            "residual-risk": "Medium: Personnel are no longer under the damaged structure, eliminating collapse risk to people. However, working in extreme heat with modified schedules introduces heat stress risk. Aircraft are exposed to environmental damage. Both are manageable but require monitoring and adjustment. This is a legitimate operational impact that the commander must weigh.",
            "authority": "Squadron/CC: Medium residual risk with significant mission impact (modified maintenance schedule, exposed aircraft) requires Sq/CC acceptance. The commander needs to balance maintenance tempo against the 14-day wait for engineering. This is a decision above Flight/CC level due to the squadron-wide operational impact.",
        ]
    )

    // MARK: - Scenario 4: Incomplete PPE for HAZMAT Response

    private static let incompletePPE = ORMScenario(
        id: "orm-incomplete-ppe",
        title: "HAZMAT Response with Degraded PPE",
        location: "AOR transit hub — fuel storage and distribution point",
        missionContext: "The fuel storage point serves as the primary JP-8 distribution hub for three forward locations. A spill near the tent city threatens to contaminate a drainage path leading to the base water treatment intake.",
        situationBrief: "A JP-8 fuel spill of approximately 200 gallons has occurred near the tent city perimeter from a failed fuel bladder connection. The HAZMAT response team has Level C protective suits available but their respirator cartridges expired 3 months ago. Replacement cartridges are 5 days out through supply. The base commander wants immediate cleanup before fuel migrates through the drainage channel to the water treatment intake 400 meters away.",
        complicatingFactors: [
            "Respirator cartridges expired 3 months ago — effectiveness uncertain",
            "Open-air environment reduces but does not eliminate inhalation risk",
            "Fuel migration toward water source creates environmental contamination timeline pressure",
            "No HAZMAT contractor available at this deployed location"
        ],
        hazardOptions: [
            "Inhalation exposure to JP-8 vapors during cleanup with expired respiratory protection",
            "Skin contact with JP-8 during manual cleanup operations",
            "Environmental contamination of the base water supply from fuel migration",
            "Fire/explosion risk from JP-8 vapors near the tent city"
        ],
        correctHazardIndex: 0,
        correctInitialRisk: .high,
        mitigationOptions: [
            "Contain the spill with available berming materials to halt migration, then clean up in open air with supplied-air or fresh cartridges only",
            "Proceed with cleanup using expired cartridges since the open-air environment reduces vapor concentration",
            "Wait 5 days for replacement cartridges while monitoring fuel migration with daily inspections",
            "Have non-HAZMAT personnel use sorbent pads to clean the spill wearing only standard work gloves"
        ],
        correctMitigationIndex: 0,
        correctResidualRisk: .medium,
        correctAuthority: .sqCC,
        recommendedAction: "Immediately contain the spill perimeter using earth berms, sandbags, or available sorbent booms to stop migration toward the water intake. Do not proceed with personnel cleanup until proper respiratory protection is available — request emergency supply or borrow from adjacent units. Monitor fuel migration daily. If water supply contamination becomes imminent, coordinate with CE for emergency environmental response. Document all actions for environmental compliance reporting.",
        explanations: [
            "hazard": "JP-8 vapor inhalation is the primary health hazard during cleanup operations. Expired respirator cartridges may have degraded activated carbon that does not adequately filter organic vapors. Relying on expired PPE creates a false sense of protection. While skin contact and environmental contamination are also concerns, unprotected inhalation exposure is the most immediate threat to cleanup personnel.",
            "initial-risk": "High: JP-8 is a known health hazard with both acute and chronic effects. Cleanup activities increase vapor exposure through agitation of the fuel. The HAZMAT team's only respiratory protection is compromised. However, this is an outdoor spill (not a confined space), which provides some natural ventilation, keeping it below Extremely High.",
            "mitigation": "Containment addresses the environmental timeline pressure without exposing personnel to inhalation hazards. Earth berms and sorbent booms can be improvised from available materials. This buys time to obtain proper PPE. Using expired cartridges violates respiratory protection program requirements and puts workers at risk. Waiting without containment allows contamination to spread. Using untrained/unprotected personnel is worse than either option.",
            "residual-risk": "Medium: The spill is contained but not cleaned up. Environmental contamination risk is reduced but not eliminated — heavy rain could overwhelm berming. Personnel are not exposed to vapor hazards. The situation requires ongoing monitoring and eventual cleanup with proper PPE. This is a manageable interim state.",
            "authority": "Squadron/CC: Medium residual risk with environmental compliance implications and potential water supply impact requires Sq/CC-level acceptance. The commander must weigh the timeline for proper PPE arrival against the environmental containment plan. This decision has implications beyond the immediate unit.",
        ]
    )

    // MARK: - Scenario 5: Host-Nation Worker Safety Gaps

    private static let hostNationWorkers = ORMScenario(
        id: "orm-host-nation",
        title: "Host-Nation Worker Safety Compliance Gaps",
        location: "Cooperative Security Location, West Africa — base perimeter construction",
        missionContext: "Host-nation contractors are building a perimeter security wall as part of a base defense improvement project. The project is 60% complete with a 30-day deadline. US personnel work in adjacent areas and transit the construction zone daily.",
        situationBrief: "Host-nation construction workers building an 8-foot perimeter wall are working at heights up to 18 feet on damaged scaffolding without fall protection, hard hats, or high-visibility clothing. The construction contract specifies that host-nation labor laws apply, and the host nation has no fall protection requirement. However, US personnel transit the area daily for access to the motor pool, and falling debris has already struck near a US vehicle. The contracting officer says enforcing US standards would breach the contract and delay the project.",
        complicatingFactors: [
            "Contract language specifies host-nation labor laws govern worker safety",
            "Host nation has no fall protection standard for construction work",
            "DAFI 91-202 states the installation commander is responsible for safety of all personnel on the installation",
            "Enforcing US standards could trigger a contract dispute and delay a force protection priority"
        ],
        hazardOptions: [
            "Fall hazards to host-nation workers and struck-by hazards to US personnel from falling debris",
            "Contract dispute risk if US safety standards are imposed on host-nation workers",
            "Project delay risk if construction is halted for safety improvements",
            "Political/diplomatic friction with the host nation over labor law differences"
        ],
        correctHazardIndex: 0,
        correctInitialRisk: .high,
        mitigationOptions: [
            "Establish exclusion zones for US personnel, require hard hats in transit areas, and work with contracting to add fall protection to the contract scope",
            "Accept host-nation standards as written in the contract and post warning signs in English",
            "Halt all construction until the contract is renegotiated to include US fall protection standards",
            "Provide US PPE to host-nation workers but do not require them to use it"
        ],
        correctMitigationIndex: 0,
        correctResidualRisk: .medium,
        correctAuthority: .gpCC,
        recommendedAction: "Immediately establish exclusion zones and overhead protection for US personnel transit areas. Coordinate with the contracting officer to modify the contract to include minimum fall protection and PPE requirements — frame as force protection and liability mitigation. Brief the installation commander on DAFI 91-202 responsibilities. Document the hazard assessment and all coordination for legal protection. Engage the host-nation project supervisor on voluntary safety improvements as a goodwill measure.",
        explanations: [
            "hazard": "The primary hazard is physical — falls from 18 feet are frequently fatal, and falling debris has already endangered US personnel. Contract disputes and diplomatic friction are operational concerns but not safety hazards. The inspector's job is to identify and assess the safety risk, not the political risk.",
            "initial-risk": "High: Falls from 18 feet without protection have high fatality potential (OSHA data shows falls as the #1 cause of construction deaths). Damaged scaffolding increases the probability. US personnel have already been exposed to falling debris. However, this is not Extremely High because the exposure is intermittent (transit) rather than continuous (working at height).",
            "mitigation": "A layered approach addresses both immediate US personnel safety (exclusion zones, hard hats) and the underlying hazard (contract modification). This respects the contract framework while working within it to improve conditions. Simply accepting the status quo ignores the installation commander's DAFI 91-202 responsibility. Halting construction entirely may be disproportionate and damages the relationship. Providing but not requiring PPE is ineffective.",
            "residual-risk": "Medium: US personnel exposure is controlled through exclusion zones and PPE. Host-nation workers remain at elevated risk until contract modifications take effect. The overall risk posture is improved but not fully resolved. Ongoing monitoring is required as contract negotiations proceed.",
            "authority": "Group/CC or above: This decision involves contract implications, host-nation relations, SOFA considerations, and installation-level safety policy. It exceeds Sq/CC authority because it affects base-wide operations, involves legal/contractual issues, and has diplomatic dimensions. The Group/CC (or installation commander) must weigh safety, mission, and political factors together.",
        ]
    )

    // MARK: - Scenario 6: Mission-Pressure Night Movement

    private static let nightMovement = ORMScenario(
        id: "orm-night-ops-pressure",
        title: "Mission-Pressure Night Convoy Movement",
        location: "Forward operating location — ISR operations staging area",
        missionContext: "An ISR mission package requires repositioning to a secondary staging area before dawn to support a time-critical intelligence collection window. The movement involves 8 vehicles over 12 km of unimproved roads.",
        situationBrief: "Fog has reduced visibility to approximately 100 meters. The convoy route passes through a base expansion area with unmarked construction hazards including trenches, material staging, and heavy equipment. The Operations Group Commander wants to begin movement immediately because the intelligence window opens at sunrise and the package must be set up 2 hours before. Vehicle operators have been on duty for 16 hours. Blackout drive is not required — full headlights are authorized.",
        complicatingFactors: [
            "Time-critical intelligence window cannot be shifted — it is tied to a satellite pass",
            "Vehicle operators at 16 hours of continuous duty, approaching fatigue risk thresholds",
            "Convoy route has unmarked construction hazards with no recent route reconnaissance",
            "Fog/visibility below 200m increases vehicle accident risk on unimproved roads"
        ],
        hazardOptions: [
            "Vehicle accident from reduced visibility, fatigue, and unmarked road hazards combined",
            "Intelligence collection failure if the convoy is delayed past the mission window",
            "Equipment damage from unimproved road conditions at night",
            "Security risk from vehicle movement on poorly lit routes"
        ],
        correctHazardIndex: 0,
        correctInitialRisk: .extremelyHigh,
        mitigationOptions: [
            "Delay 2 hours for improved visibility, swap fatigued drivers, and send a route recon vehicle ahead of the convoy",
            "Proceed immediately at reduced speed with full headlights and increased vehicle spacing",
            "Send only the minimum essential vehicles now and delay the rest until dawn",
            "Proceed on schedule but assign a ground guide to walk ahead of the lead vehicle"
        ],
        correctMitigationIndex: 0,
        correctResidualRisk: .medium,
        correctAuthority: .gpCC,
        recommendedAction: "Recommend a 2-hour delay to allow fog dissipation and driver swap. Send a route reconnaissance vehicle 30 minutes ahead to mark hazards and verify route conditions. Brief the Ops Group Commander that a 2-hour delay still allows 30 minutes of setup time before the window opens. If the delay is unacceptable, present the risk assessment for Gp/CC acceptance. Ensure the risk decision and rationale are documented regardless of outcome.",
        explanations: [
            "hazard": "The combination of reduced visibility (fog), fatigued operators (16 hours), and unmarked road hazards creates a compounding vehicle accident risk. Each factor alone is manageable; together they create a high-probability, high-severity scenario. Intelligence window timing is a mission concern, not a safety hazard. The inspector must clearly separate mission impact from physical risk.",
            "initial-risk": "Extremely High: Three independent risk factors are compounding simultaneously — any one of them (fog, fatigue, or unmarked hazards) would elevate the risk. Together, they create conditions where a serious vehicle accident is highly probable. Fatigued drivers have reaction times comparable to impaired drivers. Unmarked trenches on unimproved roads at night in fog could be catastrophic for vehicle occupants.",
            "mitigation": "A short delay addresses all three risk factors: fog improves naturally over time, fresh drivers eliminate fatigue, and route recon identifies hazards. This plan still supports the mission — the math works (2-hour delay + 30 minutes setup still beats sunrise). Proceeding at reduced speed does not address fatigue or unmarked hazards. Splitting the convoy creates two smaller problems instead of one. A ground guide in fog is marginally effective and puts that person at risk.",
            "residual-risk": "Medium: A 2-hour delay significantly improves visibility conditions. Fresh drivers are alert and capable. Route recon identifies and marks major hazards. However, residual risk remains because it is still a night convoy on unimproved roads. Fog may not fully clear. Some hazards may be missed by recon. This is a manageable risk level that allows the mission to proceed.",
            "authority": "Group/CC or above: Even with mitigations, this involves accepting risk to a multi-vehicle convoy in degraded conditions to meet an operational timeline. The decision to delay or proceed affects group-level mission execution. The Ops Group Commander, who is pushing for immediate movement, may not be the appropriate risk acceptance authority for their own operation — the safety professional should ensure the right level of command is making this decision.",
        ]
    )
}
