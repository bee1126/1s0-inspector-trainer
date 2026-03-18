import Foundation

struct PPEItem: Identifiable, Hashable {
    let id: String
    let name: String
    let sfSymbol: String
}

struct PPEScenario: Identifiable {
    let id: String
    let title: String
    let location: String
    let description: String
    let hazards: [String]
    let requiredItemIds: Set<String>
    let availableItemIds: [String]
    let debriefNotes: [String: String]
}

enum PPELoadoutBank {

    // MARK: - PPE Items

    static let allItems: [String: PPEItem] = Dictionary(uniqueKeysWithValues: itemList.map { ($0.id, $0) })

    static let itemList: [PPEItem] = [
        PPEItem(id: "hard-hat", name: "Hard Hat (Class E)", sfSymbol: "shield.checkered"),
        PPEItem(id: "safety-glasses", name: "Safety Glasses", sfSymbol: "eyeglasses"),
        PPEItem(id: "chemical-goggles", name: "Chemical Splash Goggles", sfSymbol: "dot.circle.and.hand.point.up.left.fill"),
        PPEItem(id: "face-shield", name: "Face Shield", sfSymbol: "theatermasks.fill"),
        PPEItem(id: "arc-face-shield", name: "Arc-Rated Face Shield", sfSymbol: "bolt.shield.fill"),
        PPEItem(id: "earplugs", name: "Earplugs", sfSymbol: "earbuds"),
        PPEItem(id: "earmuffs", name: "Earmuffs", sfSymbol: "headphones"),
        PPEItem(id: "respirator", name: "APR w/ Cartridges", sfSymbol: "aqi.medium"),
        PPEItem(id: "scba", name: "SCBA", sfSymbol: "wind"),
        PPEItem(id: "high-vis-vest", name: "Reflective Vest", sfSymbol: "tshirt.fill"),
        PPEItem(id: "steel-toe-boots", name: "Safety-Toe Boots", sfSymbol: "shoe.fill"),
        PPEItem(id: "leather-gloves", name: "Leather Gloves", sfSymbol: "hand.raised.fill"),
        PPEItem(id: "chemical-gloves", name: "Chemical-Resistant Gloves", sfSymbol: "hand.raised.fingers.spread"),
        PPEItem(id: "voltage-gloves", name: "Voltage-Rated Gloves (Class 0)", sfSymbol: "bolt.circle.fill"),
        PPEItem(id: "leather-protectors", name: "Leather Protector Gloves", sfSymbol: "hand.raised.brakesignal"),
        PPEItem(id: "nitrile-gloves", name: "Nitrile Gloves", sfSymbol: "hands.sparkles.fill"),
        PPEItem(id: "fall-harness", name: "Full-Body Harness w/ Lanyard", sfSymbol: "figure.climbing"),
        PPEItem(id: "frc", name: "FR Clothing", sfSymbol: "flame.fill"),
        PPEItem(id: "arc-clothing", name: "Arc-Rated Clothing", sfSymbol: "bolt.horizontal.fill"),
        PPEItem(id: "welding-helmet", name: "Welding Helmet (Proper Shade)", sfSymbol: "light.max"),
        PPEItem(id: "loto-kit", name: "LOTO Kit (Locks/Tags/Hasps)", sfSymbol: "lock.fill"),
        PPEItem(id: "gas-monitor", name: "4-Gas Monitor", sfSymbol: "sensor.fill"),
        PPEItem(id: "fire-extinguisher", name: "Fire Extinguisher", sfSymbol: "flame.circle.fill"),
        PPEItem(id: "comm-radio", name: "Two-Way Radio", sfSymbol: "antenna.radiowaves.left.and.right"),
        PPEItem(id: "splash-apron", name: "Chemical Splash Apron", sfSymbol: "drop.triangle.fill"),
        PPEItem(id: "chemical-boots", name: "Chemical-Resistant Boots", sfSymbol: "shoe.2.fill"),
        PPEItem(id: "rf-monitor", name: "Personal RF Monitor", sfSymbol: "wave.3.right"),
    ]

    // MARK: - Scenarios

    static let allScenarios: [PPEScenario] = [
        confinedSpaceEntry,
        hotWorkWelding,
        elevatedAntenna,
        lotoElectrical,
        flightlineFOD,
        hazmatSpill,
        routineInspection,
        postMishap,
    ]

    static func randomScenario() -> PPEScenario {
        allScenarios.randomElement() ?? confinedSpaceEntry
    }

    static func randomScenario(excluding ids: Set<String>) -> PPEScenario {
        let available = allScenarios.filter { !ids.contains($0.id) }
        return available.randomElement() ?? randomScenario()
    }

    // MARK: - Scenario 1: Confined Space Entry

    // DAFMAN 91-203 Ch. 23 (Confined Spaces); OSHA 29 CFR 1910.146
    private static let confinedSpaceEntry = PPEScenario(
        id: "ppe-confined-space",
        title: "Confined Space Entry",
        location: "Underground Storage Tank",
        description: "You are tasked with inspecting the interior of an underground fuel storage tank. The space has not been ventilated and previous atmospheric readings are unavailable. A rescue team is standing by topside. An AF Form 1024 entry permit has been issued.",
        hazards: ["Oxygen deficiency", "Toxic/flammable atmosphere", "Engulfment risk"],
        requiredItemIds: ["scba", "gas-monitor", "fall-harness", "hard-hat", "steel-toe-boots", "safety-glasses", "comm-radio"],
        availableItemIds: [
            "scba", "gas-monitor", "fall-harness", "hard-hat", "steel-toe-boots", "safety-glasses", "comm-radio",
            "welding-helmet", "high-vis-vest", "earmuffs",
        ],
        debriefNotes: [
            "scba": "Per DAFMAN 91-203 Ch. 23 and 29 CFR 1910.134, a full facepiece pressure-demand SCBA is required when the atmosphere is unknown or potentially IDLH. Air-purifying respirators are never permitted for IDLH or oxygen-deficient atmospheres.",
            "gas-monitor": "A 4-gas monitor (O2, LEL, CO, H2S minimum) must provide continuous atmospheric monitoring before and during entry per DAFMAN 91-203 Ch. 23 and 29 CFR 1910.146.",
            "fall-harness": "A full-body harness with retrieval line is required for non-entry rescue capability in permit-required confined spaces per DAFMAN 91-203 Ch. 23.",
            "hard-hat": "A Class E hard hat is required due to low overhead clearance and potential for falling objects inside the tank per DAFMAN 91-203 Ch. 14.",
            "steel-toe-boots": "Safety-toe boots (ASTM F2413) protect against crushing hazards from equipment and structural elements per DAFMAN 91-203 Ch. 14.",
            "safety-glasses": "Safety glasses with side shields are required as baseline eye protection inside the confined space per DAFMAN 91-203 Ch. 14.",
            "comm-radio": "Two-way voice communication with the attendant is required at all times during confined space entry per DAFMAN 91-203 Ch. 23 and 29 CFR 1910.146.",
        ]
    )

    // MARK: - Scenario 2: Hot Work / Welding

    // DAFMAN 91-203 Ch. 27 (Welding, Cutting, and Brazing); Ch. 6 (Fire Protection); OSHA 29 CFR 1910.252; ANSI Z49.1
    private static let hotWorkWelding = PPEScenario(
        id: "ppe-hot-work",
        title: "Structural Welding",
        location: "Hangar Bay \u{2014} Steel Beam Repair",
        description: "A damaged steel support beam requires arc welding repair inside an active aircraft hangar. Combustible materials have been cleared to a 35-foot radius. A fire watch with an AF Form 592 hot work permit is in place.",
        hazards: ["Sparks and molten metal", "UV/IR radiation", "Fire risk"],
        requiredItemIds: ["welding-helmet", "frc", "leather-gloves", "steel-toe-boots", "safety-glasses", "fire-extinguisher"],
        availableItemIds: [
            "welding-helmet", "frc", "leather-gloves", "steel-toe-boots", "safety-glasses", "fire-extinguisher",
            "fall-harness", "scba", "gas-monitor", "chemical-gloves",
        ],
        debriefNotes: [
            "welding-helmet": "Per DAFMAN 91-203 Ch. 27 and ANSI Z49.1, a welding helmet with proper shade lens (Shade 10\u{2013}13 for arc welding) is required to protect against UV/IR radiation and sparks.",
            "frc": "FR clothing (no synthetic fabrics) prevents ignition from sparks and molten metal spatter per DAFMAN 91-203 Ch. 27. Leather aprons or FR coveralls are required for heavy welding.",
            "leather-gloves": "Gauntlet-style leather welding gloves protect hands from burns, sparks, and hot metal contact per DAFMAN 91-203 Ch. 27 and ANSI Z49.1.",
            "steel-toe-boots": "Leather safety-toe boots (no fabric uppers) are required to prevent burns from molten metal per DAFMAN 91-203 Ch. 14.",
            "safety-glasses": "Safety glasses with side shields are worn under the welding helmet for eye protection when the helmet is flipped up, per DAFMAN 91-203 Ch. 27.",
            "fire-extinguisher": "A fire extinguisher rated for the materials present must be immediately accessible during hot work per DAFMAN 91-203 Ch. 27 and 29 CFR 1910.252. Fire watch continues for 30 minutes after work.",
        ]
    )

    // MARK: - Scenario 3: Elevated Antenna Maintenance

    // DAFMAN 91-203 Ch. 13 (Fall Protection); Ch. 30 (Communications Systems); OSHA 29 CFR 1910.140; DoDI 6055.11 (RF)
    private static let elevatedAntenna = PPEScenario(
        id: "ppe-elevated-antenna",
        title: "Elevated Antenna Maintenance",
        location: "60-ft Communications Tower",
        description: "You must climb a 60-foot communications tower to replace a damaged antenna feed. The tower is an active transmission site and transmitters cannot be confirmed de-energized. Work will be performed from a fixed platform with open edges.",
        hazards: ["Falls from height", "Dropped objects", "RF radiation exposure"],
        requiredItemIds: ["fall-harness", "hard-hat", "steel-toe-boots", "safety-glasses", "rf-monitor"],
        availableItemIds: [
            "fall-harness", "hard-hat", "steel-toe-boots", "safety-glasses", "rf-monitor",
            "respirator", "chemical-gloves", "frc", "splash-apron",
        ],
        debriefNotes: [
            "fall-harness": "Per DAFMAN 91-203 Ch. 13 and 29 CFR 1910.140, a full-body harness with shock-absorbing lanyard (limiting arrest forces to 1,800 lbs) is required for work above 6 feet. Rescue plans must be in place before work begins.",
            "hard-hat": "A Class E hard hat with chin strap is required to protect against impact from tower structural elements and dropped tools per DAFMAN 91-203 Ch. 13.",
            "steel-toe-boots": "Safety-toe boots with a defined heel provide foot protection and secure traction for climbing per DAFMAN 91-203 Ch. 14.",
            "safety-glasses": "Safety glasses with side shields protect against wind-blown particles, hardware fragments, and debris per DAFMAN 91-203 Ch. 14.",
            "rf-monitor": "Per DAFMAN 91-203 Ch. 30 and DoDI 6055.11, a personal RF safety monitor (active alarm device) is required when working on towers where transmitters cannot be confirmed de-energized. This is not a passive badge\u{2014}it actively warns when RF exposure approaches limits.",
        ]
    )

    // MARK: - Scenario 4: LOTO Electrical

    // DAFMAN 91-203 Ch. 21 (Hazardous Energy Control); Ch. 8 (Electrical Safety); NFPA 70E; OSHA 29 CFR 1910.147/1910.137
    private static let lotoElectrical = PPEScenario(
        id: "ppe-loto-electrical",
        title: "LOTO \u{2014} Energized Electrical Panel",
        location: "480V Motor Control Center",
        description: "You need to perform lockout/tagout on a 480-volt motor control center before maintenance personnel service the connected HVAC unit. The panel is live until isolation is confirmed. The arc flash label indicates Category 2 (8 cal/cm\u{00B2}).",
        hazards: ["Electrocution (480V)", "Arc flash (Cat 2)", "Stored energy release"],
        requiredItemIds: ["loto-kit", "arc-face-shield", "voltage-gloves", "leather-protectors", "arc-clothing", "safety-glasses", "steel-toe-boots", "hard-hat"],
        availableItemIds: [
            "loto-kit", "arc-face-shield", "voltage-gloves", "leather-protectors", "arc-clothing", "safety-glasses", "steel-toe-boots", "hard-hat",
            "fall-harness", "scba", "welding-helmet", "earmuffs",
        ],
        debriefNotes: [
            "loto-kit": "Per DAFMAN 91-203 Ch. 21 and 29 CFR 1910.147, LOTO devices (locks, tags, hasps) are required to isolate energy sources. AF Form 983 or DoD equivalent tags must be applied.",
            "arc-face-shield": "Per NFPA 70E and DAFMAN 91-203 Ch. 8, an arc-rated face shield is required to protect against thermal burns and blast pressure from arc flash events at the labeled incident energy level.",
            "voltage-gloves": "Per 29 CFR 1910.137 and DAFMAN 91-203 Ch. 8, Class 0 voltage-rated rubber insulating gloves (rated to 1,000V AC) are required for 480V work. Gloves must be electrically tested every 6 months and air-tested before each use.",
            "leather-protectors": "Leather protector gloves must be worn over voltage-rated rubber insulating gloves to prevent punctures and cuts per 29 CFR 1910.137 and ASTM D120.",
            "arc-clothing": "Arc-rated clothing with minimum 8 cal/cm\u{00B2} rating (Category 2 per NFPA 70E) is required based on the panel\u{2019}s arc flash label per DAFMAN 91-203 Ch. 8.",
            "safety-glasses": "Safety glasses with side shields are worn under the arc-rated face shield as secondary eye protection per DAFMAN 91-203 Ch. 14.",
            "steel-toe-boots": "EH-rated (Electrical Hazard) safety-toe boots reduce ground-fault risk and provide foot protection per DAFMAN 91-203 Ch. 14.",
            "hard-hat": "A Class E (electrically rated) hard hat is required when working on or near energized equipment per DAFMAN 91-203 Ch. 8 and NFPA 70E.",
        ]
    )

    // MARK: - Scenario 5: Flightline FOD Walk

    // DAFMAN 91-203 Ch. 24 (Aircraft Flightline Ground Operations); Ch. 14 (PPE); DAFI 48-127 (Hearing Conservation)
    private static let flightlineFOD = PPEScenario(
        id: "ppe-flightline-fod",
        title: "Flightline FOD Walk",
        location: "Active Runway Environment",
        description: "You are leading a Foreign Object Debris (FOD) walk along an active taxiway. Multiple aircraft are running engines on the parallel runway. Noise levels exceed 140 dB in some areas near the flight path.",
        hazards: ["Extreme noise (140+ dB)", "Jet blast", "FOD ingestion risk to aircraft"],
        requiredItemIds: ["earplugs", "earmuffs", "high-vis-vest", "safety-glasses", "steel-toe-boots"],
        availableItemIds: [
            "earplugs", "earmuffs", "high-vis-vest", "safety-glasses", "steel-toe-boots",
            "hard-hat", "respirator", "chemical-gloves", "fall-harness", "loto-kit",
        ],
        debriefNotes: [
            "earplugs": "Per DAFI 48-127 and DAFMAN 91-203 Ch. 14, earplugs are the first layer of double hearing protection. Single protection is required at 85 dBA TWA; double protection is mandatory at 104 dBA TWA and above.",
            "earmuffs": "Earmuffs over earplugs provide the required double hearing protection per DAFI 48-127. Flightline noise near running jet engines routinely exceeds 104 dBA, making double protection mandatory.",
            "high-vis-vest": "Per DAFMAN 91-203 Ch. 24, a reflective vest is required on the flightline for visibility to pilots, vehicle operators, and ground crews.",
            "safety-glasses": "Safety glasses protect against windblown debris and FOD particles kicked up by jet blast per DAFMAN 91-203 Ch. 14.",
            "steel-toe-boots": "Safety-toe boots with anti-FOD soles provide foot protection and secure footing on the flightline per DAFMAN 91-203 Ch. 14.",
        ]
    )

    // MARK: - Scenario 6: Hazmat Spill Response

    // DAFMAN 91-203 Ch. 14 (PPE); OSHA 29 CFR 1910.120 (HAZWOPER) Appendix B; 29 CFR 1910.134
    private static let hazmatSpill = PPEScenario(
        id: "ppe-hazmat-spill",
        title: "Hazmat Spill Response",
        location: "Chemical Storage Facility",
        description: "A 55-gallon drum of hydrochloric acid has tipped and is actively leaking onto the storage facility floor. Vapors are visible. The SDS indicates corrosive liquid and toxic inhalation hazard. Bioenvironmental Engineering has assessed the area as non-IDLH with adequate ventilation for APR use.",
        hazards: ["Corrosive liquid contact", "Toxic vapor inhalation", "Chemical splash"],
        requiredItemIds: ["chemical-gloves", "splash-apron", "chemical-goggles", "respirator", "chemical-boots", "face-shield"],
        availableItemIds: [
            "chemical-gloves", "splash-apron", "chemical-goggles", "respirator", "chemical-boots", "face-shield",
            "leather-gloves", "hard-hat", "fall-harness", "welding-helmet",
        ],
        debriefNotes: [
            "chemical-gloves": "Per DAFMAN 91-203 Ch. 14 (para 14.4.9.2) and 29 CFR 1910.120, chemical-resistant gloves rated for HCl (butyl rubber or equivalent per SDS) are required to prevent skin burns and chemical absorption.",
            "splash-apron": "A chemical splash apron provides Level C torso protection from liquid splashes during spill containment per 29 CFR 1910.120 Appendix B.",
            "chemical-goggles": "Indirect-vent chemical splash goggles provide sealed eye protection against liquid and vapor per DAFMAN 91-203 Ch. 14. Standard safety glasses are insufficient for chemical splash hazards.",
            "respirator": "Per DAFMAN 91-203 Ch. 14 and 29 CFR 1910.134, a full facepiece APR with acid gas cartridges is required at Level C when Bioenvironmental Engineering confirms non-IDLH conditions. If the atmosphere were IDLH or unknown, SCBA would be required instead.",
            "chemical-boots": "Chemical-resistant safety-toe boots prevent foot exposure to corrosive liquids pooling on the floor per DAFMAN 91-203 Ch. 14.",
            "face-shield": "A face shield worn over goggles provides additional splash protection for the entire face per DAFMAN 91-203 Ch. 14 and 29 CFR 1910.120.",
        ]
    )

    // MARK: - Scenario 7: Routine Facility Inspection

    // DAFMAN 91-203 Ch. 14 (PPE); Ch. 12 (Materials Handling Equipment); Ch. 7 (Walking/Working Surfaces)
    private static let routineInspection = PPEScenario(
        id: "ppe-routine-inspection",
        title: "Routine Facility Inspection",
        location: "Office / Warehouse Complex",
        description: "You are conducting a routine safety walk-through of a combined office and warehouse facility. The warehouse section has active forklift traffic and elevated storage racks. No special hazards have been reported. The JSTO identifies standard industrial PPE requirements.",
        hazards: ["Minor trip/slip hazards", "Overhead clearance", "Forklift traffic"],
        requiredItemIds: ["hard-hat", "safety-glasses", "steel-toe-boots", "high-vis-vest"],
        availableItemIds: [
            "hard-hat", "safety-glasses", "steel-toe-boots", "high-vis-vest",
            "scba", "fall-harness", "chemical-gloves", "welding-helmet", "frc", "respirator",
        ],
        debriefNotes: [
            "hard-hat": "Per DAFMAN 91-203 Ch. 14, a hard hat is required in warehouse areas with overhead storage, elevated racks, and potential for falling objects.",
            "safety-glasses": "Safety glasses with side shields are standard PPE in any industrial workspace per DAFMAN 91-203 Ch. 14.",
            "steel-toe-boots": "Safety-toe boots (ASTM F2413) are required in warehouse areas with forklift traffic and heavy materials per DAFMAN 91-203 Ch. 14.",
            "high-vis-vest": "A reflective vest is required in active forklift areas to ensure visibility to equipment operators per DAFMAN 91-203 Ch. 12.",
        ]
    )

    // MARK: - Scenario 8: Post-Mishap Scene Documentation

    // DAFMAN 91-203 Ch. 24 (Flightline Ops); Ch. 18 (Hydrocarbon Fuels); Ch. 14 (PPE); DAFI 91-204 (Safety Investigations)
    private static let postMishap = PPEScenario(
        id: "ppe-post-mishap",
        title: "Post-Mishap Scene Documentation",
        location: "Aircraft Incident Site",
        description: "An aircraft has experienced a landing gear collapse on the ramp. No fire occurred but fuel is leaking from a cracked wing tank. You must document the scene and preserve evidence. The area is cordoned off and fuel vapor concentrations have been assessed as below action levels by Bioenvironmental Engineering.",
        hazards: ["Sharp metal debris", "Fuel residue on surfaces", "Structural instability"],
        requiredItemIds: ["hard-hat", "safety-glasses", "steel-toe-boots", "nitrile-gloves", "leather-gloves", "high-vis-vest"],
        availableItemIds: [
            "hard-hat", "safety-glasses", "steel-toe-boots", "nitrile-gloves", "leather-gloves", "high-vis-vest",
            "scba", "welding-helmet", "fall-harness", "loto-kit", "earmuffs",
        ],
        debriefNotes: [
            "hard-hat": "Per DAFMAN 91-203 Ch. 14, a hard hat protects against unstable aircraft components and overhead hazards at the mishap site.",
            "safety-glasses": "Safety glasses with side shields protect against metal fragments, hydraulic fluid splashes, and debris per DAFMAN 91-203 Ch. 14.",
            "steel-toe-boots": "Per DAFMAN 91-203 Ch. 14, safety-toe boots protect against sharp debris, heavy components, and fuel-slick surfaces. EH-rated boots are preferred near potential electrical hazards.",
            "nitrile-gloves": "Per DAFI 91-204 and DAFMAN 91-203 Ch. 18, nitrile gloves are worn as the inner layer to prevent evidence contamination and protect skin from JP-8/hydraulic fluid contact. Fuel vapors are heavier than air and residue persists on surfaces.",
            "leather-gloves": "Leather gloves worn over nitrile provide cut and puncture protection when handling sharp metal debris while preserving evidence integrity per mishap investigation guidance.",
            "high-vis-vest": "Per DAFMAN 91-203 Ch. 24, a reflective vest is required for personnel at the mishap site to be visible to emergency and recovery crews.",
        ]
    )
}
