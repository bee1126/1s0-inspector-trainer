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

                    if progress.catalog.showsDAFTools {
                    NavigationLink { EpubsLibraryView(favoritesOnly: true) } label: {
                        ActionCard(title: "Saved publications", detail: "\(progress.favoriteEpubPublicationIds.count) watched references", icon: "bookmark")
                    }.buttonStyle(.plain)

                    }
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
                                    Text("Search terms and references for your training track.")
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

                    if progress.catalog.showsDAFTools {
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

                    } else {
                        NavigationLink { OSHAStandardsView() } label: { ActionCard(title: "OSHA Standards", detail: "Current eCFR section links", icon: "text.book.closed") }.buttonStyle(.plain)
                    }
                    NavigationLink { SavedQuestionsView() } label: { ActionCard(title: "Saved questions", detail: "\(progress.hiddenBookmarkCount) bookmarks hidden in this track.", icon: "bookmark") }.buttonStyle(.plain)
                    if progress.catalog.showsDAFTools {
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

                    }
                    GlassCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("PRIVACY & DATA USE")
                                .font(AppFont.mono(11))
                                .foregroundColor(AppTheme.text.opacity(0.68))
                            Text("Progress and hazard reports stay on your device. No analytics, ads, or third-party SDKs. Links connect when opened; no account is required.")
                                .font(AppFont.body(16))
                                .foregroundColor(AppTheme.text.opacity(0.68))
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("DISCLAIMER")
                                .font(AppFont.mono(11))
                                .foregroundColor(AppTheme.text.opacity(0.68))
                            Text(AppBrand.disclaimer)
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
