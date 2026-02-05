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
                        .foregroundColor(.white)

                    ToolSection(title: "Feedback") {
                        NavigationLink { BugReportView() } label: {
                            ToolCard(title: "Bug Fix Reports", detail: "Capture issues to share with the dev team")
                        }
                        NavigationLink { FeatureRequestView() } label: {
                            ToolCard(title: "Feature Requests", detail: "Submit ideas for future updates")
                        }
                    }

                    ToolSection(title: "Developer") {
                        Button {
                            progress.restoreAllHearts()
                        } label: {
                            ToolCard(title: "Restore Hearts", detail: "Refill all hearts for testing")
                        }
                        .buttonStyle(.plain)

                        Button {
                            progress.debugMaxRank(modules: TrainingContent.modules(for: progress.selectedRole))
                        } label: {
                            ToolCard(title: "Max Rank & Level", detail: "Complete every module and boost XP")
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
            Text(title)
                .font(AppFont.subtitle(18))
                .foregroundColor(.white)
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
                    .foregroundColor(AppTheme.charcoal)
                Text(detail)
                    .font(AppFont.body(13))
                    .foregroundColor(AppTheme.charcoal.opacity(0.7))
            }
        }
    }
}

struct BugReportView: View {
    @State private var title = ""
    @State private var steps = ""
    @State private var expected = ""
    @State private var actual = ""
    @State private var shareItems: [Any] = []
    @State private var showShare = false

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                GlassCard {
                    VStack(alignment: .leading, spacing: AppSpacing.item) {
                        Text("Bug Fix Report")
                            .font(AppFont.title(22))
                            .foregroundColor(AppTheme.charcoal)

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
                            shareItems = [text]
                            showShare = true
                        }
                        .buttonStyle(PrimaryButtonStyle())
                    }
                }
                .padding(AppSpacing.screenPadding)
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.interactively)
        }
        .sheet(isPresented: $showShare) {
            ShareSheet(activityItems: shareItems)
        }
        .navigationTitle("Bug Report")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FeatureRequestView: View {
    @State private var title = ""
    @State private var value = ""
    @State private var details = ""
    @State private var shareItems: [Any] = []
    @State private var showShare = false

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                GlassCard {
                    VStack(alignment: .leading, spacing: AppSpacing.item) {
                        Text("Feature Request")
                            .font(AppFont.title(22))
                            .foregroundColor(AppTheme.charcoal)

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
                            shareItems = [text]
                            showShare = true
                        }
                        .buttonStyle(PrimaryButtonStyle())
                    }
                }
                .padding(AppSpacing.screenPadding)
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.interactively)
        }
        .sheet(isPresented: $showShare) {
            ShareSheet(activityItems: shareItems)
        }
        .navigationTitle("Feature")
        .navigationBarTitleDisplayMode(.inline)
    }
}
