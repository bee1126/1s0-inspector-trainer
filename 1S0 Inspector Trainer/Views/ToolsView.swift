import SwiftUI

struct ToolsView: View {
    @EnvironmentObject private var progress: ProgressStore
    @State private var showRoleSelection = false

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                LazyVStack(alignment: .leading, spacing: AppSpacing.stack) {
                    Text("Comms & Tools")
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
        .navigationTitle("Comms")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showRoleSelection) {
            RoleSelectionView(
                title: "Training Profile",
                subtitle: "Review the active inspector profile used for content, progress, and onboarding.",
                initialRole: progress.selectedRole,
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
                            let subject = "Bug Report: \(title)"
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
                            let subject = "Feature Request: \(title)"
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
