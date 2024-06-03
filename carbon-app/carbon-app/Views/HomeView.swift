import Foundation
import SwiftUI

/**
 HomeView shows the different information of the user. Avatars, login streaks, carboon footprint statistics, and reminders are shown here. Additionally, a button
 a button also allows the user to access their Profile for changes there.
 */
struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    WelcomeImageSection()
                    LoginStreakSection()
                    TodaysStatsSection()
                    ReminderSection()
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
            }
            .background(Color.green.opacity(0.7).edgesIgnoringSafeArea(.all))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ProfileScreen()) {
                        Text("Profile")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .font(.title3)
                    }
                }
            }
            .toolbarBackground(Color.green, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.green.opacity(0.7), for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
            .onAppear {
                ProfileModelData.startingData(modelContext: modelContext)
            }
            
        }
    }
}

#Preview {
    HomeView()
}

/**
 WelcomeImageSection presents the welcome message and the user's avatar.
 */
private struct WelcomeImageSection: View {
    @Environment(FakeAuthenticationService.self) var authenticationService
    
    var body: some View {
        if let currentUser = authenticationService.currentUser {
            VStack {
                Text("Welcome back, \(currentUser.username)!")
                    .fontWeight(.bold)
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 50)
            }
        }
        else {
            Text("Welcome!")
                .fontWeight(.bold)
                .font(.title)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 50)
        }
        
        Image("AppLogo")
            .resizable()
            .frame(width: 150, height: 150)
    }
}

/**
 LoginStreakSection presents the daily login streaks of the users.
 */
private struct LoginStreakSection: View {
    @Environment(FakeAuthenticationService.self) var authenticationService
    var body: some View {
        if let currentUser = authenticationService.currentUser {
            HStack {
                Image(systemName: "flame.fill")
                    .foregroundColor(.orange)
                if (!currentUser.logs.isEmpty) {
                    Text("Login Streak: \(currentUser.logs.count) days")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
                else {
                    Text("Login Streak: 0 days")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.green.opacity(0.8))
            .cornerRadius(10)
        } else {
            HStack {
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundColor(.red)
                Text("Log in or Register to see more!")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.green.opacity(0.8))
            .cornerRadius(10)
        }
    }
}

/**
 TodaysStatsSection presents the different, cumulative stats the user has acquired through their energy efforts.
 */
private struct TodaysStatsSection: View {
    @Environment(FakeAuthenticationService.self) var authenticationService
    var body: some View {
        if let currentUser = authenticationService.currentUser {
            VStack(alignment: .leading, spacing: 10) {
                Text("Today's Stats:")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 10) {
                    if currentUser.logs.isEmpty {
                        Text("Record your carbon data for today in the Log!")
                    }
                    else {
                        let logged = loggedToday(currentUser: currentUser)
                        if logged {
                            if let todayLog = todaysLog(todaysDate: Date(), currentUser: currentUser) {
                                Text("Today's carbon footprint: \(Int(todayLog.footprint ?? 0)) lbs of CO2")
                            } else {
                                Text("No data for today")
                            }
                        }
                        else {
                            Text("Record your carbon data for today in the Log!")
                        }
                        
                        //Weekly averagge
                        Text("Past week's average: \(Int(currentUser.calculateFootPrintAverage(forRecentLogs: 7))) lbs/CO2")
                        //Monthly average
                        Text("Monthly average: \(Int(currentUser.calculateFootPrintAverage(forRecentLogs: 30))) lbs/CO2")
                    }
                }
                .foregroundColor(.white)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.green.opacity(0.8))
            .cornerRadius(10)
        }
    }
}

func loggedToday(currentUser: User) -> Bool {
    if (currentUser.logs.isEmpty) {
        return false
    }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    if let todayLog = todaysLog(todaysDate: Date(), currentUser: currentUser) {
        return true
    }
    return false
}

func todaysLog(todaysDate: Date, currentUser: User) -> LogViewModel? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let formattedInputDate = dateFormatter.string(from: todaysDate)
    for log in currentUser.logs {
        if let logDate = log.time {
            let logFormattedDate = dateFormatter.string(from: logDate)
            if formattedInputDate == logFormattedDate {
                return log
            }
        }
    }
    return nil
}

/**
 ReminderSection reminds the user to log their daily carbon footprint and other relevant reminders.
 */
private struct ReminderSection: View {
    
    private let reminders = [
        "Don't forget to log your daily carbon footprint!",
        "Remember to check your energy usage today!",
        "Have you shared your savings with friends yet?",
        "Is your thermostat set to an eco-friendly temperature?",
        "Consider using public transportation today!"
    ]
    
    @State private var currentReminder: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Reminder:")
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(currentReminder)
                .foregroundColor(.white)
                .padding(.top, 2)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.green.opacity(0.8))
        .cornerRadius(10)
        .onAppear {
            // Select random reminder
            currentReminder = reminders.randomElement() ?? "Don't forget to log your daily carbon footprint!"
        }
    }
}
