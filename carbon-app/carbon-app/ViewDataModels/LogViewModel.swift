import Foundation
import SwiftUI
import SwiftData

@Model
class LogViewModel: Identifiable {
    var id: UUID = UUID()
    var transportActivity: String
    var transportUnit: String
    var showerUnit: String
    var plasticUnit: String
    var time: Date?
    var notes: String
    var footprint: Double
    
    @Relationship
    var logger: User?

    init(transportActivity: String, transportUnit: String, showerUnit: String, 
         plasticUnit: String, time: Date? = nil, notes: String = "") {
        self.transportActivity = transportActivity
        self.transportUnit = transportUnit
        self.showerUnit = showerUnit
        self.plasticUnit = plasticUnit
        self.time = time
        self.notes = notes
        self.footprint = 0.0
        
    }
    
    func setCarbonFootprint() {
        self.footprint = calculateCarbon()
    }
    
    struct FormData {
        var transportActivity: String = ""
        var transportUnit: String = ""
        var showerUnit: String = ""
        var plasticUnit: String = ""
        var time: Date = Date()
        var notes: String = ""
    }
    
    var dataForForm: FormData {
      FormData(
        transportActivity: transportActivity,
        transportUnit: transportUnit,
        showerUnit: showerUnit,
        plasticUnit: plasticUnit,
        time: time ?? Date(),
        notes: notes
      )
    }
    
    static func create(from formData: FormData, context: ModelContext, user: User) {
        let log = LogViewModel(transportActivity: formData.transportActivity, transportUnit: formData.transportUnit,
                               showerUnit: formData.showerUnit, plasticUnit: formData.plasticUnit, time: formData.time, notes: formData.notes)
        log.setCarbonFootprint()
        log.logger = user
        user.addLog(log: log)
        context.insert(log)
    }
    
    func calculateCarbon() -> Double {
        var carbonFootprint: Double = 0.0
        
        switch transportActivity {
        case TransportType.walking.rawValue:
            carbonFootprint += 0.0
        case TransportType.bicycle.rawValue:
            carbonFootprint += 0.0
        case TransportType.privateTransport.rawValue:
            if let doubleValue = Double(transportUnit) {
                carbonFootprint += 0.89 * doubleValue
            }
        case TransportType.publicTransport.rawValue:
            if let doubleValue = Double(transportUnit) {
                carbonFootprint += 0.14 * doubleValue
            }
        case TransportType.none.rawValue:
            break
        default:
            break
        }

        if let showerValue = Double((showerUnit.trimmingCharacters(in: .whitespacesAndNewlines))) {
            carbonFootprint += 0.45 * showerValue
        }
        
        if let plasticValue = Double(plasticUnit) {
            carbonFootprint += 1.89 * plasticValue;
        }
        
        return carbonFootprint;
    }
 
}

extension LogViewModel {
    
    static let previewData = [
        LogViewModel(transportActivity: TransportType.bicycle.rawValue, transportUnit: "10", showerUnit: "20", plasticUnit: "6", time: Calendar.current.date(byAdding: .day, value: -7, to: Date()), notes: "Yummy but expensive. Now I'm gonna add more to the notes so that this expands the box. I'm doing this because I want to view how it looks like when you have a lot of words."
            )
//        LogViewModel(transportActivity: "Ate vegan food", transportUnit: "5 oz", time: Date(), notes: "Salad was delicious. I'm not gonna type a lot here because I'm lazy."),
    ]
}
