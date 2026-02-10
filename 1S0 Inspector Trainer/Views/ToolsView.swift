import SwiftUI

struct ToolsView: View {
    @EnvironmentObject private var progress: ProgressStore
    @State private var showRoleSelection = false

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                LazyVStack(alignment: .leading, spacing: AppSpacing.stack) {
                    Text("Feedback")
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

                    ToolSection(title: "Profile") {
                        Button {
                            showRoleSelection = true
                        } label: {
                            ToolCard(
                                title: "Training Role",
                                detail: progress.selectedRole?.displayName ?? "Choose your role"
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .tacticalReadableWidth()
                .padding(AppSpacing.screenPadding)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Feedback")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showRoleSelection) {
            RoleSelectionView(
                title: "Update Training Role",
                subtitle: "Switch roles to see tailored modules and questions.",
                onSelect: { role in
                    progress.setRole(role)
                    showRoleSelection = false
                }
            )
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
                .foregroundColor(AppTheme.muted)
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
                    .font(AppFont.body(13))
                    .foregroundColor(AppTheme.muted)
            }
        }
    }
}

private struct SharePayload: Identifiable {
    let id = UUID()
    let text: String
}

struct BugReportView: View {
    @State private var title = ""
    @State private var steps = ""
    @State private var expected = ""
    @State private var actual = ""
    @State private var sharePayload: SharePayload? = nil

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

                        Button("Share Bug Report") {
                            let text = """
Bug Report
Title: \(title)
Steps: \(steps)
Expected: \(expected)
Actual: \(actual)
"""
                            sharePayload = SharePayload(text: text)
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
        .sheet(item: $sharePayload) { payload in
            ShareSheet(activityItems: [payload.text])
        }
        .navigationTitle("Bug Report")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FeatureRequestView: View {
    @State private var title = ""
    @State private var value = ""
    @State private var details = ""
    @State private var sharePayload: SharePayload? = nil

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

                        Button("Share Feature Request") {
                            let text = """
Feature Request
Title: \(title)
Why it helps: \(value)
Details: \(details)
"""
                            sharePayload = SharePayload(text: text)
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
        .sheet(item: $sharePayload) { payload in
            ShareSheet(activityItems: [payload.text])
        }
        .navigationTitle("Feature")
        .navigationBarTitleDisplayMode(.inline)
    }
}
