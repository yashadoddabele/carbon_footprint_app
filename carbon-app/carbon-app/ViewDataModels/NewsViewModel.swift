import Foundation
import SwiftUI


struct NewsResponse: Decodable {
    var status: String
    var totalResults: Int
    var articles: [Article]
    
    static func mock() -> NewsResponse {
        NewsResponse(status: "ok", totalResults: 5, articles: [
            
            Article(source: Source(id: "s1", name: "Source1"), title: "Pandas are trapped in a slaughterhouse!", description: "News uncovered by journalists found that a private collector has been extracting Panda tears to sell.", url: "https://removed1.com", publishedAt: "1970-01-01T00:00:00Z", content: "[Removed]"),
            
            Article(source: Source(id: "s2", name: "Source2"), title: "Lions are released from the slaughterhouse!", description: "Journalists are still unsure whether this is good or bad for the climate.", url: "https://removed2.com", publishedAt: "1970-01-01T00:00:00Z", content: "[Removed]"),
            
            Article(source: Source(id: "s3", name: "Source3"), title: "Carbon footprint is soon to be replaced with Carbon handprints", description: "Research shows more movement with the hands has generated adverse climate effects compared to feet.", url: "https://removed3.com", publishedAt: "1970-01-01T00:00:00Z", content: "[Removed]"),
            
            Article(source: Source(id: "s4", name: "Source4"), title: "The New Gold Rush: Water Rush", description: "Lack of water is now a real possibility. Experts advice to limit showers to 3 minutes.", url: "https://removed4.com", publishedAt: "1970-01-01T00:00:00Z", content: "[Removed]"),
            
            Article(source: Source(id: "s5", name: "Source5"), title: "WWF requests immediate aid from the US Government", description: "Political debate about where funding should go is now even more polarized.", url: "https://removed5.com", publishedAt: "1970-01-01T00:00:00Z", content: "[Removed]"),
            
            Article(source: Source(id: "s6", name: "Source6"), title: "Billionare wants to monetize air around his house", description: "The Supreme Court seems to be approving this as the US is a capitalist country. Opinions differ.", url: "https://removed6.com", publishedAt: "1970-01-01T00:00:00Z", content: "[Removed]"),
            
            Article(source: Source(id: "s7", name: "Source7"), title: "Man, I can't think of another example", description: "This mock data thing, according to experts, is taking forever to come up with.", url: "https://removed7.com", publishedAt: "1970-01-01T00:00:00Z", content: "[Removed]"),
        ])
    }
}

struct Source: Decodable {
    var id: String?
    var name: String
}

struct Article: Decodable, Identifiable {
    var source: Source
    var author: String?
    var title: String?
    var description: String?
    var url: String
    var urlToImage: String?
    var publishedAt: String
    var content: String?
    var id: String { url }
}










