# Question content review — 10 October 2026

The 1.7 baseline below contains 140 questions with individually authored explanations, conditions, and official-source references in `QuestionExplanations.swift`. The bank still contains 14 modules with 10 questions each. This is not a claim that every publication has been verified current.

## Earlier evidence and retrieval limitations (superseded by the release review below)

OSHA regulation pages and the NIOSH hierarchy of controls page were retrieved from their official sites during the review. Each explanation identifies the applicable standard and subsection. The reference index below covers the exact pages consulted.

Direct retrieval from e-Publishing of DAFI 91-202, DAFI 91-204, DAFPAM 90-803, and DAFMAN 91-203 was blocked by the publication host/tool. This is an access limitation, not a requirement to obtain every source from that host; intact mirrored government publications can be reviewed. Official indexed excerpts were available for parts of the first three documents, but do not establish that the complete current text, changes, and supplements were reviewed. **At this earlier stage, full DAF publication verification was a release blocker; Buck’s release review below resolves the 35-question review.** Check title pages, current changes, applicable supplements, paragraph alignment, and classification/notification criteria before release. DAF references use descriptive sections where exact paragraphs were not verified; no paragraph numbers were invented.

Local reference evidence was subsequently found: DAFI 91-202 with DAFGM2026-01 (26 February 2026), and DAFMAN 91-203 (24 February 2026). The local text was checked for commander/supervisor responsibilities (1.6.27–1.6.28), job safety training (14.1), and hot-work permitting (20.8–20.10). These checks support the related explanations but do not establish publication currency at release. The local DAFI 91-204 copy contains a 16 July 2025 guidance memorandum whose stated one-year validity has elapsed. That expiration applies to the memorandum and does not by itself invalidate the underlying instruction; the current change status still needs reconciliation. No local DAFPAM 90-803 copy was found. That earlier review gap is resolved by the supplied release review below.

Training language distinguishes routine, elevated, and emergency conditions. OSHA general-industry thresholds are not presented as universal Air Force requirements. Reference links require internet access; explanations are bundled and available offline.

### Public mirror follow-up

A [full-text mirror of DAFMAN 91-203](https://www.scribd.com/document/1015136164/dafman91-203) was opened on 9 October 2026. Its actual title page identifies 24 February 2026, 413 pages, superseding 25 March 2022, matching the local reference. The publisher-authored text, rather than Scribd's AI summary, is the evidence. The local copy's §§20.8.1–20.8.1.4.3 and 20.10 support `fire-hot-work-q10`: F&ES authorization before covered work, the approved-shop exception, and the provision for certified permit issuers. The question now cites these precise paragraphs; its meaning and ID are unchanged. This resolves full-text access and paragraph alignment for that question, leaving 35 DAF-referenced questions for the subsequent Buck review below. It does not independently establish that no subsequent changes exist.

Google and general web searches also located an [AFDW-hosted DAFI 91-204 copy](https://www.afdw.af.mil/Portals/31/documents/Worldwide%20Mission/Safety/Flight%20Safety/Regulations/dafi91-204.pdf?ver=6VBZqw7Rvefe8sG1bOse6A%3D%3D), but its PDF returned HTTP 403 on direct retrieval. The [90-803 mirror found on Scribd](https://www.scribd.com/document/898138958/Risk-Management-Usaf-Gide) is the 11 February 2013 AFPAM edition, so it cannot establish the updated DAFPAM process. Unofficial catalog entries linking back to e-Publishing are leads, not independent document mirrors or proof of currency.

## Material corrections

- Tagout on a lockable device may be permitted with demonstrated full equivalent protection; it is not limited exclusively to devices that cannot accept a lock.
- Employer-directed lock removal and contractor/group coordination need all relevant protective steps.
- Free-fall and anchorage questions now state when their prescriptive criteria apply.
- NRR A-weighting adjustment is separated from field derating and actual worker protection.
- Respirator APF arithmetic alone does not establish suitability. Tight-fitting respirator prerequisites and PPE payment exceptions are explicit.
- Risk acceptance follows applicable command policy, not a universal rank matrix. Acceptance does not itself waive mandatory requirements. The related deployed lesson and field exercise now reflect that distinction; field exercises identify their hypothetical authority assumptions.
- The generator scenario prioritizes people leaving suspected exhaust exposure, safe source control, and verification before reuse. It no longer labels an unmeasured atmosphere as confirmed IDLH or treats a universal setback as sufficient protection.
- Hot-work fire-watch duration distinguishes OSHA's minimum from applicable longer requirements.

## Retired question IDs

Materially revised questions receive new IDs. Old saved progress remains on disk, but retired cards no longer appear as due reviews. They are not automatically marked correct for their replacements. Existing custom sessions containing removed questions are rejected with a visible explanation; legacy module quizzes containing retired IDs restart with a notice.

| Retired | Replacement |
|---|---|
| `loto-q3` | `loto-q103` |
| `loto-q5` | `loto-q105` |
| `loto-q6` | `loto-q106` |
| `loto-q10` | `loto-q110` |
| `fall-q2` | `fall-q102` |
| `fall-q9` | `fall-q109` |
| `rm-q2` | `rm-q102` |
| `rm-q6` | `rm-q106` |
| `cs-q4` | `cs-q104` |
| `hc-q5` | `hc-q105` |
| `ppe-q4` | `ppe-q104` |
| `ppe-q5` | `ppe-q105` |
| `ppe-q9` | `ppe-q109` |
| `dorm-q1` | `dorm-q101` |
| `dorm-q2` | `dorm-q102` |
| `dorm-q4` | `dorm-q104` |
| `dorm-q10` | `dorm-q110` |
| `machine-guarding-q5` | `machine-guarding-q105` |
| `fire-hot-work-q1` | `fire-hot-work-q101` |

## Release 1.7 currency review — 9 October 2026

Applied Abdoul's approved `buck_currency_review.md` (Buck / 1S0 App Ops): 35 DAF-referenced questions reviewed, 24 OK, 10 fixes, one unsure. The supplied review reports direct PDF extraction and catalog-mirror cross-checking on 9 October; this implementation consumes that review and does not claim an independent repeat of the full PDF audit. The prior 35-question release blocker is closed on that evidence.

- Applied all specified prompt, choice, explanation, and reference replacements to rm-q1, rm-q3, rm-q8, rm-q9, roles-q6, mishap-q1, dorm-q101, dorm-q3, dorm-q6, and dorm-q110, with replacement IDs below where meaning changes.
- Applied the softer mishap-q6 prompt: “What information should an initial mishap notification include?” The existing factual answer remains; no single universal mandatory contents list was verified.
- DAFI 90-802, 20 January 2026, is now the primary RM reference in questions, lessons, glossary, reference index, and Live e-Pubs. Existing module and feature names, including Deployed ORM, remain unchanged. DAFPAM 90-803 remains the 23 March 2022 edition, certified current 17 February 2026; it was not reissued in 2026.
- DAFI 91-202: 20 March 2020, Change 1 (10 April 2024), with DAFGM2026-01 (26 February 2026). Recheck the GM before 26 February 2027 or a rewrite. DAFI 91-204: 10 March 2021 base, no GM attached to the reviewed current PDF; these questions do not rely on expired DAFGM2025-02.
- Updated ESOHC governance to DAFI 90-801 (9 May 2024), Class A criteria to include destroyed DoD aircraft, contract-work imminent-danger action, and the most-protective interim rule for conflicting guidance under DAFMAN 91-203 (24 February 2026).
- Verified all seven hearing-conservation labels in PPELoadoutData, HazardReportData, and EpubsCatalog use DAFI 48-127; they were already renamed in the resumed checkout. Corrected the remaining old AFI PDF URL and identified the 17 March 2026 edition in the catalog. This date comes from the supplied Ops review and Abdoul's instruction, not Buck's 35-question audit.
- Terminology-only corrections to rm-q8/rm-q9 retain IDs. dorm-q101 retains its ID because its mandatory-requirement/waiver teaching point is unchanged; the wording and primary citation are clarified.

Additional retired IDs (old saved answers are not credited to replacements):

| Retired | Replacement | Reason |
|---|---|---|
| `rm-q1` | `rm-q101` | Complete current five-step process |
| `rm-q3` | `rm-q103` | Deliberate versus real-time RM and same five steps |
| `roles-q6` | `roles-q106` | ESOHC decision authority and governance |
| `mishap-q1` | `mishap-q101` | Destroyed-aircraft Class A criterion |
| `dorm-q3` | `dorm-q103` | Stop critical/imminent-danger contract work |
| `dorm-q6` | `dorm-q106` | RTRM process during execution, including stop/delay |
| `dorm-q110` | `dorm-q210` | Most-protective guidance pending conflict resolution |

Together with the earlier 19 retirements, the registry now contains 26 retired IDs. The bank remains 140 active questions, with one explanation/reference for each. The approved listing's “19 questions” sentence describes the original overhaul; this review adds further currency corrections.

## Sources

- [OSHA 1904.7](https://www.osha.gov/laws-regs/regulations/standardnumber/1904/1904.7)
- [OSHA 1904.8](https://www.osha.gov/laws-regs/regulations/standardnumber/1904/1904.8)
- [OSHA 1910.106](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.106)
- [OSHA 1910.1200](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.1200)
- [OSHA 1910.132](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.132)
- [OSHA 1910.133](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.133)
- [OSHA 1910.134](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.134)
- [OSHA 1910.138](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.138)
- [OSHA 1910.140](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.140)
- [OSHA 1910.146](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.146)
- [OSHA 1910.147](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147)
- [OSHA 1910.157](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.157)
- [OSHA 1910.176](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.176)
- [OSHA 1910.178](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.178)
- [OSHA 1910.184](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.184)
- [OSHA 1910.212](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.212)
- [OSHA 1910.215](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.215)
- [OSHA 1910.219](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.219)
- [OSHA 1910.252](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.252)
- [OSHA 1910.253](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.253)
- [OSHA 1910.28](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.28)
- [OSHA 1910.29](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.29)
- [OSHA 1910.303](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.303)
- [OSHA 1910.304](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.304)
- [OSHA 1910.305](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.305)
- [OSHA 1910.332](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.332)
- [OSHA 1910.333](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.333)
- [OSHA 1910.334](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.334)
- [OSHA 1910.37](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.37)
- [OSHA 1910.95](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.95)
- [OSHA 1910.95AppB](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.95AppB)
- [NIOSH hierarchy of controls](https://www.cdc.gov/niosh/hierarchy-of-controls/about/index.html)
- [OSHA portable-generator CO prevention](https://www.osha.gov/sites/default/files/publications/OSHA4105.pdf)
- [DAFI 91-202](https://static.e-publishing.af.mil/production/1/af_se/publication/dafi91-202/dafi91-202.pdf) — reviewed by Buck on 9 October 2026; see release review below.
- [DAFI 91-204](https://static.e-publishing.af.mil/production/1/af_se/publication/dafi91-204/dafi91-204.pdf) — reviewed by Buck on 9 October 2026; see release review below.
- [DAFPAM 90-803](https://static.e-publishing.af.mil/production/1/af_se/publication/dafpam90-803/dafpam90-803.pdf) — reviewed by Buck on 9 October 2026; see release review below.
- [DAFMAN 91-203](https://static.e-publishing.af.mil/production/1/af_se/publication/dafman91-203/dafman91-203.pdf) — 24 February 2026 text available locally and on the mirror above; hot-work question paragraph alignment verified.

- [DAFI 90-802](https://static.e-publishing.af.mil/production/1/af_se/publication/dafi90-802/dafi90-802.pdf) — 20 January 2026, primary RM directive.
- [DAFI 90-801](https://static.e-publishing.af.mil/production/1/saf_ie/publication/dafi90-801/dafi90-801.pdf) — 9 May 2024, ESOHC.


## 1.8 OSHA modules

Reviewer: **Codex**, 10 October 2026. Reviewed against the official eCFR versioner API, Title 29 **up to date as of 7 October 2026**, latest amendment/issue 6 October. Each decision's correct answer, limiting conditions, and paragraph were compared with the current text. This is an implementation content review; Abdoul's release sign-off remains separate.

The official compressed XML API was accessible even when the HTML host challenged scripted requests. The dated section extracts are in [ecfr-verified-sections.txt](review/1.8/ecfr-verified-sections.txt); retrieval URLs, title currency, and source hashes are in [source-manifest.json](review/1.8/source-manifest.json). The verified-date column identifies review date, not an assertion that the regulations were amended that day.

| ID | Paragraph | Verified date | Status |
|---|---|---|---|
| `wws-q1` | 29 CFR 1910.22(d)(2) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `wws-q2` | 29 CFR 1910.22(d)(3) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `wws-q3` | 29 CFR 1910.23(b)(9) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `wws-q4` | 29 CFR 1910.23(b)(10) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `wws-q5` | 29 CFR 1910.23(c)(3) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `wws-q6` | 29 CFR 1910.23(c)(8) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `wws-q7` | 29 CFR 1910.23(c)(11) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `wws-q8` | 29 CFR 1910.23(b)(13) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `wws-q9` | 29 CFR 1910.30(c)(2) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `wws-q10` | 29 CFR 1910.28(b)(9)(i)(D) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `ppeha-q1` | 29 CFR 1910.132(d)(2) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `ppeha-q2` | 29 CFR 1910.132(d)(1)(iii) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `ppeha-q3` | 29 CFR 1910.132(f)(3)(i) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `ppeha-q4` | 29 CFR 1910.132(f)(3)(ii) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `ppeha-q5` | 29 CFR 1910.132(f)(3)(iii) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `ppeha-q6` | 29 CFR 1910.132(h)(2) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `ppeha-q7` | 29 CFR 1910.132(h)(4)(iii) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `ppeha-q8` | 29 CFR 1910.132(h)(5) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `ppeha-q9` | 29 CFR 1910.132(h)(6) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `ppeha-q10` | 29 CFR 1910.133(a)(3) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `rk-q1` | 29 CFR 1904.1(a)(1) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `rk-q2` | 29 CFR 1904.29(b)(3) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `rk-q3` | 29 CFR 1904.29(b)(4) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `rk-q4` | 29 CFR 1904.29(b)(7)(iv) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `rk-q5` | 29 CFR 1904.32(b)(3) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `rk-q6` | 29 CFR 1904.32(b)(4)(iii) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `rk-q7` | 29 CFR 1904.32(b)(6) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `rk-q8` | 29 CFR 1904.39(a)(1) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `rk-q9` | 29 CFR 1904.39(a)(2) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `rk-q10` | 29 CFR 1904.39(b)(10) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `eap-q1` | 29 CFR 1910.38(c)(1) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `eap-q2` | 29 CFR 1910.38(c)(2) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `eap-q3` | 29 CFR 1910.38(c)(3) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `eap-q4` | 29 CFR 1910.38(c)(4) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `eap-q5` | 29 CFR 1910.38(c)(5) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `eap-q6` | 29 CFR 1910.38(f)(2) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `eap-q7` | 29 CFR 1910.38(f)(3) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `eap-q8` | 29 CFR 1910.39(c)(1) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `eap-q9` | 29 CFR 1910.39(c)(2) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `eap-q10` | 29 CFR 1910.39(c)(3) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `resp-q1` | 29 CFR 1910.134(c)(1) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `resp-q2` | 29 CFR 1910.134(c)(2)(i) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `resp-q3` | 29 CFR 1910.134(c)(2)(ii) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `resp-q4` | 29 CFR 1910.134(c)(3) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `resp-q5` | 29 CFR 1910.134(d)(1)(ii) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `resp-q6` | 29 CFR 1910.134(g)(1)(i)(A) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `resp-q7` | 29 CFR 1910.134(g)(1)(iii) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `resp-q8` | 29 CFR 1910.134(h)(1)(ii) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `resp-q9` | 29 CFR 1910.134(h)(2)(i) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `resp-q10` | 29 CFR 1910.134(m)(2)(ii) | 2026-10-10 | Verified — eCFR 2026-10-07 |
| `fire-hot-work-q210` | 29 CFR 1910.252(a)(2)(vi)(B) | 2026-10-10 | Verified — eCFR 2026-10-07 |

### Distinct teaching points and retained IDs

The frozen [paragraph-and-point fixture](../Tests/Fixtures/osha18-points.json) records each new decision and its specific teaching point. The test compares both the paragraph and point; review is semantic, not just a check that paragraph strings differ.

- Walking-working surfaces tests repair access control, qualified structural repair, shift inspection, removal of damaged ladders, intended load, top-step prohibition, rail extension, unbalancing loads, changed-equipment retraining, and the fixed-ladder transition. None repeats the existing four-foot threshold, guardrail height, or hole-cover strength points.
- PPE hazard assessment tests certification elements, individual fit, three separate retraining triggers, the off-site-use payment exception, weather clothing, replacement-payment exceptions, voluntary employee equipment, and prescription-eyewear compatibility. Existing PPE questions retain the general assessment, training-topic, defective-PPE, and employer-payment rules. These narrower factual conditions are not replacements for those questions.
- Recordkeeping tests small-employer partial exemption, the seven-day recording window, equivalent forms, HIV privacy handling, executive certification and eligibility, posting dates, immediate fatality/amputation reporting, and observation-only admission. None repeats the general recordability or sharps recording questions in Mishap Reporting.
- Emergency plans test distinct required plan elements and review triggers. They do not repeat extinguisher mounting, inspection, or unobstructed exits.
- Respiratory questions test program scope, voluntary-use information and elastomeric exception, administrator qualifications, certified configurations, facial hair, per-donning seal checks, shared cleaning, storage, and fit-test-record retention. They do not repeat APF arithmetic or the combined medical/fit/training prerequisite question.
- `fire-hot-work-q210` tests prohibited work during sprinkler impairment. It is OSHA-only; AF retains `fire-hot-work-q10` on DAF permitting. There are **191 unique questions**, **150 OSHA**, **190 AF**, with exactly ten questions per visible module. No released 1.7 answer meaning was changed, and no additional IDs were retired. All 26 existing retired IDs and their saved records remain protected.

### OSHA-hidden scenarios and assessments

The following four module scenarios and their assessments are AF-only in full:

- Risk Management: Flight Line Equipment Inspection (`risk-management`).
- Program Responsibilities: Pre-Inspection Alignment (`roles-responsibilities`).
- Mishap Reporting: Maintenance Injury (`mishap-reporting`).
- Deployed ORM: the entire `deployed-orm` module, scenario and quiz; all separate Deployed ORM field exercises.

The legacy scenario and lesson editions in each shared module stay on AF. OSHA receives neutral editions built from the reviewed question decisions, with no DAF references. Those legacy scenarios are:
- Conveyor Guard Replacement.
- Rooftop HVAC Inspection.
- Flight Line Equipment Inspection.
- Pre-Inspection Alignment.
- Tank Inspection.
- Flight Line Noise.
- Maintenance Injury.
- Grinding Operation.
- Unknown Solvent Bottle.
- Open Panel In A Shop.
- Bench Grinder Setup.
- Warehouse Reset.
- Maintenance Bay Hot Work.
- Sandstorm Damage Assessment.

All legacy PPE loadout scenarios remain on AF; the OSHA menu uses two separately scoped civilian scenarios (`osha-ppe-splash`, `osha-ppe-warehouse`) with 29 CFR references and explicit exposure assumptions. The following legacy PPE scenario IDs are hidden on OSHA:
- `ppe-confined-space`.
- `ppe-hot-work`.
- `ppe-elevated-antenna`.
- `ppe-loto-electrical`.
- `ppe-flightline-fod`.
- `ppe-hazmat-spill`.
- `ppe-routine-inspection`.
- `ppe-post-mishap`.

DAF Form 457/RAC exercises, DAF glossary terms and lookup questions, AF daily lessons, and Live e-Pubs are inaccessible on OSHA, including publication deep links. Bookmarks, review cards and session history are retained; current-track lists hide incompatible content. Settings and the shared legal disclaimer deliberately identify the other track and government organizations; these are not OSHA instructional content.

### Citation and currency follow-up

- All OSHA-cited quiz references, on both tracks, use HTTPS eCFR links. New questions have exact `#p-` paragraph anchors. `hc-q105` cites Appendix B; `hazcom-q9` identifies Appendix D sections 7 and 10. Hearing and fire-watch AF notes are displayed only on AF, below the neutral explanation.
- HazCom 2024 was rechecked against current 1910.1200, including revised paragraph (j) transition dates. The existing questions concern labeling, SDS access/content, training and communication; they do not assert that every supplier has already completed the update. The current transition dates differ for substances and mixtures, so no blanket completion claim was added.
- Current eCFR still includes 1910.134 requirements and the November 18, 2036 fixed-ladder deadline. The respiratory-protection and fixed-ladder deregulatory proposals are **not final requirements** in this bank. No pending heat-rule requirements were added. Recheck these before the separate release, especially if publication is delayed.
- Foundation lessons additionally cover retained records and updates, employee/government access, electronic-submission applicability, plan oral/written thresholds, alarm/training responsibilities, PPE assessment scope, and respiratory IDLH/inspection requirements. The bundled OSHA Standards index includes their cited sections as well as quiz references.
- The implementation source verification does not substitute for Abdoul's content approval, real-data upgrade smoke test, trademark decision or subsequent release steps. No 1.8 App Store version or metadata was created by this build task.
