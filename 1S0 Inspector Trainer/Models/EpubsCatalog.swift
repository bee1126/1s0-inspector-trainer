import Combine
import Foundation

struct EpubsPublication: Identifiable, Hashable, Sendable {
    let id: String
    let number: String
    let title: String
    let summary: String
    let pdfURL: URL
}

struct EpubsRemoteMetadata: Codable, Equatable, Sendable {
    let etag: String?
    let lastModified: String?
    let contentLength: Int64?

    func indicatesRevisionChange(from previous: EpubsRemoteMetadata) -> Bool {
        if let etag, let previousETag = previous.etag {
            return etag != previousETag
        }
        if let lastModified, let previousLastModified = previous.lastModified {
            return lastModified != previousLastModified
        }
        if let contentLength, let previousContentLength = previous.contentLength {
            return contentLength != previousContentLength
        }
        return false
    }
}

struct EpubsPublicationSnapshot: Codable, Equatable {
    let metadata: EpubsRemoteMetadata
    let lastChecked: Date
    var hasUnreadRevision: Bool
}

enum EpubsReachability: Equatable, Sendable {
    case notChecked
    case checking
    case available(metadata: EpubsRemoteMetadata)
    case browserRequired
    case unavailable
    case failed
}

enum EpubsCatalog {
    static let homeURL = URL(string: "https://www.e-publishing.af.mil/")!

    static let publications: [EpubsPublication] = [
        EpubsPublication(
            id: "dafi91-202",
            number: "DAFI 91-202",
            title: "The Department of the Air Force Mishap Prevention Program",
            summary: "Program responsibilities, hazard reporting, inspections, and mishap prevention.",
            pdfURL: URL(string: "https://static.e-publishing.af.mil/production/1/af_se/publication/dafi91-202/dafi91-202.pdf")!
        ),
        EpubsPublication(
            id: "dafi91-204",
            number: "DAFI 91-204",
            title: "Safety Investigations and Reports",
            summary: "Investigation, notification, reporting, and recommendation requirements.",
            pdfURL: URL(string: "https://static.e-publishing.af.mil/production/1/af_se/publication/dafi91-204/dafi91-204.pdf")!
        ),
        EpubsPublication(
            id: "dafman91-203",
            number: "DAFMAN 91-203",
            title: "Air Force Occupational Safety, Fire, and Health Standards",
            summary: "Core occupational safety, fire prevention, and health standards used in inspections.",
            pdfURL: URL(string: "https://static.e-publishing.af.mil/production/1/af_se/publication/dafman91-203/dafman91-203.pdf")!
        ),
        EpubsPublication(
            id: "dafi91-207",
            number: "DAFI 91-207",
            title: "The US Air Force Traffic Safety Program",
            summary: "Traffic, vehicle, motorcycle, pedestrian, and recreational safety requirements.",
            pdfURL: URL(string: "https://static.e-publishing.af.mil/production/1/af_se/publication/dafi91-207/dafi91-207.pdf")!
        ),
        EpubsPublication(
            id: "dafpam90-803",
            number: "DAFPAM 90-803",
            title: "Risk Management Guidelines and Tools",
            summary: "Risk management methods, matrices, worksheets, and decision-support tools.",
            pdfURL: URL(string: "https://static.e-publishing.af.mil/production/1/af_se/publication/dafpam90-803/dafpam90-803.pdf")!
        ),
        EpubsPublication(
            id: "dafi48-127",
            number: "DAFI 48-127",
            title: "Occupational Noise and Hearing Conservation Program",
            summary: "Noise surveillance, exposure controls, hearing protection, and audiometric monitoring.",
            pdfURL: URL(string: "https://static.e-publishing.af.mil/production/1/af_sg/publication/afi48-127/afi48-127.pdf")!
        )
    ]

    static func searchURL(for query: String) -> URL {
        let normalizedQuery = query
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .whitespacesAndNewlines)
            .joined()

        guard !normalizedQuery.isEmpty else { return homeURL }

        var components = URLComponents(url: homeURL, resolvingAgainstBaseURL: false)!
        components.queryItems = [URLQueryItem(name: "txtSearchWord", value: normalizedQuery)]
        return components.url ?? homeURL
    }

    static func publication(id: String) -> EpubsPublication? {
        publications.first { $0.id == id }
    }

    static func matchingPublications(in citation: String) -> [EpubsPublication] {
        let normalizedCitation = normalizedReference(citation)
        return publications.filter { normalizedCitation.contains(normalizedReference($0.number)) }
    }

    private static func normalizedReference(_ value: String) -> String {
        value.uppercased().filter { $0.isLetter || $0.isNumber }
    }
}

enum EpubsDownloadError: LocalizedError {
    case invalidResponse
    case unavailable(Int)
    case notPDF

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "e-Pubs returned an invalid response."
        case .unavailable(let statusCode):
            return "The official PDF could not be downloaded (HTTP \(statusCode))."
        case .notPDF:
            return "The downloaded file was not recognized as a PDF."
        }
    }
}

@MainActor
final class EpubsCatalogService: ObservableObject {
    @Published private(set) var reachability: [String: EpubsReachability] = [:]
    @Published private(set) var lastChecked: Date?
    @Published private(set) var isRefreshing = false

    func status(for publication: EpubsPublication) -> EpubsReachability {
        reachability[publication.id] ?? .notChecked
    }

    @discardableResult
    func refresh() async -> [String: EpubsRemoteMetadata] {
        guard !isRefreshing else { return [:] }

        isRefreshing = true
        for publication in EpubsCatalog.publications {
            reachability[publication.id] = .checking
        }

        let results = await Self.check(EpubsCatalog.publications)
        var metadataByPublication: [String: EpubsRemoteMetadata] = [:]
        for result in results {
            reachability[result.id] = result.status
            if case let .available(metadata) = result.status {
                metadataByPublication[result.id] = metadata
            }
        }
        lastChecked = Date()
        isRefreshing = false
        return metadataByPublication
    }

    func downloadPDF(for publication: EpubsPublication) async throws -> Data {
        var request = URLRequest(
            url: publication.pdfURL,
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 60
        )
        request.httpMethod = "GET"
        request.setValue("application/pdf", forHTTPHeaderField: "Accept")

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw EpubsDownloadError.invalidResponse
        }
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw EpubsDownloadError.unavailable(httpResponse.statusCode)
        }
        guard data.starts(with: Data("%PDF".utf8)) else {
            throw EpubsDownloadError.notPDF
        }
        return data
    }

    private static func check(
        _ publications: [EpubsPublication]
    ) async -> [(id: String, status: EpubsReachability)] {
        await withTaskGroup(
            of: (String, EpubsReachability).self,
            returning: [(String, EpubsReachability)].self
        ) { group in
            for publication in publications {
                group.addTask {
                    (publication.id, await check(publication.pdfURL))
                }
            }

            var results: [(String, EpubsReachability)] = []
            for await result in group {
                results.append(result)
            }
            return results
        }
    }

    private static func check(_ url: URL) async -> EpubsReachability {
        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 15
        )
        request.httpMethod = "HEAD"
        request.setValue("application/pdf", forHTTPHeaderField: "Accept")

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else { return .failed }

            switch httpResponse.statusCode {
            case 200..<400:
                let contentLength = httpResponse.value(forHTTPHeaderField: "Content-Length")
                    .flatMap(Int64.init)
                return .available(
                    metadata: EpubsRemoteMetadata(
                        etag: httpResponse.value(forHTTPHeaderField: "ETag"),
                        lastModified: httpResponse.value(forHTTPHeaderField: "Last-Modified"),
                        contentLength: contentLength
                    )
                )
            case 401, 403, 405:
                return .browserRequired
            case 404, 410:
                return .unavailable
            default:
                return .failed
            }
        } catch {
            return .failed
        }
    }
}
