import SwiftUI
import SafariServices

struct TrackPickerView: View {
    @EnvironmentObject private var progress: ProgressStore
    @State private var selection: Track?
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                ScrollView {
                    VStack(alignment: .leading, spacing: 28) {
                        Image(systemName: "checkmark.shield").font(.system(size: 44)).foregroundStyle(AppTheme.primary).accessibilityHidden(true)
                        Text(AppBrand.name).font(.largeTitle.bold())
                        Text("Choose your training track").font(.title2.bold())
                        Text("Build practical judgment, one session at a time.").foregroundStyle(.secondary)
                        ForEach(Track.allCases) { track in
                            Button { selection = track } label: {
                                GlassCard {
                                    HStack(alignment: .top, spacing: 16) {
                                        VStack(alignment: .leading, spacing: 8) { Text(track.title).font(.headline); Text(track.detail).font(.body).foregroundStyle(.secondary) }
                                        Spacer(minLength: 0)
                                        Image(systemName: selection == track ? "checkmark.circle.fill" : "circle").foregroundStyle(selection == track ? AppTheme.primary : AppTheme.muted)
                                    }
                                }
                            }.buttonStyle(.plain).accessibilityIdentifier("track-\(track.rawValue)").accessibilityAddTraits(selection == track ? .isSelected : [])
                        }
                        Button("Continue") { if let selection { progress.selectTrack(selection); progress.dismissTrackBanner() } }
                            .buttonStyle(PrimaryButtonStyle()).disabled(selection == nil).accessibilityIdentifier("track-continue")
                        Text(AppBrand.disclaimer).font(.footnote).foregroundStyle(.secondary)
                    }.tacticalReadableWidth(650).padding(24)
                }
            }
        }.interactiveDismissDisabled()
    }
}

struct TrackSettingsView: View {
    @EnvironmentObject private var progress: ProgressStore
    @Environment(\.dismiss) private var dismiss
    @State private var proposed: Track?
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                ScrollView {
                    GlassCard {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Training track").font(.title2.bold())
                            Picker("Training track", selection: Binding(get: { progress.selectedTrack ?? .airForce }, set: { proposed = $0 })) {
                                ForEach(Track.allCases) { Text($0.title).tag($0) }
                            }.pickerStyle(.segmented).accessibilityIdentifier("training-track-picker")
                            Text("Your XP, streak, and progress are kept. Modules not in this track are hidden, not deleted.").foregroundStyle(.secondary)
                        }
                    }.tacticalReadableWidth().padding(20)
                }
            }.navigationTitle("Settings").toolbar { ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } } }
            .sheet(item: $proposed) { track in
                VStack(alignment: .leading, spacing: 24) {
                    Text("Switch to \(track.title)?").font(.title2.bold())
                    Text("Your XP, streak, and progress are kept. Modules not in this track are hidden, not deleted.")
                    Button("Switch track") { progress.selectTrack(track); proposed = nil }.buttonStyle(PrimaryButtonStyle()).accessibilityIdentifier("confirm-track-switch")
                    Button("Cancel") { proposed = nil }.frame(maxWidth: .infinity, minHeight: 44)
                }.padding(24).presentationDetents([.medium, .large])
            }
        }
    }
}

struct HiddenSessionNotice: View {
    @EnvironmentObject private var progress: ProgressStore
    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                Label("Session unavailable in this track", systemImage: "info.circle").font(.headline)
                Text("Your unfinished session includes hidden questions. Your previous progress is preserved.").foregroundStyle(.secondary)
                Button("Restart in this track") { progress.restartHiddenSession() }.buttonStyle(.bordered)
            }
        }
    }
}

struct OSHAStandardsView: View {
    @EnvironmentObject private var progress: ProgressStore
    @State private var selected: WebReference?
    var body: some View {
        ZStack {
            BackgroundView()
            ScrollView {
                GlassCard {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("OSHA Standards").font(.title2.bold())
                        Text("General industry • 29 CFR 1910 and 1904").foregroundStyle(.secondary)
                        ForEach(progress.catalog.standards, id: \.title) { reference in
                            Button { selected = WebReference(url: reference.url) } label: {
                                HStack { Text(reference.title); Spacer(); Image(systemName: "arrow.up.right.square") }.frame(minHeight: 44)
                            }
                            Divider()
                        }
                        Text("Links connect only when opened. Training explanations remain available offline.").font(.footnote).foregroundStyle(.secondary)
                    }
                }.tacticalReadableWidth().padding(20)
            }
        }.navigationTitle("OSHA Standards").sheet(item: $selected) { SafariReferenceView(url: $0.url) }
    }
}
struct WebReference: Identifiable { let url: URL; var id: String { url.absoluteString } }
struct SafariReferenceView: UIViewControllerRepresentable {
    let url: URL
    func makeUIViewController(context: Context) -> SFSafariViewController { SFSafariViewController(url: url) }
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

extension View {
    @ViewBuilder func trackGlass() -> some View {
        if #available(iOS 26, *) { self.glassEffect(.regular.interactive(), in: .capsule) }
        else { self.background(.regularMaterial, in: Capsule()) }
    }
}

struct TrackGlassContainer<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) { self.content = content() }
    var body: some View {
        if #available(iOS 26, *) { GlassEffectContainer(spacing: 16) { content } }
        else { content }
    }
}
