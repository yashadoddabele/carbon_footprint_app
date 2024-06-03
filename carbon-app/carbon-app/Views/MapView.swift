import SwiftUI
import MapKit
import CoreLocation

/**
 MapView shows the energy or climate data of a place. It allows users to search, click, and view the climate data of a  location.
 */
struct MapView: View {
    let locationManager = CLLocationManager()
    @State private var region: MKCoordinateRegion = .duke
    @State private var selectedLocation: UUID?
    @State private var dukeLocations = Location.dukeCampus
    
    var body: some View {
        VStack() {
            Map(coordinateRegion: $region, annotationItems: dukeLocations) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    Button(action: {
                        selectedLocation = selectedLocation == location.id ? nil : location.id
                    }) {
                        LocationAnnotationView(location: location, isSelected: selectedLocation == location.id)
                    }
                }
            }
            .mapStyle(.hybrid)
            .cornerRadius(20)
            .padding(.horizontal)
            .padding(.bottom, 20)
            .onAppear {
                locationManager.requestWhenInUseAuthorization()
            }
        }
        .toolbarBackground(Color.green.opacity(0.7), for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .frame(maxWidth: .infinity)
        .background(Color.green.opacity(0.7).edgesIgnoringSafeArea(.all))
    }
}




#Preview {
    MapView()
}

/**
 Location holds the different locations the map should create a pin of.
 */
private struct Location: Identifiable {
    let id: UUID = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
    var energyData: String
    var isShowingDetail: Bool = false
    
    static let dukeCampus: [Location] = [
        Location(name: "LSRC", coordinate: .lsrc, energyData: "Energy Consumption: 50kWh"),
        Location(name: "Gross Hall", coordinate: .grossHall, energyData: "Solar Power Generated: 20kWh")
    ]
}

/**
 SearchQuery searches for a location on the map.
 */
private struct SearchQuery: View {
    @Binding var searchResults: [MKMapItem]
    let region: MKCoordinateRegion
    @State var query: String = ""
    
    func search() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest
        request.region = region
        
        Task {
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            searchResults = response?.mapItems ?? []
        }
    }
    
    var body: some View {
        TextField("Search", text: $query)
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color.gray, style: StrokeStyle(lineWidth: 1.0)))
            .padding()
            .onSubmit {
                search()
            }
    }
}

/**
 LocationAnnotationView is a helper struct that loads the pin location that allows users to click on to view information about that specified location.
 */
private struct LocationAnnotationView: View {
    var location: Location
    var isSelected: Bool
    
    var body: some View {
        VStack {
            Image(systemName: "mappin.circle.fill")
                .foregroundColor(.blue)
                .font(.title2)
            Text(location.name)
                .font(.caption)
                .foregroundColor(.black)
                .padding(3)
                .background(Color.white.opacity(0.75))
                .cornerRadius(5)
                .fixedSize()
            
            // Conditionally show the energy data
            if isSelected {
                Text(location.energyData)
                    .padding(5)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(5)
                    .fixedSize()
                    .transition(.scale)
            }
        }
        .animation(.easeInOut, value: isSelected)
    }
}


extension CLLocationCoordinate2D {
    static let grossHall = CLLocationCoordinate2D(latitude: 36.001312, longitude: -78.944745)
    static let lsrc = CLLocationCoordinate2D(latitude: 36.004556, longitude: -78.941755)
}

extension MKCoordinateRegion {
    static let duke = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 36.002250, longitude: -78.938638), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
}
