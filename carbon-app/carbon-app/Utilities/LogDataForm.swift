import Foundation
import SwiftUI
import SwiftData

/**
    LogDataForm displays a form with different sections for users to input their activities. The distance travelled and other inputted data will be used to calculate the user's carbon footprint in other areas of tthe program.
 */
struct LogDataForm: View {
    @Binding var data: LogViewModel.FormData
    @State private var isPresenting: Bool = true
    @State private var selectedTransport: TransportType = .walking
    @State private var distanceTraveled: Double = 0
    @State private var activityDate: Date = Date()
    @State private var notes: String = ""

    var body: some View {
        NavigationView {
            Form {
                TransportMethodSection(selectedTransport: transportBinding)
                DistanceSection(distanceTraveled: distanceBinding)
                ShowerSection(showerUnit: showerBinding)
                PlasticSection(plasticUnit: plasticBinding)
                DateSection(activityDate: $data.time)
                NotesSection(notes: $data.notes)
            }
        }
    }

    
    // Custom binding for transport
    private var transportBinding: Binding<TransportType> {
          Binding(
              get: { TransportType(rawValue: self.data.transportActivity) ?? .none },
              set: { if $0 != .none { self.data.transportActivity = $0.rawValue }}
          )
      }

    // Custom binding for distance
    private var distanceBinding: Binding<Double> {
        Binding(
            get: { Double(self.data.transportUnit.split(separator: " ").first ?? "0") ?? 0.0 },
            set: { self.data.transportUnit = String(format: "%.2f", $0) }
        )
    }
    
    private var showerBinding: Binding<Double> {
        Binding(
            get: { Double(self.data.showerUnit.split(separator: " ").first ?? "0") ?? 0.0 },
            set: { self.data.showerUnit = String(format: "%.2f", $0) }
        )
    }
    
    private var plasticBinding: Binding<Double> {
        Binding(
            get: { Double(self.data.plasticUnit.split(separator: " ").first ?? "0") ?? 0.0 },
            set: { self.data.plasticUnit = String(format: "%.2f", $0) }
        )
    }
}

#Preview() {
    let preview = PreviewContainer([LogViewModel.self])
    let data = Binding.constant(LogViewModel.previewData[0].dataForForm)
    return LogDataForm(data: data)
        .modelContainer(preview.container)
}

private struct TransportMethodSection: View {
    @Binding var selectedTransport: TransportType
    
    let transportOptions: [TransportType] = [.walking, .bicycle, .privateTransport, .publicTransport]

    var body: some View {
        Section(header: Text("Transport Method")) {
            Picker("Transport", selection: $selectedTransport) {
                ForEach(transportOptions, id: \.self) { transport in
                    Text(transport.rawValue.capitalized).tag(transport)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}

private struct DistanceSection: View {
    @Binding var distanceTraveled: Double

    var body: some View {
        Section(header: Text("Distance")) {
            Slider(value: $distanceTraveled, in: 0...200, step: 0.1) {
                Text("Distance")
            }
            .accentColor(.green)
            Text("\(distanceTraveled, specifier: "%.1f") miles")
        }
    }
}

private struct ShowerSection: View {
    @Binding var showerUnit: Double

    var body: some View {
        Section(header: Text("Shower Time")) {
            Slider(value: $showerUnit, in: 0...200, step: 0.1) {
                Text("Shower Time")
            }
            .accentColor(.green)
            Text("\(showerUnit, specifier: "%.1f") minutes")
        }
    }
}

private struct PlasticSection: View {
    @Binding var plasticUnit: Double
    
    var body: some View {
        Section(header: Text("Plastic Usage")) {
            Slider(value: $plasticUnit, in: 0...200, step: 0.1) {
                Text("Plastic Usage")
            }
            .accentColor(.green)
            Text("\(plasticUnit, specifier: "%.1f") lbs")
        }
    }
}

private struct DateSection: View {
    @Binding var activityDate: Date

    var body: some View {
        Section(header: Text("Date")) {
            DatePicker("Activity Date", selection: $activityDate, displayedComponents: .date)
        }
    }
}

private struct NotesSection: View {
    @Binding var notes: String

    var body: some View {
        Section(header: Text("Notes")) {
            TextField("Additional notes", text: $notes)
                .foregroundColor(.black)
        }
    }
}


enum TransportType: String, CaseIterable {
    case none = "Please select a choice"
    case walking = "Walking"
    case bicycle = "Bicycle"
    case privateTransport = "Private"
    case publicTransport = "Public"
}

