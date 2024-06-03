import Foundation
import SwiftUI
import SwiftData

/**
 LogView allows users to view their daily logs as well as past logs. It also features a button for users to open a form to log in new data to calculate their carbon footprint.
 */
struct LogView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var logs: [LogViewModel] = LogViewModel.previewData
    @State private var newLogDataForm = LogViewModel.FormData()
    @Environment(FakeAuthenticationService.self) var authenticationService
    @State private var isPresentingDataForm: Bool = false
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    LogHeaderSection()
                    TodaysLogSection(authenticationService: authenticationService, isPresentingDataForm: $isPresentingDataForm)
                    PastActivitiesSection()
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
            }
            .background(Color.green.opacity(0.7).edgesIgnoringSafeArea(.all))
            .toolbarBackground(Color.green, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.green.opacity(0.7), for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
            .sheet(isPresented: $isPresentingDataForm) {
                LogDataFormView(isPresentingDataForm: $isPresentingDataForm, newLogDataForm: $newLogDataForm, modelContext: modelContext)
            }
        }
        .onAppear {
            if logs.isEmpty {
                for log in LogViewModel.previewData {
                    modelContext.insert(log)
                }
            }
        }
    }
}


#Preview {
    let preview = PreviewContainer([LogViewModel.self])
    preview.add(items: LogViewModel.previewData)
    return NavigationStack {
        LogView()
            .modelContainer(preview.container)
    }
}


private struct LogDataFormView: View {
    @Binding var isPresentingDataForm: Bool
    @Binding var newLogDataForm: LogViewModel.FormData
    @Environment(FakeAuthenticationService.self) var authenticationService
    var modelContext: ModelContext
    
    var body: some View {
        NavigationStack {
            LogDataForm(data: $newLogDataForm)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            isPresentingDataForm = false
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            if let currentUser = authenticationService.currentUser {
                                LogViewModel.create(from: newLogDataForm, context: modelContext, user: currentUser)
                                newLogDataForm = LogViewModel.FormData()  // Reset form data
                                isPresentingDataForm = false
                            }
                        }
                    }
                }
                .navigationTitle("Log New Data")
        }
    }
}


private struct LogHeaderSection: View {
    var body: some View {
        VStack {
            Text("Log Carbon Data")
                .fontWeight(.bold)
                .font(.title)
                .foregroundColor(.white)
                .padding(.vertical, 20)
            
            Image(systemName: "tree")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(height: 100)
        }
    }
}

struct TodaysLogSection: View {
    var authenticationService: FakeAuthenticationService
    @Binding var isPresentingDataForm: Bool
    @State var logToday = false
    
    var body: some View {
        if let currentUser = authenticationService.currentUser {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Today's Activities")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Button("Log New Data") {
                        if !logToday {
                            isPresentingDataForm = true
                        }
                    }
                    .disabled(logToday)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 140, height: 28)
                    .background(logToday ? Color.red : Color.blue)
                    .cornerRadius(10)
                }
                if logToday {
                    Text("You've already logged today!")
                        .foregroundColor(.red)
                        .italic()
                        .padding(.vertical)
                }
                
                if currentUser.logs.isEmpty {
                    Text("Nothing logged yet!")
                        .foregroundColor(.white)
                        .italic()
                        .padding(.vertical)
                } else {
                    if loggedToday(currentUser: currentUser) {
                        if let log = todaysLog(todaysDate: Date(), currentUser: currentUser){
                            NavigationLink(destination: LogDetailView(log: log)) {
                                HStack {
                                    Text("Carbon footprint: ")
                                    Spacer()
                                    HStack {
                                        Text("\(Int(log.footprint)) lbs/CO2")
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.white)
                                    }
                                }
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green.opacity(0.8))
                                .cornerRadius(10)
                            }
                        }
                    }
                    else {
                        Text("Log your carbon footprint for today!")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.vertical)
            .onAppear {
                logToday = loggedToday(currentUser: currentUser)
            }
        }
    }
}



struct PastActivitiesSection: View {
    @Environment(FakeAuthenticationService.self) var authenticationService
    var body: some View {
        if let currentUser = authenticationService.currentUser {
            if !currentUser.logs.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Past Activities")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    ForEach(currentUser.logs.indices, id: \.self) { index in
                        if todaysLog(todaysDate: Date(), currentUser: currentUser) != currentUser.logs[index] {
                            NavigationLink(destination: LogDetailView(log: currentUser.logs[index])) {
                                HStack {
                                    Text("Carbon footprint: ")
                                    Spacer()
                                    HStack {
                                        Text("\(Int(currentUser.logs[index].footprint)) lbs/CO2")
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.white)
                                    }
                                }
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green.opacity(0.8))
                                .cornerRadius(10)
                            }
                        }
                    }
                }
                .padding(.vertical)
            } else {
                Text("No past activities")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        } else {
            Text("Login to add your carbon data!")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
}
