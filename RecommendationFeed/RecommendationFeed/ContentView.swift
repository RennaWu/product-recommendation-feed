import Combine
import SwiftUI

// MARK: - Data Model
// Maps exactly to the JSON your API returns:
// { "_id", "username", "productName", "productUrl", "caption", "likes", "createdAt", "updatedAt", "__v" }

struct Recommendation: Identifiable, Codable {
    let id: String
    let username: String
    let productName: String
    let productUrl: String
    let caption: String
    var likes: Int
    let createdAt: String   // ISO8601 string from API — we parse it manually

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case username, productName, productUrl, caption, likes, createdAt
    }

    /// Parse the ISO8601 date string into a Date
    var createdDate: Date {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: createdAt) ?? Date()
    }
}

// MARK: - Relative Time
extension Date {
    var relativeString: String {
        let seconds = Int(Date().timeIntervalSince(self))
        let minutes = seconds / 60
        let hours   = minutes / 60
        let days    = hours / 24

        if minutes < 1  { return "just now" }
        if minutes < 60 { return "\(minutes)m ago" }
        if hours < 24   { return "\(hours)h ago" }
        if days < 30    { return "\(days)d ago" }
        return "\(days / 30)mo ago"
    }
}

// MARK: - Trndzy Color Theme

struct TrndzyTheme {
    static let background   = Color(red: 0.04, green: 0.04, blue: 0.04)
    static let cardBg       = Color(red: 0.08, green: 0.08, blue: 0.08)
    static let cardBorder   = Color.white.opacity(0.06)
    static let linkBg       = Color(red: 0.11, green: 0.11, blue: 0.11)
    static let primaryText  = Color.white
    static let secondaryTxt = Color(white: 0.80)
    static let tertiaryTxt  = Color(white: 0.40)
    static let mutedTxt     = Color(white: 0.33)
    static let likedRed     = Color(red: 0.89, green: 0.29, blue: 0.29)
    static let accentPurple = Color(red: 0.42, green: 0.36, blue: 0.91)

    static let avatarStyles: [(bg: Color, fg: Color)] = [
        (Color(red: 0.18, green: 0.12, blue: 0.37), Color(red: 0.71, green: 0.63, blue: 0.96)),
        (Color(red: 0.10, green: 0.23, blue: 0.17), Color(red: 0.36, green: 0.79, blue: 0.65)),
        (Color(red: 0.23, green: 0.10, blue: 0.10), Color(red: 0.94, green: 0.58, blue: 0.58)),
        (Color(red: 0.10, green: 0.18, blue: 0.28), Color(red: 0.52, green: 0.72, blue: 0.92)),
        (Color(red: 0.22, green: 0.17, blue: 0.10), Color(red: 0.94, green: 0.78, blue: 0.46)),
    ]

    static func avatarStyle(for name: String) -> (bg: Color, fg: Color) {
        let hash = name.unicodeScalars.reduce(0) { $0 + Int($1.value) }
        return avatarStyles[hash % avatarStyles.count]
    }

    static func initials(for name: String) -> String {
        let parts = name.split(separator: " ")
        if parts.count >= 2 {
            return "\(parts[0].prefix(1))\(parts[1].prefix(1))".uppercased()
        }
        return String(name.prefix(2)).uppercased()
    }

    static func displayUrl(_ urlString: String) -> String {
        guard let url = URL(string: urlString),
              let host = url.host else { return urlString }
        let domain = host.hasPrefix("www.") ? String(host.dropFirst(4)) : host
        let path = url.path.prefix(15)
        let display = domain + path
        return display.count > 28 ? display.prefix(28) + "..." : String(display)
    }
}

// MARK: - Product Link Preview

struct ProductLinkPreview: View {
    let productName: String
    let productUrl: String

    var body: some View {
        HStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(white: 0.17))
                .frame(width: 36, height: 36)
                .overlay(
                    Image(systemName: "link")
                        .font(.system(size: 14))
                        .foregroundColor(TrndzyTheme.mutedTxt)
                )

            VStack(alignment: .leading, spacing: 1) {
                Text(productName)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(TrndzyTheme.primaryText)

                Text(TrndzyTheme.displayUrl(productUrl))
                    .font(.system(size: 11))
                    .foregroundColor(TrndzyTheme.mutedTxt)
            }

            Spacer()

            Image(systemName: "arrow.up.right")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(TrndzyTheme.mutedTxt)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(TrndzyTheme.linkBg)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(TrndzyTheme.cardBorder, lineWidth: 0.5)
        )
    }
}

// MARK: - Action Bar

struct ActionBar: View {
    let likes: Int
    let isLiked: Bool
    let onLike: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            Button(action: onLike) {
                HStack(spacing: 5) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 14))
                        .foregroundColor(isLiked ? TrndzyTheme.likedRed : TrndzyTheme.mutedTxt)
                    Text("\(likes)")
                        .font(.system(size: 12))
                        .foregroundColor(isLiked ? TrndzyTheme.likedRed : TrndzyTheme.mutedTxt)
                }
            }
            .buttonStyle(.plain)

            HStack(spacing: 5) {
                Image(systemName: "bubble.right")
                    .font(.system(size: 14))
                Text("0")
                    .font(.system(size: 12))
            }
            .foregroundColor(TrndzyTheme.mutedTxt)

            HStack(spacing: 5) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 13))
                Text("Share")
                    .font(.system(size: 12))
            }
            .foregroundColor(TrndzyTheme.mutedTxt)

            Spacer()

            Image(systemName: "bookmark")
                .font(.system(size: 14))
                .foregroundColor(TrndzyTheme.mutedTxt)
        }
    }
}

// MARK: - Recommendation Card

struct RecommendationCard: View {
    let recommendation: Recommendation
    let isLiked: Bool
    let onLike: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            // Header: Avatar + Name + Handle + Time
            HStack(spacing: 10) {
                let style = TrndzyTheme.avatarStyle(for: recommendation.username)

                Text(TrndzyTheme.initials(for: recommendation.username))
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(style.fg)
                    .frame(width: 34, height: 34)
                    .background(style.bg)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 1) {
                    Text(recommendation.username)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(TrndzyTheme.primaryText)

                    Text("@\(recommendation.username.lowercased().replacingOccurrences(of: " ", with: ""))")
                        .font(.system(size: 12))
                        .foregroundColor(TrndzyTheme.tertiaryTxt)
                }

                Spacer()

                Text(recommendation.createdDate.relativeString)
                    .font(.system(size: 12))
                    .foregroundColor(TrndzyTheme.mutedTxt)
            }

            // Caption
            Text(recommendation.caption)
                .font(.system(size: 14))
                .foregroundColor(TrndzyTheme.secondaryTxt)
                .lineSpacing(3)

            // Product Link Preview
            if let url = URL(string: recommendation.productUrl) {
                Link(destination: url) {
                    ProductLinkPreview(
                        productName: recommendation.productName,
                        productUrl: recommendation.productUrl
                    )
                }
                .buttonStyle(.plain)
            }

            // Action Bar
            ActionBar(
                likes: recommendation.likes,
                isLiked: isLiked,
                onLike: onLike
            )
        }
        .padding(14)
        .background(TrndzyTheme.cardBg)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(TrndzyTheme.cardBorder, lineWidth: 0.5)
        )
    }
}

// MARK: - Feed Screen

struct ContentView: View {
    @StateObject private var viewModel = RecommendationViewModel()

    var body: some View {
        ZStack {
            TrndzyTheme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                // Nav Bar
                HStack {
                    Text("Discover")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .kerning(-0.5)

                    Spacer()

                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 14)

                // Feed
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 10) {
                        ForEach(viewModel.recommendations) { rec in
                            RecommendationCard(
                                recommendation: rec,
                                isLiked: viewModel.likedIds.contains(rec.id),
                                onLike: { viewModel.like(id: rec.id) }
                            )
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.bottom, 100)
                }
            }
        }
        .preferredColorScheme(.dark)
        .task {
            await viewModel.fetchRecommendations()
        }
    }
}

// MARK: - ViewModel

@MainActor
class RecommendationViewModel: ObservableObject {
    @Published var recommendations: [Recommendation] = []
    @Published var likedIds: Set<String> = []

    // localhost works in iOS Simulator because it shares the Mac's network
    // For a real device, replace with your Mac's local IP (e.g. 192.168.x.x)
    private let baseURL = "http://localhost:3000"

    func fetchRecommendations() async {
        guard let url = URL(string: "\(baseURL)/recommendations") else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            recommendations = try decoder.decode([Recommendation].self, from: data)
        } catch {
            print("Fetch error: \(error)")
        }
    }

    func like(id: String) {
        if likedIds.contains(id) {
            likedIds.remove(id)
            if let i = recommendations.firstIndex(where: { $0.id == id }) {
                recommendations[i].likes -= 1
            }
        } else {
            likedIds.insert(id)
            if let i = recommendations.firstIndex(where: { $0.id == id }) {
                recommendations[i].likes += 1
            }

            guard let url = URL(string: "\(baseURL)/recommendations/\(id)/like") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"

            Task {
                do {
                    let (_, response) = try await URLSession.shared.data(for: request)
                    if let http = response as? HTTPURLResponse, http.statusCode != 200 {
                        likedIds.remove(id)
                        if let i = recommendations.firstIndex(where: { $0.id == id }) {
                            recommendations[i].likes -= 1
                        }
                    }
                } catch {
                    likedIds.remove(id)
                    if let i = recommendations.firstIndex(where: { $0.id == id }) {
                        recommendations[i].likes -= 1
                    }
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}

