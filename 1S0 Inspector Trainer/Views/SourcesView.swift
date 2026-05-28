import SwiftUI

struct SourcesView: View {
    private let references = TrainingContent.references

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                LazyVStack(alignment: .leading, spacing: AppSpacing.section) {
                    Text("Sources")
                        .font(AppFont.title(26))
                        .foregroundColor(AppTheme.text)

                    NavigationLink {
                        GlossaryView()
                    } label: {
                        GlassCard(glow: AppTheme.primary.opacity(0.35)) {
                            HStack(spacing: 12) {
                                Image(systemName: "text.book.closed.fill")
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundColor(AppTheme.primary)
                                    .frame(width: 34, height: 34)

                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Safety Glossary")
                                        .font(AppFont.subtitle(17))
                                        .foregroundColor(AppTheme.text)
                                    Text("Search verified 1S0, OSHA, DAFMAN, and risk management terms.")
                                        .font(AppFont.body(13))
                                        .foregroundColor(AppTheme.muted)
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(AppTheme.muted)
                            }
                        }
                    }
                    .buttonStyle(.plain)

                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("REFERENCE MATERIALS")
                                .font(AppFont.mono(11))
                                .foregroundColor(AppTheme.muted)

                            ForEach(references.indices, id: \.self) { index in
                                let source = references[index]
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(source.title)
                                        .font(AppFont.subtitle(15))
                                        .foregroundColor(AppTheme.text)
                                    Text(source.date)
                                        .font(AppFont.mono(11))
                                        .foregroundColor(AppTheme.muted)
                                    Text(source.notes)
                                        .font(AppFont.body(12))
                                        .foregroundColor(AppTheme.muted)
                                    if let url = source.url {
                                        Link(destination: url) {
                                            Label("Open in App Store", systemImage: "arrow.up.right.square")
                                                .font(AppFont.subtitle(12))
                                                .foregroundColor(AppTheme.primary)
                                        }
                                        .accessibilityHint("Opens \(source.title) outside this app.")
                                    }
                                }
                                if index < references.count - 1 {
                                    Divider().opacity(0.3)
                                }
                            }
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("PRIVACY & DATA USE")
                                .font(AppFont.mono(11))
                                .foregroundColor(AppTheme.muted)
                            Text("This app stores training progress only on your device. No analytics, advertising, or external data sharing is enabled by default.")
                                .font(AppFont.body(13))
                                .foregroundColor(AppTheme.muted)
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("DISCLAIMER")
                                .font(AppFont.mono(11))
                                .foregroundColor(AppTheme.muted)
                            Text("This application is not an official Air Force product. It is a training aid intended to reinforce published guidance and OSHA standards. Always follow unit-specific procedures and the most current official publications.")
                                .font(AppFont.body(13))
                                .foregroundColor(AppTheme.muted)
                        }
                    }
                }
                .tacticalReadableWidth()
                .padding(AppSpacing.screenPadding)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Sources")
        .navigationBarTitleDisplayMode(.inline)
    }
}
