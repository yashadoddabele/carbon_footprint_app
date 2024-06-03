import Foundation
import SwiftUI


protocol NewsAPI {
    func fetchTopHeadlines() async throws -> NewsResponse
    func fetchSearchResults(query: String) async throws -> NewsResponse
}

struct NewsAPIClient: NewsAPI, APIClient {
    
    let session: URLSession = .shared
    
    func fetchTopHeadlines() async throws -> NewsResponse {
        let newsPath = NewsEndpoint.headlinePath()
        let response: NewsResponse = try await performRequest(url: newsPath)
        return response
    }
    
    func fetchSearchResults(query: String) async throws -> NewsResponse {
        let url = NewsEndpoint.searchPath(query: query)
        let response: NewsResponse = try await performRequest(url: url)
        return response
    }
    
}

struct MockNewsAPIClient: NewsAPI {
    func fetchTopHeadlines() async throws -> NewsResponse {
        NewsResponse.mock()
    }
    func fetchSearchResults(query: String) async throws -> NewsResponse {
        NewsResponse.mock()
    }
}
