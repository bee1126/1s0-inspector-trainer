import SwiftUI

struct ToolsView: View {
    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
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
                }
                .padding(20)
            }
        }
        .navigationTitle("Feedback")
        .navigationBarTitleDisplayMode(.inline)
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

            GlassCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Bug Fix Report")
                        .font(AppFont.title(22))
                        .foregroundColor(AppTheme.charcoal)

                    TextField("Short title", text: $title)
                        .textFieldStyle(.roundedBorder)

                    Text("Steps to reproduce")
                        .font(AppFont.subtitle(14))
                    TextEditor(text: $steps)
                        .frame(height: 90)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.2)))

                    Text("Expected result")
                        .font(AppFont.subtitle(14))
                    TextEditor(text: $expected)
                        .frame(height: 70)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.2)))

                    Text("Actual result")
                        .font(AppFont.subtitle(14))
                    TextEditor(text: $actual)
                        .frame(height: 70)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.2)))

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
            .padding(20)
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

            GlassCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Feature Request")
                        .font(AppFont.title(22))
                        .foregroundColor(AppTheme.charcoal)

                    TextField("Feature title", text: $title)
                        .textFieldStyle(.roundedBorder)

                    Text("Why this helps")
                        .font(AppFont.subtitle(14))
                    TextEditor(text: $value)
                        .frame(height: 80)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.2)))

                    Text("Details")
                        .font(AppFont.subtitle(14))
                    TextEditor(text: $details)
                        .frame(height: 80)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.2)))

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
            .padding(20)
        }
        .sheet(isPresented: $showShare) {
            ShareSheet(activityItems: shareItems)
        }
        .navigationTitle("Feature")
        .navigationBarTitleDisplayMode(.inline)
    }
}
