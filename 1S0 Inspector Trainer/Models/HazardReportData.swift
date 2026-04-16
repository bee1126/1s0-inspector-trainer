import SwiftUI

// MARK: - Enums

enum HazardSeverity: String, CaseIterable, Identifiable {
    case catastrophic = "I \u{2014} Catastrophic"
    case critical     = "II \u{2014} Critical"
    case significant  = "III \u{2014} Significant"
    case minor        = "IV \u{2014} Minor"

    var id: String { rawValue }
    var row: Int {
        switch self {
        case .catastrophic: return 0
        case .critical:     return 1
        case .significant:  return 2
        case .minor:        return 3
        }
    }

    var short: String {
        switch self {
        case .catastrophic: return "I"
        case .critical:     return "II"
        case .significant:  return "III"
        case .minor:        return "IV"
        }
    }
}

enum HazardProbability: String, CaseIterable, Identifiable {
    case frequent   = "A \u{2014} Frequent"
    case likely     = "B \u{2014} Likely"
    case occasional = "C \u{2014} Occasional"
    case rarely     = "D \u{2014} Rarely"

    var id: String { rawValue }
    var col: Int {
        switch self {
        case .frequent:   return 0
        case .likely:     return 1
        case .occasional: return 2
        case .rarely:     return 3
        }
    }

    var short: String {
        switch self {
        case .frequent:   return "A"
        case .likely:     return "B"
        case .occasional: return "C"
        case .rarely:     return "D"
        }
    }
}

enum InvestigationTimeline: String, CaseIterable, Identifiable {
    case oneDay   = "1 Duty Day (Critical)"
    case threeDays = "3 Workdays (Serious)"
    case tenDays  = "10 Workdays (Lesser)"

    var id: String { rawValue }
}

enum HazardDiscipline: String, CaseIterable, Identifiable {
    case safety = "Safety"
    case fire   = "Fire"
    case health = "Health"

    var id: String { rawValue }
}

// MARK: - Scenario

struct HazardReportScenario: Identifiable {
    let id: String
    let title: String
    let reporterName: String
    let reporterOrg: String
    let dateReported: String
    let location: String
    let hazardDescription: String
    let hazardType: String
    let additionalDetails: String

    let correctSeverity: HazardSeverity
    let correctProbability: HazardProbability
    let correctTimeline: InvestigationTimeline
    let correctDiscipline: HazardDiscipline

    let interimControlOptions: [String]
    let correctInterimControlIndex: Int

    let correctiveAction: String
    let explanations: [String: String]

    var correctRAC: Int {
        HazardReportBank.racMatrix[correctSeverity.row][correctProbability.col]
    }
}

// MARK: - Processing Step

struct HazardProcessingStep: Identifiable {
    let id: String
    let title: String
    let prompt: String
    let options: [String]
    let correctIndex: Int
    let explanation: String
}

// MARK: - Bank

enum HazardReportBank {

    // MARK: - RAC Matrix

    /// RAC Matrix: rows = Severity (I-IV), cols = Probability (A-D)
    static let racMatrix: [[Int]] = [
        // A  B  C  D
        [1, 1, 2, 3],  // I   Catastrophic
        [1, 2, 3, 4],  // II  Critical
        [2, 3, 4, 5],  // III Significant
        [3, 4, 5, 5],  // IV  Minor
    ]

    static func racColor(_ rac: Int) -> Color {
        switch rac {
        case 1: return AppTheme.danger
        case 2: return Color(red: 1.0, green: 0.45, blue: 0.0)
        case 3: return AppTheme.accent
        case 4: return AppTheme.info
        case 5: return AppTheme.primary
        default: return AppTheme.muted
        }
    }

    // MARK: - Scenarios

    static let allScenarios: [HazardReportScenario] = [
        exposedWiring,
        unmarkedDrums,
        floorOpening,
        excessiveNoise,
        defectiveForklift,
    ]

    // MARK: - Step Builders

    static func steps(for scenario: HazardReportScenario) -> [HazardProcessingStep] {
        let severityOptions = HazardSeverity.allCases.map(\.rawValue)
        let probabilityOptions = HazardProbability.allCases.map(\.rawValue)
        let racOptions = (1...5).map { "RAC \($0)" }
        let timelineOptions = InvestigationTimeline.allCases.map(\.rawValue)
        let disciplineOptions = HazardDiscipline.allCases.map(\.rawValue)

        return [
            HazardProcessingStep(
                id: "severity",
                title: "ASSESS SEVERITY",
                prompt: "Based on the hazard description, what is the worst credible outcome?",
                options: severityOptions,
                correctIndex: scenario.correctSeverity.row,
                explanation: scenario.explanations["severity"] ?? ""
            ),
            HazardProcessingStep(
                id: "probability",
                title: "ASSESS PROBABILITY",
                prompt: "How likely is this hazard to cause harm if not corrected?",
                options: probabilityOptions,
                correctIndex: scenario.correctProbability.col,
                explanation: scenario.explanations["probability"] ?? ""
            ),
            HazardProcessingStep(
                id: "rac",
                title: "ASSIGN RAC",
                prompt: "Using the severity and probability you assessed, assign the Risk Assessment Code.",
                options: racOptions,
                correctIndex: scenario.correctRAC - 1,
                explanation: scenario.explanations["rac"] ?? ""
            ),
            HazardProcessingStep(
                id: "timeline",
                title: "INVESTIGATION TIMELINE",
                prompt: "Based on the RAC and hazard severity, what is the required investigation timeline?",
                options: timelineOptions,
                correctIndex: InvestigationTimeline.allCases.firstIndex(of: scenario.correctTimeline) ?? 0,
                explanation: scenario.explanations["timeline"] ?? ""
            ),
            HazardProcessingStep(
                id: "discipline",
                title: "ASSIGN DISCIPLINE",
                prompt: "Which safety discipline should investigate this hazard?",
                options: disciplineOptions,
                correctIndex: HazardDiscipline.allCases.firstIndex(of: scenario.correctDiscipline) ?? 0,
                explanation: scenario.explanations["discipline"] ?? ""
            ),
            HazardProcessingStep(
                id: "interim",
                title: "INTERIM CONTROLS",
                prompt: "What immediate interim control should be implemented while corrective action is developed?",
                options: scenario.interimControlOptions,
                correctIndex: scenario.correctInterimControlIndex,
                explanation: scenario.explanations["interim"] ?? ""
            ),
        ]
    }

    // MARK: - Scenario 1: Exposed Electrical Wiring

    private static let exposedWiring = HazardReportScenario(
        id: "hr-exposed-wiring",
        title: "Exposed Electrical Wiring in Maintenance Hangar",
        reporterName: "SSgt Martinez",
        reporterOrg: "49 CES/CEFIRE",
        dateReported: "12 Mar 2026",
        location: "Bldg 302, Aircraft Maintenance Hangar Bay 2",
        hazardDescription: "Exposed wiring found running across ceiling near a water pipe with visible condensation. Wire insulation is cracked and bare conductors are visible. Area is occupied daily by maintenance personnel performing aircraft servicing operations.",
        hazardType: "Electrical",
        additionalDetails: "No GFCI protection on the circuit. The wiring appears to be an unapproved field modification, not reflected on facility drawings. Condensation from the adjacent water pipe creates a wet environment increasing shock risk.",
        correctSeverity: .critical,
        correctProbability: .likely,
        correctTimeline: .threeDays,
        correctDiscipline: .safety,
        interimControlOptions: [
            "De-energize the circuit and barricade the area with warning signs",
            "Post a written notice on the break room bulletin board",
            "Place a bucket under the condensation drip and continue operations",
            "Schedule an electrician for next month's maintenance window"
        ],
        correctInterimControlIndex: 0,
        correctiveAction: "Replace wiring to NEC standards, install GFCI protection, verify with qualified electrician, update facility drawings.",
        explanations: [
            "severity": "Severity II (Critical): Exposed 480V conductors near water could cause electrocution resulting in permanent disability or death. While not guaranteed fatal (which would be Cat I), the combination of bare conductors and moisture creates a serious shock hazard.",
            "probability": "Probability B (Likely): Personnel occupy this area daily and the hazard is uncontrolled. Without intervention, contact is probable during normal maintenance operations.",
            "rac": "RAC 2: Severity II \u{00D7} Probability B = RAC 2 on the matrix. This is a serious risk requiring prompt attention.",
            "timeline": "3 Workdays: RAC 2 hazards require investigation within 3 workdays per DAFI 91-202. This is not an immediate life threat (which would require 1 duty day) but is serious enough to demand prompt action.",
            "discipline": "Safety: Electrical hazards in facility infrastructure fall under Occupational Safety. Health investigates exposure-based hazards (noise, chemicals); Fire investigates fire protection systems.",
            "interim": "De-energize and barricade immediately. This removes the hazard from personnel while corrective action is developed. Simply posting a notice or scheduling future work leaves the hazard active. Collecting condensation does not address the electrical risk.",
        ]
    )

    // MARK: - Scenario 2: Unmarked Chemical Drums

    private static let unmarkedDrums = HazardReportScenario(
        id: "hr-unmarked-drums",
        title: "Unmarked Chemical Storage Drums",
        reporterName: "TSgt Williams",
        reporterOrg: "49 AMDS/SGPB",
        dateReported: "10 Mar 2026",
        location: "Bldg 1150, POL Storage Yard",
        hazardDescription: "Three 55-gallon drums found in outdoor storage area without labels, placards, or SDS availability. Drums show signs of corrosion and one has a visible residue leak at the bung. Workers have been handling drums without PPE during inventory.",
        hazardType: "Chemical",
        additionalDetails: "No secondary containment in place. The drums were transferred from a deactivated unit six months ago with no documentation. Contents are completely unknown. Soil staining visible beneath the leaking drum.",
        correctSeverity: .critical,
        correctProbability: .occasional,
        correctTimeline: .tenDays,
        correctDiscipline: .health,
        interimControlOptions: [
            "Isolate drums, prohibit handling until contents identified, install secondary containment",
            "Label the drums as 'Unknown' and return them to the storage rack",
            "Have workers wear standard leather gloves while continuing inventory",
            "Move drums to a different outdoor location away from foot traffic"
        ],
        correctInterimControlIndex: 0,
        correctiveAction: "Sample and identify drum contents, properly label per OSHA HazCom, establish SDS file, provide appropriate PPE and hazard training, remediate soil contamination.",
        explanations: [
            "severity": "Severity II (Critical): Unknown chemical contents could include carcinogens, corrosives, or acutely toxic substances. Skin contact or inhalation during handling without PPE could cause permanent partial disability or serious illness.",
            "probability": "Probability C (Occasional): Workers handle drums periodically during inventory, not continuously. The exposure is intermittent but real. Frequent (A) would apply if workers were continuously handling these drums.",
            "rac": "RAC 3: Severity II \u{00D7} Probability C = RAC 3. This is a moderate risk. The unknown nature of the contents is the key concern \u{2014} once identified, the RAC may be adjusted.",
            "timeline": "10 Workdays: RAC 3 hazards are classified as lesser conditions with a 10-workday investigation timeline. The drums are now isolated, so there is no immediate exposure pathway.",
            "discipline": "Health: Chemical exposure hazards fall under Bioenvironmental Engineering / Health. They have the expertise and equipment to identify unknown substances, assess exposure risk, and recommend appropriate controls.",
            "interim": "Isolate and prohibit handling immediately. Unknown chemicals must be treated as the worst case until identified. Simply re-labeling as 'Unknown' or moving the drums does not reduce risk. Leather gloves are inappropriate for unknown chemical contact.",
        ]
    )

    // MARK: - Scenario 3: Unguarded Floor Opening

    private static let floorOpening = HazardReportScenario(
        id: "hr-floor-opening",
        title: "Unguarded Floor Opening on Second Level",
        reporterName: "A1C Cooper",
        reporterOrg: "49 CES/CECI",
        dateReported: "14 Mar 2026",
        location: "Bldg 440, Communications Equipment Room, 2nd Floor",
        hazardDescription: "A 4-foot by 4-foot floor opening created for cable routing has no guardrails, covers, or warning signs. The opening drops 12 feet to the first floor. Personnel regularly transit the area to access server racks.",
        hazardType: "Fall",
        additionalDetails: "Lighting in the area is poor \u{2014} only one of three overhead fixtures is working. The opening was cut three weeks ago by a contractor who has since left the base. No fall protection plan was filed with the safety office.",
        correctSeverity: .catastrophic,
        correctProbability: .occasional,
        correctTimeline: .threeDays,
        correctDiscipline: .safety,
        interimControlOptions: [
            "Install temporary guardrails and warning signs immediately, improve lighting",
            "Place orange traffic cones around the opening",
            "Send an email to all building occupants about the hazard",
            "Restrict the area to only personnel who know about the opening"
        ],
        correctInterimControlIndex: 0,
        correctiveAction: "Install permanent standard guardrail system (42-inch top rail, mid-rail, toeboard) per DAFMAN 91-203 Ch. 7 and 29 CFR 1910.23. Repair lighting. Review contractor oversight procedures.",
        explanations: [
            "severity": "Severity I (Catastrophic): A 12-foot unprotected fall can result in death or permanent total disability. This meets the threshold for the highest severity category.",
            "probability": "Probability C (Occasional): Personnel transit the area regularly but the opening is in a known location. The risk increases significantly with poor lighting. Frequent (A) would apply if the opening were in a high-traffic blind path.",
            "rac": "RAC 2: Severity I \u{00D7} Probability C = RAC 2. Even though the probability is only occasional, the catastrophic severity drives this to a serious risk level.",
            "timeline": "3 Workdays: RAC 2 is a serious condition requiring investigation within 3 workdays. Although this is a high-severity hazard, interim controls (guardrails, signs) can be implemented immediately to prevent exposure while investigation proceeds.",
            "discipline": "Safety: Fall protection hazards are core Occupational Safety. Walking-working surfaces, guardrail standards, and fall protection requirements are defined in DAFMAN 91-203 Ch. 7 and Ch. 13.",
            "interim": "Temporary guardrails and warning signs are the correct interim control. Traffic cones are not an adequate barrier for a fall hazard. Emails and verbal warnings are administrative controls that do not physically prevent a fall. Restricting access is unreliable without physical barriers.",
        ]
    )

    // MARK: - Scenario 4: Excessive Noise

    private static let excessiveNoise = HazardReportScenario(
        id: "hr-excessive-noise",
        title: "Excessive Noise Exposure in Engine Test Cell",
        reporterName: "MSgt Thompson",
        reporterOrg: "49 MXS/MXMTA",
        dateReported: "8 Mar 2026",
        location: "Bldg 999, Jet Engine Test Cell",
        hazardDescription: "Sound level measurements show 115 dBA during engine run-ups. Personnel are entering the cell during operations wearing only single hearing protection (foam earplugs). Warning signs at the cell entrance are faded and unreadable.",
        hazardType: "Noise / Health",
        additionalDetails: "Area monitoring records are 18 months old and may not reflect current conditions. Double hearing protection is required above 104 dBA TWA per DAFI 48-127 but is not being enforced. Engine runs occur daily.",
        correctSeverity: .significant,
        correctProbability: .frequent,
        correctTimeline: .threeDays,
        correctDiscipline: .health,
        interimControlOptions: [
            "Require double hearing protection immediately, restrict cell entry during runs to essential personnel",
            "Order new warning signs and wait for installation",
            "Provide workers with higher-NRR earplugs as a single solution",
            "Reduce engine run time to 30-minute intervals"
        ],
        correctInterimControlIndex: 0,
        correctiveAction: "Update area monitoring per DAFI 48-127, replace warning signage, enforce double hearing protection program, evaluate engineering controls to reduce exposure, update hearing conservation program records.",
        explanations: [
            "severity": "Severity III (Significant): Chronic noise exposure at 115 dBA causes permanent hearing loss (noise-induced hearing loss). This is serious but not immediately fatal or totally disabling. It results in permanent partial disability over time.",
            "probability": "Probability A (Frequent): Engine runs happen daily and workers enter the cell during operations. This is a routine, repeated exposure \u{2014} the definition of frequent.",
            "rac": "RAC 2: Severity III \u{00D7} Probability A = RAC 2. The high frequency of exposure elevates what might seem like a moderate severity into a serious risk requiring prompt action.",
            "timeline": "3 Workdays: RAC 2 requires investigation within 3 workdays. Daily exposure with inadequate protection demands prompt but not emergency action since the hazard is chronic rather than immediately life-threatening.",
            "discipline": "Health: Noise exposure and hearing conservation fall under Bioenvironmental Engineering / Health. They own the monitoring program, audiometric testing, and exposure assessments per DAFI 48-127.",
            "interim": "Require double protection and restrict access immediately. Simply ordering new signs does nothing for current exposure. Higher-NRR single protection still falls short at 115 dBA. Reducing run time may not be operationally feasible and does not eliminate the hazard.",
        ]
    )

    // MARK: - Scenario 5: Defective Forklift

    private static let defectiveForklift = HazardReportScenario(
        id: "hr-defective-forklift",
        title: "Defective Forklift with Disabled Safety Features",
        reporterName: "SrA Patel",
        reporterOrg: "49 LRS/LGRDDO",
        dateReported: "11 Mar 2026",
        location: "Bldg 210, Base Supply Warehouse",
        hazardDescription: "A 5,000 lb forklift was found operating with a non-functional backup alarm, inoperable headlights, and the overhead guard removed for 'clearance.' The operator's certification expired 6 months ago. Load capacity plate is missing.",
        hazardType: "Machinery",
        additionalDetails: "The warehouse has narrow aisles with limited visibility at intersections. Pedestrian traffic is heavy during shift changes. The forklift is used daily for receiving and stocking operations. Two near-miss incidents with pedestrians were reported informally last month.",
        correctSeverity: .critical,
        correctProbability: .likely,
        correctTimeline: .threeDays,
        correctDiscipline: .safety,
        interimControlOptions: [
            "Remove forklift from service immediately (red-tag), suspend operator privileges",
            "Assign a spotter to walk ahead of the forklift during operations",
            "Restrict forklift use to daylight hours only",
            "Post a reminder about forklift safety rules in the break room"
        ],
        correctInterimControlIndex: 0,
        correctiveAction: "Repair all safety features to manufacturer specs, replace overhead guard and capacity plate, retrain and re-certify operator per DAFMAN 91-203 Ch. 12, review pre-use inspection program.",
        explanations: [
            "severity": "Severity II (Critical): A 5,000 lb forklift with disabled safety features (no backup alarm, no lights, no overhead guard) could cause struck-by or crush injuries resulting in death or permanent disability. The missing overhead guard is especially dangerous \u{2014} falling loads could kill the operator.",
            "probability": "Probability B (Likely): Daily use in a high-traffic warehouse with multiple safety deficiencies and an uncertified operator. Two recent near-misses confirm the probability is not theoretical. Without correction, a serious incident is expected.",
            "rac": "RAC 2: Severity II \u{00D7} Probability B = RAC 2. Multiple compounding deficiencies (equipment + training + procedural) make this a serious risk.",
            "timeline": "3 Workdays: RAC 2 requires investigation within 3 workdays per DAFI 91-202. The forklift is now removed from service, so the immediate risk is controlled while the investigation determines root causes.",
            "discipline": "Safety: Powered industrial truck hazards fall under Occupational Safety per DAFMAN 91-203 Ch. 12. Equipment deficiencies, operator certification, and material handling procedures are core safety program elements.",
            "interim": "Red-tag and remove from service immediately. This eliminates the hazard at the source. A spotter reduces risk but does not fix the equipment deficiencies. Daylight-only restrictions do not address the disabled alarm or missing guard. Break room postings are ineffective against equipment failures.",
        ]
    )
}
