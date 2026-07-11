import SwiftUI
import UniformTypeIdentifiers

struct EpubsPDFDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.pdf] }

    let data: Data

    init(data: Data) {
        self.data = data
    }

    init(configuration: ReadConfiguration) throws {
        data = configuration.file.regularFileContents ?? Data()
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: data)
    }
}

struct EpubsLibraryView: View {
    @EnvironmentObject private var progress: ProgressStore
    @Environment(\.openURL) private var openURL
    @StateObject private var service = EpubsCatalogService()
    @State private var searchText: String
    @State private var downloadingPublicationId: String?
    @State private var exportDocument: EpubsPDFDocument?
    @State private var exportFilename = "DAF-Publication"
    @State private var showFileExporter = false
    @State private var alertMessage = ""
    @State private var showAlert = false

    init(focusPublicationId: String? = nil) {
        let initialSearch = focusPublicationId
            .flatMap(EpubsCatalog.publication(id:))?
            .number ?? ""
        _searchText = State(initialValue: initialSearch)
    }

    private var filteredPublications: [EpubsPublication] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let matches: [EpubsPublication]
        if query.isEmpty {
            matches = EpubsCatalog.publications
        } else {
            matches = EpubsCatalog.publications.filter {
                $0.number.localizedCaseInsensitiveContains(query)
                    || $0.title.localizedCaseInsensitiveContains(query)
                    || $0.summary.localizedCaseInsensitiveContains(query)
            }
        }

        return matches.sorted { left, right in
            let leftFavorite = progress.isFavoriteEpubPublication(left.id)
            let rightFavorite = progress.isFavoriteEpubPublication(right.id)
            if leftFavorite != rightFavorite { return leftFavorite }
            return left.number.localizedStandardCompare(right.number) == .orderedAscending
        }
    }

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                LazyVStack(alignment: .leading, spacing: AppSpacing.section) {
                    introCard
                    searchCard

                    if filteredPublications.isEmpty {
                        emptyState
                    } else {
                        ForEach(filteredPublications) { publication in
                            publicationCard(publication)
                        }
                    }

                    disclaimerCard
                }
                .tacticalReadableWidth()
                .padding(AppSpacing.screenPadding)
            }
            .scrollIndicators(.hidden)
            .refreshable {
                await refreshCatalog()
            }
        }
        .navigationTitle("Live e-Pubs")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if service.lastChecked == nil {
                await refreshCatalog()
            }
        }
        .fileExporter(
            isPresented: $showFileExporter,
            document: exportDocument,
            contentType: .pdf,
            defaultFilename: exportFilename
        ) { result in
            switch result {
            case .success:
                alertMessage = "The official PDF was saved to Files for offline use."
                showAlert = true
            case .failure(let error):
                alertMessage = "The PDF could not be saved: \(error.localizedDescription)"
                showAlert = true
            }
            exportDocument = nil
        }
        .alert("Live e-Pubs", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }

    private var introCard: some View {
        GlassCard(glow: AppTheme.primary.opacity(0.35)) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 10) {
                    Image(systemName: "checkmark.shield.fill")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(AppTheme.primary)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("OFFICIAL DAF E-PUBLISHING")
                            .font(AppFont.mono(11))
                            .foregroundColor(AppTheme.primary)
                        Text("Official Publication Links")
                            .font(AppFont.subtitle(18))
                            .foregroundColor(AppTheme.text)
                    }

                    Spacer()

                    if service.isRefreshing {
                        ProgressView()
                            .tint(AppTheme.primary)
                            .accessibilityLabel("Checking e-Pubs")
                    } else {
                        Button {
                            Task { await refreshCatalog() }
                        } label: {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(AppTheme.primary)
                                .frame(width: AppSpacing.minTapTarget, height: AppSpacing.minTapTarget)
                        }
                        .accessibilityLabel("Refresh e-Pubs status")
                    }
                }

                Text("Check official DAF publication links, watch key regulations for server revisions, or save a copy to Files for offline field use.")
                    .font(AppFont.body(13))
                    .foregroundColor(AppTheme.muted)

                if let lastChecked = service.lastChecked {
                    Text("CHECKED \(lastChecked.formatted(date: .abbreviated, time: .shortened).uppercased())")
                        .font(AppFont.mono(10))
                        .foregroundColor(AppTheme.muted)
                }
            }
        }
    }

    private var searchCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 10) {
                Text("FIND A PUBLICATION")
                    .font(AppFont.mono(11))
                    .foregroundColor(AppTheme.muted)

                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(AppTheme.muted)
                    TextField("Publication number or title", text: $searchText)
                        .font(AppFont.body(14))
                        .foregroundColor(AppTheme.text)
                        .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()
                }
                .padding(.horizontal, 12)
                .frame(minHeight: AppSpacing.minTapTarget)
                .background(AppTheme.bg.opacity(0.7))
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(AppTheme.border, lineWidth: 1)
                )

                Link(destination: EpubsCatalog.searchURL(for: searchText)) {
                    Label(
                        searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                            ? "Browse all official e-Pubs"
                            : "Search all e-Pubs for \(searchText)",
                        systemImage: "safari"
                    )
                    .font(AppFont.subtitle(13))
                    .foregroundColor(AppTheme.primary)
                }
                .accessibilityHint("Opens the official Department of the Air Force e-Publishing website.")
            }
        }
    }

    private func publicationCard(_ publication: EpubsPublication) -> some View {
        let snapshot = progress.epubPublicationSnapshots[publication.id]

        return GlassCard(glow: snapshot?.hasUnreadRevision == true ? AppTheme.accent : AppTheme.border) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 7) {
                            Text(publication.number)
                                .font(AppFont.mono(12))
                                .foregroundColor(AppTheme.primary)
                            if snapshot?.hasUnreadRevision == true {
                                updateBadge
                            }
                        }
                        Text(publication.title)
                            .font(AppFont.subtitle(16))
                            .foregroundColor(AppTheme.text)
                    }

                    Spacer(minLength: 8)

                    Button {
                        progress.toggleFavoriteEpubPublication(publication.id)
                    } label: {
                        Image(systemName: progress.isFavoriteEpubPublication(publication.id) ? "star.fill" : "star")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(progress.isFavoriteEpubPublication(publication.id) ? AppTheme.accent : AppTheme.muted)
                            .frame(width: AppSpacing.minTapTarget, height: AppSpacing.minTapTarget)
                    }
                    .accessibilityLabel(
                        progress.isFavoriteEpubPublication(publication.id)
                            ? "Stop watching \(publication.number)"
                            : "Watch \(publication.number) for updates"
                    )
                }

                HStack {
                    statusBadge(for: service.status(for: publication))
                    Spacer()
                    if progress.isFavoriteEpubPublication(publication.id) {
                        Label("WATCHING", systemImage: "star.fill")
                            .font(AppFont.mono(9))
                            .foregroundColor(AppTheme.accent)
                    }
                }

                Text(publication.summary)
                    .font(AppFont.body(13))
                    .foregroundColor(AppTheme.muted)

                if let metadata = currentMetadata(for: publication),
                   let lastModified = metadata.lastModified,
                   !lastModified.isEmpty {
                    Text("SERVER MODIFIED \(lastModified.uppercased())")
                        .font(AppFont.mono(9))
                        .foregroundColor(AppTheme.muted)
                }

                if let lastChecked = snapshot?.lastChecked {
                    Text("REVISION CHECK \(lastChecked.formatted(date: .abbreviated, time: .shortened).uppercased())")
                        .font(AppFont.mono(9))
                        .foregroundColor(AppTheme.muted)
                }

                Divider().opacity(0.3)

                Button {
                    progress.markEpubsPublicationViewed(publication.id)
                    openURL(publication.pdfURL)
                } label: {
                    actionLabel("Open Official PDF", icon: "doc.richtext")
                }
                .accessibilityHint("Opens the official e-Pubs PDF outside this app.")

                Button {
                    Task { await saveOffline(publication) }
                } label: {
                    if downloadingPublicationId == publication.id {
                        HStack(spacing: 8) {
                            ProgressView().tint(AppTheme.primary)
                            Text("Downloading Official PDF…")
                        }
                        .font(AppFont.subtitle(13))
                        .foregroundColor(AppTheme.primary)
                        .frame(maxWidth: .infinity, minHeight: AppSpacing.minTapTarget, alignment: .leading)
                    } else {
                        actionLabel("Save to Files for Offline Use", icon: "arrow.down.doc")
                    }
                }
                .disabled(downloadingPublicationId != nil)

                Button {
                    reportBrokenLink(publication)
                } label: {
                    actionLabel("Report Broken Publication Link", icon: "exclamationmark.bubble")
                        .foregroundColor(AppTheme.accent)
                }
            }
        }
    }

    private var updateBadge: some View {
        Text("UPDATED")
            .font(AppFont.mono(8))
            .foregroundColor(AppTheme.bg)
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(AppTheme.accent)
            .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
    }

    private func actionLabel(_ text: String, icon: String) -> some View {
        Label(text, systemImage: icon)
            .font(AppFont.subtitle(13))
            .foregroundColor(AppTheme.primary)
            .frame(maxWidth: .infinity, minHeight: AppSpacing.minTapTarget, alignment: .leading)
            .contentShape(Rectangle())
    }

    private func statusBadge(for status: EpubsReachability) -> some View {
        let presentation = statusPresentation(status)

        return Label(presentation.text, systemImage: presentation.icon)
            .font(AppFont.mono(9))
            .foregroundColor(presentation.color)
            .padding(.horizontal, 7)
            .padding(.vertical, 5)
            .background(presentation.color.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
            .fixedSize(horizontal: true, vertical: false)
    }

    private func statusPresentation(
        _ status: EpubsReachability
    ) -> (text: String, icon: String, color: Color) {
        switch status {
        case .notChecked:
            return ("NOT CHECKED", "minus.circle", AppTheme.muted)
        case .checking:
            return ("CHECKING", "arrow.clockwise", AppTheme.accent)
        case .available:
            return ("REACHABLE", "checkmark.circle.fill", AppTheme.primary)
        case .browserRequired:
            return ("OPEN TO VERIFY", "safari", AppTheme.accent)
        case .unavailable:
            return ("NOT FOUND", "exclamationmark.triangle.fill", AppTheme.danger)
        case .failed:
            return ("CHECK FAILED", "wifi.exclamationmark", AppTheme.muted)
        }
    }

    private func currentMetadata(for publication: EpubsPublication) -> EpubsRemoteMetadata? {
        if case let .available(metadata) = service.status(for: publication) {
            return metadata
        }
        return progress.epubPublicationSnapshots[publication.id]?.metadata
    }

    private func refreshCatalog() async {
        let metadata = await service.refresh()
        progress.recordEpubsChecks(metadata)
    }

    private func saveOffline(_ publication: EpubsPublication) async {
        downloadingPublicationId = publication.id
        defer { downloadingPublicationId = nil }

        do {
            let data = try await service.downloadPDF(for: publication)
            exportDocument = EpubsPDFDocument(data: data)
            exportFilename = publication.number.replacingOccurrences(of: " ", with: "-")
            showFileExporter = true
        } catch {
            alertMessage = "\(publication.number) could not be downloaded. \(error.localizedDescription) You can still open the official e-Pubs page and save it from the browser."
            showAlert = true
        }
    }

    private func reportBrokenLink(_ publication: EpubsPublication) {
        var components = URLComponents()
        components.scheme = "mailto"
        components.path = "abdoulbah1126@gmail.com"
        components.queryItems = [
            URLQueryItem(name: "subject", value: "Broken e-Pubs Link: \(publication.number)"),
            URLQueryItem(
                name: "body",
                value: """
                Broken Publication Link

                Publication: \(publication.number) — \(publication.title)
                Official URL: \(publication.pdfURL.absoluteString)
                App status: \(statusPresentation(service.status(for: publication)).text)
                Last checked: \(service.lastChecked?.formatted() ?? "Not checked")

                What happened:

                """
            )
        ]
        if let url = components.url {
            openURL(url)
        }
    }

    private var emptyState: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 8) {
                Text("No tracked publication matches your search.")
                    .font(AppFont.subtitle(15))
                    .foregroundColor(AppTheme.text)
                Text("Use the e-Pubs search above to look across the full official catalog.")
                    .font(AppFont.body(13))
                    .foregroundColor(AppTheme.muted)
            }
        }
    }

    private var disclaimerCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 8) {
                Text("FIELD USE NOTE")
                    .font(AppFont.mono(11))
                    .foregroundColor(AppTheme.muted)
                Text("Reachability and server-change indicators do not validate a paragraph or guarantee that a saved copy is still current. Review the official PDF title page, incorporated changes, guidance memoranda, supplements, and local procedures before applying a requirement.")
                    .font(AppFont.body(13))
                    .foregroundColor(AppTheme.muted)
            }
        }
    }
}

struct EpubsCitationLinks: View {
    let citation: String

    private var publications: [EpubsPublication] {
        EpubsCatalog.matchingPublications(in: citation)
    }

    var body: some View {
        ForEach(publications) { publication in
            NavigationLink {
                EpubsLibraryView(focusPublicationId: publication.id)
            } label: {
                Label("Open \(publication.number) in Live e-Pubs", systemImage: "arrow.right.circle.fill")
                    .font(AppFont.subtitle(12))
                    .foregroundColor(AppTheme.primary)
                    .frame(maxWidth: .infinity, minHeight: AppSpacing.minTapTarget, alignment: .leading)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
    }
}
