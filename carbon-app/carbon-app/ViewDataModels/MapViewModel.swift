import Foundation
import MapKit
import SwiftData

@Model
class MapResponse {
  let id: UUID = UUID()
  let name: String
  let latitide: Double
  let longitude: Double

  init(name: String, latitide: Double, longitude: Double) {
    self.name = name
    self.latitide = latitide
    self.longitude = longitude
  }

  var coordinate: CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: latitide, longitude: longitude)
  }
}

