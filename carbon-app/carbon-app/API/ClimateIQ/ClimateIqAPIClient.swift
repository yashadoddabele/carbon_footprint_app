import Foundation
import SwiftUI

protocol ClimateIQAPI {
    func fetchClimateStats() async throws -> ClimateResponse
}

struct ClimateIQAPIClient: ClimateIQAPI, APIClient {
    
    let session: URLSession = .shared
    
    func fetchClimateStats() async throws -> ClimateResponse {
        let climatePath = ClimateIQEndpoint.climateStatPath()
        let response: ClimateResponse = try await performRequest(url: climatePath)
        return response
    }
}

// We decided to omit this
