import SwiftUI

struct ToolsView: View {
    @EnvironmentObject private var progress: ProgressStore
    @State private var showInspectorProfile = false
    @State private var showTrackSettings = false
    @State private var deleteReports = false
    @State private var reportError: String?

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                LazyVStack(alignment: .leading, spacing: AppSpacing.stack) {
                    Text("Profile & Feedback")
                        .font(AppFont.title(26))
                        .foregroundColor(AppTheme.text)

                    ToolSection(title: "Feedback") {
                        NavigationLink { BugReportView() } label: {
                            ToolCard(title: "Bug Fix Reports", detail: "Capture issues to share with the dev team")
                        }
                        .buttonStyle(.plain)
                        NavigationLink { FeatureRequestView() } label: {
                            ToolCard(title: "Feature Requests", detail: "Submit ideas for future updates")
                        }
                        .buttonStyle(.plain)
                    }

                    Button { showTrackSettings = true } label: { ToolCard(title: "Training track", detail: progress.selectedTrack?.title ?? "Choose a track") }.buttonStyle(.plain)
                    GlassCard { VStack(alignment: .leading, spacing: 12) {
                        Text(AppBrand.about).font(.headline)
                        Link("abdoulbah1126@gmail.com", destination: URL(string: "mailto:abdoulbah1126@gmail.com")!)
                        Text(AppBrand.disclaimer).font(.footnote).foregroundStyle(.secondary)
                    } }
                    Button("Delete all reports", role: .destructive) { deleteReports = true }.frame(minHeight: 44)
                    if let reportError { Text(reportError).foregroundStyle(AppTheme.danger) }

                }
                .tacticalReadableWidth()
                .padding(AppSpacing.screenPadding)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showTrackSettings) { TrackSettingsView() }
        .confirmationDialog("Delete all local hazard reports?", isPresented: $deleteReports, titleVisibility: .visible) {
            Button("Delete all reports", role: .destructive) {
                do { try LocalHazardReportStore().deleteAll() } catch { reportError = error.localizedDescription }
            }
        }

    }
}

struct ToolSection<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title.uppercased())
                .font(AppFont.mono(11))
                .foregroundColor(AppTheme.text.opacity(0.68))
            content
        }
    }
}

struct ToolCard: View {
    let title: String
    let detail: String

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(AppFont.subtitle(17))
                    .foregroundColor(AppTheme.text)
                Text(detail)
                    .font(AppFont.body(16))
                    .foregroundColor(AppTheme.text.opacity(0.68))
            }
        }
    }
}

private func mailtoURL(to: String, subject: String, body: String) -> URL? {
    var components = URLComponents()
    components.scheme = "mailto"
    components.path = to
    components.queryItems = [
        URLQueryItem(name: "subject", value: subject),
        URLQueryItem(name: "body", value: body)
    ]
    return components.url
}

struct BugReportView: View {
    @State private var title = ""
    @State private var steps = ""
    @State private var expected = ""
    @State private var actual = ""

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                GlassCard {
                    VStack(alignment: .leading, spacing: AppSpacing.item) {
                        Text("Bug Fix Report")
                            .font(AppFont.title(22))
                            .foregroundColor(AppTheme.text)

                        FormFieldLabel(text: "Short title")
                        AppTextField(placeholder: "Brief summary", text: $title)

                        FormFieldLabel(text: "Steps to reproduce")
                        AppTextEditor(text: $steps, height: 100)

                        FormFieldLabel(text: "Expected result")
                        AppTextEditor(text: $expected, height: 80)

                        FormFieldLabel(text: "Actual result")
                        AppTextEditor(text: $actual, height: 80)

                        Button("Submit Bug Report") {
                            let subject = "\(AppBrand.name) feedback: Bug report — \(title)"
                            let body = """
Bug Report

Title: \(title)

Steps to Reproduce:
\(steps)

Expected Result:
\(expected)

Actual Result:
\(actual)
"""
                            if let url = mailtoURL(to: "abdoulbah1126@gmail.com", subject: subject, body: body) {
                                UIApplication.shared.open(url)
                            }
                        }
                        .buttonStyle(PrimaryButtonStyle())
                    }
                }
                .tacticalReadableWidth()
                .padding(AppSpacing.screenPadding)
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.interactively)
        }
        .navigationTitle("Bug Report")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FeatureRequestView: View {
    @State private var title = ""
    @State private var value = ""
    @State private var details = ""

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                GlassCard {
                    VStack(alignment: .leading, spacing: AppSpacing.item) {
                        Text("Feature Request")
                            .font(AppFont.title(22))
                            .foregroundColor(AppTheme.text)

                        FormFieldLabel(text: "Feature title")
                        AppTextField(placeholder: "Short descriptive title", text: $title)

                        FormFieldLabel(text: "Why this helps")
                        AppTextEditor(text: $value, height: 90)

                        FormFieldLabel(text: "Details")
                        AppTextEditor(text: $details, height: 90)

                        Button("Submit Feature Request") {
                            let subject = "\(AppBrand.name) feedback: Feature request — \(title)"
                            let body = """
Feature Request

Title: \(title)

Why This Helps:
\(value)

Details:
\(details)
"""
                            if let url = mailtoURL(to: "abdoulbah1126@gmail.com", subject: subject, body: body) {
                                UIApplication.shared.open(url)
                            }
                        }
                        .buttonStyle(PrimaryButtonStyle())
                    }
                }
                .tacticalReadableWidth()
                .padding(AppSpacing.screenPadding)
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.interactively)
        }
        .navigationTitle("Feature")
        .navigationBarTitleDisplayMode(.inline)
    }
}
