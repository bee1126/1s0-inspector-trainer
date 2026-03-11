import { useState, useEffect } from "react";
const INBOX_DATA = {
  totalMessages: 3600,
  totalThreads: 3362,
  unreadCount: 201,
  categories: [
    { name: "Financial / Investment", count: 14, color: "#10B981", icon: "💰", emails: [
      "Robinhood – Recurring investments (×5)", "Robinhood – Trade confirmations (×2)", "Robinhood – IRA contributions (×3)",
      "Wealthfront – Account review", "USAA – Balance alerts (×2)", "Navy Federal – Visa statement"
    ], action: "Set up filters to auto-label and archive. You don't need to read each one — review weekly.", priority: "medium" },
    { name: "Shopping / Shipping", count: 9, color: "#F59E0B", icon: "📦", emails: [
      "Amazon – Order & shipping (×2)", "FedEx – Delivery tracking (×3)", "PetSmart – Order confirmations (×2)",
      "Chewy – Shipping updates (×2)"
    ], action: "Create a 'Deliveries' label with auto-archive. Check only when expecting a package.", priority: "low" },
    { name: "Action Required", count: 5, color: "#EF4444", icon: "🔴", emails: [
      "Jeff Franke (KWG) – Listing papers need Jamie's signature",
      "DocuSign – Management Agreement reminder for 7911 W Main",
      "DS Logon – Account deactivation in 30 days",
      "TurboTax – Sign & file your return",
      "Sentry – Free trial ended (StudyForge)"
    ], action: "Handle these TODAY. These have real deadlines or consequences.", priority: "critical" },
    { name: "Work / Military", count: 2, color: "#3B82F6", icon: "✈️", emails: [
      "375 AMW/SE Safety – CPTS/WSA Inspection",
      "LinkedIn – Cas Caruso (PACAF Safety) wants to connect"
    ], action: "The inspection email is work-critical. The LinkedIn connection from PACAF Safety is worth accepting before your Korea PCS.", priority: "high" },
    { name: "Tax Season", count: 5, color: "#8B5CF6", icon: "📋", emails: [
      "TurboTax – Expert message (×2)", "TurboTax – Order confirmation",
      "TurboTax – Federal return ACCEPTED", "TurboTax – Action needed: sign return"
    ], action: "Your federal return was accepted! Archive the confirmations, respond to expert if needed.", priority: "medium" },
    { name: "Promotions & Newsletters", count: 7, color: "#6B7280", icon: "📢", emails: [
      "OpenAI – Dev News (Codex)", "UAGC – Graduate benefits", "Cash App – Borrow offer",
      "Cash App – Tax scam tips", "Kalshi – Trading tools", "L7 Chicago – Hotel promo",
      "Eckert Florist – Birthday reminder"
    ], action: "Unsubscribe from anything you haven't opened in 30 days. Keep OpenAI Dev News if useful for your apps.", priority: "low" },
    { name: "Security & Account", count: 4, color: "#EC4899", icon: "🔒", emails: [
      "Google – Security alerts for Claude access (×2)",
      "American Express – Card-not-present alerts (×2)"
    ], action: "Verify the Amex alerts are legit purchases. Google alerts are from connecting Claude — safe to archive.", priority: "medium" },
    { name: "Automated / Self-Sent", count: 1, color: "#06B6D4", icon: "🤖", emails: [
      "Daily Brief – 'Your Day Ahead' from ⓒⓒ"
    ], action: "Great system! Make sure you're acting on these, not just receiving them.", priority: "low" },
  ],
  filterSuggestions: [
    { from: "noreply@robinhood.com", label: "Finance/Robinhood", action: "Auto-archive, label", impact: "~8 emails/week" },
    { from: "TrackingUpdates@fedex.com", label: "Deliveries", action: "Auto-archive, label", impact: "~5 emails/week" },
    { from: "PetSmart@mail.petsmart.com", label: "Deliveries", action: "Auto-archive, label", impact: "~3 emails/week" },
    { from: "USAA.customer.service@mailcenter.usaa.com", label: "Finance/USAA", action: "Auto-archive, label", impact: "~7 emails/week" },
    { from: "americanexpress@*", label: "Finance/Amex", action: "Label only (review alerts)", impact: "~4 emails/week" },
    { from: "turbotax@intuit.com", label: "Taxes", action: "Label, keep in inbox during tax season", impact: "Seasonal" },
  ]
};
const priorityOrder = { critical: 0, high: 1, medium: 2, low: 3 };
const priorityLabels = { critical: "DO NOW", high: "This Week", medium: "Review", low: "Optimize" };
const priorityColors = { critical: "#EF4444", high: "#F59E0B", medium: "#3B82F6", low: "#6B7280" };
export default function InboxOptimizer() {
  const [selectedCategory, setSelectedCategory] = useState(null);
  const [checkedItems, setCheckedItems] = useState({});
  const [activeTab, setActiveTab] = useState("overview");
  const [animateIn, setAnimateIn] = useState(false);
  useEffect(() => {
    setTimeout(() => setAnimateIn(true), 100);
  }, []);
  const sorted = [...INBOX_DATA.categories].sort((a, b) => priorityOrder[a.priority] - priorityOrder[b.priority]);
  const toggleCheck = (key) => setCheckedItems(prev => ({ ...prev, [key]: !prev[key] }));
  const checkedCount = Object.values(checkedItems).filter(Boolean).length;
  const totalActions = INBOX_DATA.categories.length + INBOX_DATA.filterSuggestions.length;
  const progress = Math.round((checkedCount / totalActions) * 100);
  return (
    <div style={{
      fontFamily: "'DM Sans', 'Segoe UI', sans-serif",
      background: "linear-gradient(145deg, #0a0e17 0%, #111827 50%, #0f172a 100%)",
      color: "#e2e8f0",
      minHeight: "100vh",
      padding: "0",
      position: "relative",
      overflow: "hidden"
    }}>
      <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;700&family=Space+Mono:wght@400;700&display=swap" rel="stylesheet" />
      {/* Subtle grid background */}
      <div style={{
        position: "fixed", inset: 0, opacity: 0.03,
        backgroundImage: "linear-gradient(#fff 1px, transparent 1px), linear-gradient(90deg, #fff 1px, transparent 1px)",
        backgroundSize: "40px 40px", pointerEvents: "none", zIndex: 0
      }} />
      <div style={{ position: "relative", zIndex: 1, maxWidth: 960, margin: "0 auto", padding: "32px 20px" }}>
        {/* Header */}
        <div style={{
          opacity: animateIn ? 1 : 0, transform: animateIn ? "translateY(0)" : "translateY(-20px)",
          transition: "all 0.6s cubic-bezier(0.16, 1, 0.3, 1)", marginBottom: 32
        }}>
          <div style={{ display: "flex", alignItems: "center", gap: 12, marginBottom: 8 }}>
            <div style={{
              width: 42, height: 42, borderRadius: 12, display: "flex", alignItems: "center", justifyContent: "center",
              background: "linear-gradient(135deg, #3B82F6, #8B5CF6)", fontSize: 20
            }}>📬</div>
            <div>
              <h1 style={{ fontFamily: "'Space Mono', monospace", fontSize: 22, fontWeight: 700, margin: 0, letterSpacing: "-0.5px" }}>
                INBOX OPTIMIZER
              </h1>
              <p style={{ fontSize: 13, color: "#64748b", margin: 0 }}>abdoulbah1126@gmail.com</p>
            </div>
          </div>
        </div>
        {/* Stats Row */}
        <div style={{
          display: "grid", gridTemplateColumns: "repeat(4, 1fr)", gap: 12, marginBottom: 28,
          opacity: animateIn ? 1 : 0, transform: animateIn ? "translateY(0)" : "translateY(20px)",
          transition: "all 0.6s cubic-bezier(0.16, 1, 0.3, 1) 0.15s"
        }}>
          {[
            { label: "Total Emails", value: "3,600", accent: "#64748b" },
            { label: "Unread", value: "201", accent: "#EF4444" },
            { label: "Action Items", value: "5", accent: "#F59E0B" },
            { label: "Auto-filterable", value: "~70%", accent: "#10B981" },
          ].map((stat, i) => (
            <div key={i} style={{
              background: "rgba(255,255,255,0.03)", border: "1px solid rgba(255,255,255,0.06)",
              borderRadius: 14, padding: "16px 14px", position: "relative", overflow: "hidden"
            }}>
              <div style={{
                position: "absolute", top: 0, left: 0, right: 0, height: 2,
                background: `linear-gradient(90deg, transparent, ${stat.accent}, transparent)`
              }} />
              <p style={{ fontSize: 11, color: "#64748b", margin: "0 0 6px", textTransform: "uppercase", letterSpacing: "0.5px", fontFamily: "'Space Mono', monospace" }}>{stat.label}</p>
              <p style={{ fontSize: 26, fontWeight: 700, margin: 0, color: stat.accent }}>{stat.value}</p>
            </div>
          ))}
        </div>
        {/* Progress Bar */}
        <div style={{
          background: "rgba(255,255,255,0.03)", border: "1px solid rgba(255,255,255,0.06)",
          borderRadius: 14, padding: "16px 18px", marginBottom: 28,
          opacity: animateIn ? 1 : 0, transition: "all 0.6s cubic-bezier(0.16, 1, 0.3, 1) 0.25s"
        }}>
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 10 }}>
            <span style={{ fontSize: 13, fontWeight: 600, fontFamily: "'Space Mono', monospace" }}>
              OPTIMIZATION PROGRESS
            </span>
            <span style={{ fontSize: 13, color: progress === 100 ? "#10B981" : "#64748b" }}>
              {checkedCount}/{totalActions} tasks • {progress}%
            </span>
          </div>
          <div style={{ height: 6, background: "rgba(255,255,255,0.06)", borderRadius: 3, overflow: "hidden" }}>
            <div style={{
              height: "100%", borderRadius: 3, transition: "width 0.5s cubic-bezier(0.16, 1, 0.3, 1)",
              width: `${progress}%`,
              background: progress === 100 ? "#10B981" : "linear-gradient(90deg, #3B82F6, #8B5CF6)"
            }} />
          </div>
        </div>
        {/* Tab Navigation */}
        <div style={{ display: "flex", gap: 4, marginBottom: 24, background: "rgba(255,255,255,0.03)", borderRadius: 12, padding: 4 }}>
          {[
            { id: "overview", label: "Category Breakdown" },
            { id: "filters", label: "Filter Recipes" },
            { id: "quickwins", label: "Quick Wins" }
          ].map(tab => (
            <button key={tab.id} onClick={() => setActiveTab(tab.id)} style={{
              flex: 1, padding: "10px 0", borderRadius: 10, border: "none", cursor: "pointer",
              fontSize: 13, fontWeight: 600, fontFamily: "'DM Sans', sans-serif", transition: "all 0.2s",
              background: activeTab === tab.id ? "rgba(59, 130, 246, 0.15)" : "transparent",
              color: activeTab === tab.id ? "#93c5fd" : "#64748b",
              outline: activeTab === tab.id ? "1px solid rgba(59,130,246,0.3)" : "none"
            }}>
              {tab.label}
            </button>
          ))}
        </div>
        {/* TAB: Overview */}
        {activeTab === "overview" && (
          <div style={{ display: "flex", flexDirection: "column", gap: 10 }}>
            {sorted.map((cat, i) => {
              const isOpen = selectedCategory === i;
              const checkKey = `cat-${i}`;
              return (
                <div key={i} style={{
                  background: "rgba(255,255,255,0.03)", border: `1px solid ${isOpen ? cat.color + "40" : "rgba(255,255,255,0.06)"}`,
                  borderRadius: 14, overflow: "hidden", transition: "all 0.3s",
                  opacity: animateIn ? 1 : 0, transform: animateIn ? "translateY(0)" : "translateY(12px)",
                  transitionDelay: `${0.3 + i * 0.05}s`
                }}>
                  <div onClick={() => setSelectedCategory(isOpen ? null : i)} style={{
                    padding: "14px 18px", cursor: "pointer", display: "flex", alignItems: "center", gap: 14
                  }}>
                    <span style={{ fontSize: 22 }}>{cat.icon}</span>
                    <div style={{ flex: 1 }}>
                      <div style={{ display: "flex", alignItems: "center", gap: 10, marginBottom: 3 }}>
                        <span style={{ fontWeight: 600, fontSize: 15 }}>{cat.name}</span>
                        <span style={{
                          fontSize: 10, fontWeight: 700, padding: "2px 8px", borderRadius: 6,
                          background: priorityColors[cat.priority] + "20", color: priorityColors[cat.priority],
                          fontFamily: "'Space Mono', monospace", letterSpacing: "0.5px"
                        }}>
                          {priorityLabels[cat.priority]}
                        </span>
                      </div>
                      <span style={{ fontSize: 12, color: "#64748b" }}>{cat.count} unread emails</span>
                    </div>
                    <div style={{
                      width: 36, height: 36, borderRadius: 10, display: "flex", alignItems: "center", justifyContent: "center",
                      background: cat.color + "15", color: cat.color, fontWeight: 700, fontSize: 15
                    }}>
                      {cat.count}
                    </div>
                    <span style={{ color: "#475569", fontSize: 18, transition: "transform 0.2s", transform: isOpen ? "rotate(180deg)" : "rotate(0)" }}>▾</span>
                  </div>
                  {isOpen && (
                    <div style={{ padding: "0 18px 16px", borderTop: "1px solid rgba(255,255,255,0.04)" }}>
                      <div style={{ paddingTop: 14 }}>
                        <p style={{ fontSize: 12, color: "#94a3b8", marginBottom: 10, fontFamily: "'Space Mono', monospace", textTransform: "uppercase", letterSpacing: "0.5px" }}>Emails in this group:</p>
                        <div style={{ display: "flex", flexDirection: "column", gap: 4, marginBottom: 14 }}>
                          {cat.emails.map((email, j) => (
                            <div key={j} style={{ fontSize: 13, color: "#cbd5e1", padding: "6px 10px", background: "rgba(255,255,255,0.02)", borderRadius: 8 }}>
                              {email}
                            </div>
                          ))}
                        </div>
                        <div style={{
                          padding: "12px 14px", borderRadius: 10, display: "flex", alignItems: "flex-start", gap: 12,
                          background: cat.color + "08", border: `1px solid ${cat.color}20`
                        }}>
                          <div onClick={() => toggleCheck(checkKey)} style={{
                            width: 20, height: 20, minWidth: 20, borderRadius: 6, cursor: "pointer", marginTop: 1,
                            border: `2px solid ${checkedItems[checkKey] ? cat.color : "#475569"}`,
                            background: checkedItems[checkKey] ? cat.color : "transparent",
                            display: "flex", alignItems: "center", justifyContent: "center", transition: "all 0.2s"
                          }}>
                            {checkedItems[checkKey] && <span style={{ color: "#fff", fontSize: 12, fontWeight: 700 }}>✓</span>}
                          </div>
                          <div>
                            <p style={{ fontSize: 12, fontWeight: 600, margin: "0 0 2px", color: cat.color }}>Recommended Action</p>
                            <p style={{ fontSize: 13, margin: 0, color: "#94a3b8", lineHeight: 1.5 }}>{cat.action}</p>
                          </div>
                        </div>
                      </div>
                    </div>
                  )}
                </div>
              );
            })}
          </div>
        )}
        {/* TAB: Filter Recipes */}
        {activeTab === "filters" && (
          <div>
            <div style={{
              background: "rgba(59,130,246,0.06)", border: "1px solid rgba(59,130,246,0.15)",
              borderRadius: 14, padding: "16px 18px", marginBottom: 20
            }}>
              <p style={{ fontSize: 14, margin: 0, color: "#93c5fd", lineHeight: 1.6 }}>
                <strong>How to set up Gmail filters:</strong> In Gmail, click the search bar dropdown arrow → fill in the "From" field → click "Create filter" → choose actions below.
              </p>
            </div>
            <div style={{ display: "flex", flexDirection: "column", gap: 10 }}>
              {INBOX_DATA.filterSuggestions.map((filter, i) => {
                const checkKey = `filter-${i}`;
                return (
                  <div key={i} style={{
                    background: "rgba(255,255,255,0.03)", border: "1px solid rgba(255,255,255,0.06)",
                    borderRadius: 14, padding: "16px 18px", display: "flex", alignItems: "flex-start", gap: 14
                  }}>
                    <div onClick={() => toggleCheck(checkKey)} style={{
                      width: 20, height: 20, minWidth: 20, borderRadius: 6, cursor: "pointer", marginTop: 2,
                      border: `2px solid ${checkedItems[checkKey] ? "#10B981" : "#475569"}`,
                      background: checkedItems[checkKey] ? "#10B981" : "transparent",
                      display: "flex", alignItems: "center", justifyContent: "center", transition: "all 0.2s"
                    }}>
                      {checkedItems[checkKey] && <span style={{ color: "#fff", fontSize: 12, fontWeight: 700 }}>✓</span>}
                    </div>
                    <div style={{ flex: 1 }}>
                      <div style={{ display: "flex", alignItems: "center", gap: 8, marginBottom: 6, flexWrap: "wrap" }}>
                        <code style={{
                          fontSize: 12, padding: "3px 8px", borderRadius: 6,
                          background: "rgba(139,92,246,0.12)", color: "#c4b5fd", fontFamily: "'Space Mono', monospace"
                        }}>
                          from:{filter.from}
                        </code>
                        <span style={{ fontSize: 11, color: "#475569" }}>→</span>
                        <span style={{
                          fontSize: 11, padding: "3px 8px", borderRadius: 6,
                          background: "rgba(16,185,129,0.12)", color: "#6ee7b7", fontWeight: 600
                        }}>
                          {filter.label}
                        </span>
                      </div>
                      <div style={{ display: "flex", gap: 16, fontSize: 12, color: "#64748b" }}>
                        <span>Action: {filter.action}</span>
                        <span>Impact: <strong style={{ color: "#94a3b8" }}>{filter.impact}</strong></span>
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        )}
        {/* TAB: Quick Wins */}
        {activeTab === "quickwins" && (
          <div style={{ display: "flex", flexDirection: "column", gap: 16 }}>
            {[
              { title: "1. Handle 5 Action Items Right Now", time: "~15 min", desc: "Get Jamie to sign the KWG listing docs, re-activate your DS Logon, review TurboTax return, check CPTS/WSA inspection email, and decide on Sentry (StudyForge).", color: "#EF4444" },
              { title: "2. Accept Cas Caruso's LinkedIn Request", time: "~1 min", desc: "Regional Safety Superintendent from PACAF — a great connection before your Korea PCS in May. Safety networking in the Pacific theater.", color: "#3B82F6" },
              { title: "3. Set Up 3 Gmail Filters", time: "~10 min", desc: "Robinhood, FedEx, and USAA filters alone will auto-sort ~20 emails per week out of your inbox. That's 80+ fewer distractions monthly.", color: "#10B981" },
              { title: "4. Bulk-Archive Financial Confirmations", time: "~5 min", desc: "Select all Robinhood trade confirmations, investment summaries, and balance alerts. Star anything unusual, archive the rest.", color: "#8B5CF6" },
              { title: "5. Unsubscribe from Low-Value Senders", time: "~10 min", desc: "L7 Chicago hotel, Eckert Florist, Cash App promos, Kalshi marketing — unless you actively use these, they're just noise.", color: "#F59E0B" },
              { title: "6. Create a Pre-PCS Label", time: "~5 min", desc: "With Korea in May, label emails related to PCS, property management, and vehicle sale so nothing slips through the cracks.", color: "#06B6D4" },
            ].map((win, i) => (
              <div key={i} style={{
                background: "rgba(255,255,255,0.03)", border: "1px solid rgba(255,255,255,0.06)",
                borderRadius: 14, padding: "18px 20px", position: "relative", overflow: "hidden"
              }}>
                <div style={{
                  position: "absolute", left: 0, top: 0, bottom: 0, width: 3,
                  background: win.color
                }} />
                <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: 6 }}>
                  <h3 style={{ fontSize: 15, fontWeight: 700, margin: 0, color: "#f1f5f9" }}>{win.title}</h3>
                  <span style={{
                    fontSize: 11, padding: "3px 10px", borderRadius: 20,
                    background: "rgba(255,255,255,0.05)", color: "#94a3b8", whiteSpace: "nowrap",
                    fontFamily: "'Space Mono', monospace"
                  }}>
                    ⏱ {win.time}
                  </span>
                </div>
                <p style={{ fontSize: 13, color: "#94a3b8", margin: 0, lineHeight: 1.6 }}>{win.desc}</p>
              </div>
            ))}
            <div style={{
              background: "rgba(16,185,129,0.06)", border: "1px solid rgba(16,185,129,0.15)",
              borderRadius: 14, padding: "18px 20px", textAlign: "center"
            }}>
              <p style={{ fontSize: 14, margin: 0, color: "#6ee7b7", fontWeight: 600 }}>
                Total estimated time: ~45 minutes to transform your inbox
              </p>
              <p style={{ fontSize: 12, margin: "6px 0 0", color: "#64748b" }}>
                These 6 steps should reduce daily inbox noise by approximately 70%
              </p>
            </div>
          </div>
        )}
        {/* Footer */}
        <div style={{
          marginTop: 40, paddingTop: 20, borderTop: "1px solid rgba(255,255,255,0.04)",
          textAlign: "center", fontSize: 11, color: "#334155"
        }}>
          Generated from live Gmail analysis • {new Date().toLocaleDateString()}
        </div>
      </div>
    </div>
  );
}