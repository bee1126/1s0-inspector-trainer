import SwiftUI

struct GlossaryView: View {
    @State private var searchText = ""
    @State private var selectedCategory: GlossaryCategory?

    private var filteredTerms: [GlossaryTerm] {
        GlossaryContent.terms
            .filter { term in
                (selectedCategory == nil || term.category == selectedCategory) && term.matches(searchText)
            }
            .sorted { lhs, rhs in
                lhs.term.localizedCaseInsensitiveCompare(rhs.term) == .orderedAscending
            }
    }

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                LazyVStack(alignment: .leading, spacing: AppSpacing.section) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Safety Glossary")
                            .font(AppFont.title(26))
                            .foregroundColor(AppTheme.text)
                        Text("\(GlossaryContent.terms.count) verified field terms for safety inspections, hazard reports, and practice scenarios.")
                            .font(AppFont.body(13))
                            .foregroundColor(AppTheme.muted)
                    }

                    categoryRail

                    if filteredTerms.isEmpty {
                        GlassCard {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("No Matches")
                                    .font(AppFont.subtitle(16))
                                    .foregroundColor(AppTheme.text)
                                Text("Try a different term, acronym, source, or category.")
                                    .font(AppFont.body(13))
                                    .foregroundColor(AppTheme.muted)
                            }
                        }
                    } else {
                        ForEach(filteredTerms) { term in
                            NavigationLink {
                                GlossaryDetailView(term: term)
                            } label: {
                                GlossaryTermCard(term: term)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .tacticalReadableWidth()
                .padding(AppSpacing.screenPadding)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Glossary")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search terms")
    }

    private var categoryRail: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                GlossaryCategoryChip(title: "All", isSelected: selectedCategory == nil) {
                    selectedCategory = nil
                }

                ForEach(GlossaryCategory.allCases) { category in
                    GlossaryCategoryChip(title: category.rawValue, isSelected: selectedCategory == category) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.vertical, 2)
        }
        .scrollIndicators(.hidden)
        .accessibilityLabel("Glossary categories")
    }
}

private struct GlossaryTermCard: View {
    let term: GlossaryTerm

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(term.displayTitle)
                            .font(AppFont.subtitle(17))
                            .foregroundColor(AppTheme.text)
                            .multilineTextAlignment(.leading)
                        Text(term.category.rawValue.uppercased())
                            .font(AppFont.mono(10))
                            .foregroundColor(AppTheme.primary)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(AppTheme.muted)
                        .padding(.top, 3)
                }

                Text(term.definition)
                    .font(AppFont.body(13))
                    .foregroundColor(AppTheme.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

private struct GlossaryDetailView: View {
    let term: GlossaryTerm

    private var relatedModules: [TrainingModule] {
        let modules = TrainingContent.modules(for: nil)
        return term.moduleIds.compactMap { moduleId in
            modules.first { $0.id == moduleId }
        }
    }

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                LazyVStack(alignment: .leading, spacing: AppSpacing.section) {
                    GlassCard(glow: AppTheme.primary.opacity(0.35)) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(term.category.rawValue.uppercased())
                                .font(AppFont.mono(11))
                                .foregroundColor(AppTheme.primary)
                                .tracking(1)

                            Text(term.displayTitle)
                                .font(AppFont.title(24))
                                .foregroundColor(AppTheme.text)
                                .fixedSize(horizontal: false, vertical: true)

                            if let abbreviation = term.abbreviation {
                                TagPill(text: abbreviation)
                            }
                        }
                    }

                    GlossaryDetailSection(title: "Definition") {
                        Text(term.definition)
                            .font(AppFont.body(14))
                            .foregroundColor(AppTheme.text)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    GlossaryDetailSection(title: "Inspector Use") {
                        Text(term.fieldUse)
                            .font(AppFont.body(14))
                            .foregroundColor(AppTheme.text)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    if !relatedModules.isEmpty {
                        GlossaryDetailSection(title: "Related Training") {
                            FlowPillLayout(items: relatedModules.map(\.title))
                        }
                    }

                    GlossaryDetailSection(title: "Source") {
                        Text(term.sourceCitation)
                            .font(AppFont.body(13))
                            .foregroundColor(AppTheme.muted)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    if !term.keywords.isEmpty {
                        GlossaryDetailSection(title: "Search Terms") {
                            FlowPillLayout(items: term.keywords.sorted())
                        }
                    }
                }
                .tacticalReadableWidth()
                .padding(AppSpacing.screenPadding)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Term")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct GlossaryDetailSection<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 8) {
                Text(title.uppercased())
                    .font(AppFont.mono(11))
                    .foregroundColor(AppTheme.muted)
                    .tracking(1)
                content
            }
        }
    }
}

private struct GlossaryCategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFont.mono(11))
                .foregroundColor(isSelected ? AppTheme.bg : AppTheme.text)
                .lineLimit(1)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(isSelected ? AppTheme.primary : AppTheme.surface)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .stroke(isSelected ? AppTheme.primary : AppTheme.border, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

private struct FlowPillLayout: View {
    let items: [String]

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 8)], alignment: .leading, spacing: 8) {
            ForEach(items, id: \.self) { item in
                Text(item)
                    .font(AppFont.mono(10))
                    .foregroundColor(AppTheme.muted)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
                    .frame(maxWidth: .infinity, minHeight: 30, alignment: .leading)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .fill(AppTheme.border.opacity(0.6))
                    )
            }
        }
    }
}
