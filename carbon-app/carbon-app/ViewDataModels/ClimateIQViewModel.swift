import Foundation

struct ClimateResponse: Decodable {
    var status: String
    var totalResults: Int
    var climateStats: ClimateStat
}

struct Emission_factor: Decodable {
    var name: String
    var year: Int
    var region: String
    var category: String
}

struct Constituent_gases: Decodable {
    var co2: Double
    var ch4: Double
    var n2o: Double
}

struct ClimateStat: Decodable, Identifiable {
    var co2e: Double
    var co2e_unit: String
    var emission_factor: Emission_factor
    var constituent_gases: Constituent_gases
    var id: UUID
}


