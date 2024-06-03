import Foundation
import SwiftUI
import SwiftData

/**
    LogDetailView shows the details of a specific log. It shows users the activity, the unit of the activity, and the notes they recorded down.
 */
struct LogDetailView: View {
    var log: LogViewModel
    
    var body: some View {
        ScrollView() {
            VStack() {
                ImageAndIconSection()
                HStack() {
                    TimeSection(log: log)
                    CarbonFootPrintSection(log: log)
                }
                
                HStack() {
                    TransportActivitySection(log: log)
                    TransportUnitSection(log: log)
                }
                ShowerSection(log: log)
                PlasticSection(log: log)
                
                NotesSection(log: log)
            }
        }
        .toolbarBackground(Color.green.opacity(0.7), for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(Color.green, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .frame(maxWidth: .infinity)
        .background(Color.green.opacity(0.7).edgesIgnoringSafeArea(.all))
    }

}


#Preview {
    let preview = PreviewContainer([LogViewModel.self])
    let log = LogViewModel.previewData[0]
    return NavigationStack {
        LogDetailView(log: log)
            .modelContainer (preview.container)
    }
}

private struct ImageAndIconSection: View {
    let icons = ["carbon.monoxide.cloud.fill", "leaf.arrow.circlepath",
                 "arrow.3.trianglepath", "waterbottle.fill", "cloud.rainbow.half"]

    var body: some View {
        Text("Log Details")
            .font(.title)
            .bold()
            .foregroundColor(.white)
            .padding(.top, 30)
        let iconName = icons.randomElement() ?? "leaf.arrow.circlepath"
        Image(systemName: iconName)
               .resizable()
               .scaledToFit()
               .frame(height: 120)
               .padding()
    }
}

private struct TimeSection: View {
    var log: LogViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Date")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding([.leading, .trailing, .top])
            HStack() {
                Text(formattedTime)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .foregroundColor(.white)
            .background(Color.green.opacity(0.8))
            .cornerRadius(10)
            .padding([.leading, .trailing])
        }
    }
    
    private var formattedTime: String {
        guard let time = log.time else { return "No Time" }
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: time)
    }
}

private struct CarbonFootPrintSection: View {
    var log: LogViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Footprint")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding([.leading, .trailing, .top])
            HStack() {
                  Text("\(log.footprint) lbs/CO2")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .foregroundColor(.white)
            .background(Color.green.opacity(0.8))
            .cornerRadius(10)
            .padding([.leading, .trailing])
        }
    }
}

private struct TransportActivitySection: View {
    var log: LogViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Transport Type")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding([.leading, .trailing, .top])
            HStack() {
                Text(log.transportActivity)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .foregroundColor(.white)
            .background(Color.green.opacity(0.8))
            .cornerRadius(10)
            .padding([.leading, .trailing])
        }
    }
}

private struct TransportUnitSection: View {
    var log: LogViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Distance")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding([.leading, .trailing, .top])
            HStack() {
                Text(log.transportUnit + " miles")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .foregroundColor(.white)
            .background(Color.green.opacity(0.8))
            .cornerRadius(10)
            .padding([.leading, .trailing])
        }
    }
}

private struct ShowerSection: View {
    var log: LogViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Shower Usage")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding([.leading, .trailing, .top])
            HStack() {
                Text(log.showerUnit + " minutes")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .foregroundColor(.white)
            .background(Color.green.opacity(0.8))
            .cornerRadius(10)
            .padding([.leading, .trailing])
        }
    }
}

private struct PlasticSection: View {
    var log: LogViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Plastic Usage ")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding([.leading, .trailing, .top])
            HStack() {
                Text(log.plasticUnit + " lbs")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .foregroundColor(.white)
            .background(Color.green.opacity(0.8))
            .cornerRadius(10)
            .padding([.leading, .trailing])
        }
    }
}

private struct NotesSection: View {
    var log: LogViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Notes")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding([.leading, .trailing, .top])
            HStack() {
                Text(log.notes)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .foregroundColor(.white)
            .background(Color.green.opacity(0.8))
            .cornerRadius(10)
            .padding([.leading, .trailing])
        }
    }
}


