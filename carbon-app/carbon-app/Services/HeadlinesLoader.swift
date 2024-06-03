import Foundation
import SwiftUI

@Observable
class HeadlinesLoader {
    let apiClient: NewsAPI
    private(set) var state: LoadingState = .idle
    
    enum LoadingState {
        case idle
        case loading
        case success(data: [Article])
        case failed(error: Error)
    }
    
    init(apiClient: NewsAPI) {
        self.apiClient = apiClient
    }
    
    @MainActor
    func loadHeadlinesData() async {
        self.state = .loading
        do {
            let response = try await apiClient.fetchTopHeadlines()
            self.state = .success(data: response.articles)
        } catch {
            self.state = .failed(error: error)
        }
    }
    
    @MainActor
    func loadSearchData(query: String) async {
        
        self.state = .loading
        do {
            let response = try await apiClient.fetchSearchResults(query: query)
            self.state = .success(data: response.articles)
        } catch {
            self.state = .failed(error: error)
        }
    }
}
