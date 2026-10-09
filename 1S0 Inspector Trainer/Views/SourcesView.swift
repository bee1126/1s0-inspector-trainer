import SwiftUI

struct SourcesView: View {
    @EnvironmentObject private var progress: ProgressStore
    private let references = TrainingContent.references

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                LazyVStack(alignment: .leading, spacing: AppSpacing.section) {
                    Text("Your reference library")
                        .font(AppFont.title(26))
                        .foregroundColor(AppTheme.text)

                    NavigationLink { EpubsLibraryView(favoritesOnly: true) } label: {
                        ActionCard(title: "Saved publications", detail: "\(progress.favoriteEpubPublicationIds.count) watched references", icon: "bookmark")
                    }.buttonStyle(.plain)

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
                                        .font(AppFont.body(16))
                                        .foregroundColor(AppTheme.text.opacity(0.68))
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(AppTheme.text.opacity(0.68))
                            }
                        }
                    }
                    .buttonStyle(.plain)

                    NavigationLink {
                        EpubsLibraryView()
                    } label: {
                        GlassCard(glow: AppTheme.primary.opacity(0.35)) {
                            HStack(spacing: 12) {
                                Image(systemName: "checkmark.shield.fill")
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundColor(AppTheme.primary)
                                    .frame(width: 34, height: 34)

                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Live DAF e-Pubs")
                                        .font(AppFont.subtitle(17))
                                        .foregroundColor(AppTheme.text)
                                    Text("Open and verify official safety publications.")
                                        .font(AppFont.body(16))
                                        .foregroundColor(AppTheme.text.opacity(0.68))
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(AppTheme.text.opacity(0.68))
                            }
                        }
                    }
                    .buttonStyle(.plain)

                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("REFERENCE MATERIALS")
                                .font(AppFont.mono(11))
                                .foregroundColor(AppTheme.text.opacity(0.68))

                            ForEach(Array(references.enumerated()), id: \.element.id) { index, source in
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(source.title)
                                        .font(AppFont.subtitle(15))
                                        .foregroundColor(AppTheme.text)
                                    Text(source.date)
                                        .font(AppFont.mono(11))
                                        .foregroundColor(AppTheme.text.opacity(0.68))
                                    Text(source.notes)
                                        .font(AppFont.body(16))
                                        .foregroundColor(AppTheme.text.opacity(0.68))
                                    if let url = source.url {
                                        Link(destination: url) {
                                            Label("Open Reference", systemImage: "arrow.up.right.square")
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
                                .foregroundColor(AppTheme.text.opacity(0.68))
                            Text("This app stores training progress only on your device. No analytics or advertising is enabled. The Live e-Pubs screen contacts the official DAF e-Publishing service only when you open or refresh it.")
                                .font(AppFont.body(16))
                                .foregroundColor(AppTheme.text.opacity(0.68))
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("DISCLAIMER")
                                .font(AppFont.mono(11))
                                .foregroundColor(AppTheme.text.opacity(0.68))
                            Text("This app is not an official Department of the Air Force product. It is a supplemental training aid intended to reinforce published guidance and OSHA standards. Always follow unit-specific procedures and the most current official publications.")
                                .font(AppFont.body(16))
                                .foregroundColor(AppTheme.text.opacity(0.68))
                        }
                    }
                }
                .tacticalReadableWidth()
                .padding(AppSpacing.screenPadding)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Library").navigationBarTitleDisplayMode(.inline)
        .navigationBarTitleDisplayMode(.inline)
    }
}
