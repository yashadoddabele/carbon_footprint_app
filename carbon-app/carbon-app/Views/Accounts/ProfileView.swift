import SwiftUI
import SwiftData
import PhotosUI

struct ProfileScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(FakeAuthenticationService.self) var authenticationService
    @State var profileData: Profile.FormData?
    
    var body: some View {
        VStack {
            Group {
                if authenticationService.currentUser == nil {
                    LoginScreen()
                } else if let currentUser = authenticationService.currentUser, let profile = currentUser.profile {
                    VStack {
                        Spacer()
                        Spacer()
                        ProfileView(user: currentUser, profile: profile)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button("Edit") { profileData = profile.dataForForm }
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                }
                            }
                        Spacer()
                        Button("Logout") { authenticationService.logout() }
                            .foregroundStyle(.red)
                            .fontWeight(.bold)
                            .padding(.bottom, 10)
                    }
                } else {
                    Text("Please create a Profile")
                        .onAppear { setUpUserAndProfile() }
                }
            }
            .sheet(item: $profileData) { item in
                ProfileEditForm(profileData: item)
            }
        }
        .toolbarBackground(Color.green.opacity(0.7), for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(Color.green, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .frame(maxWidth: .infinity)
        .background(Color.green.opacity(0.7).edgesIgnoringSafeArea(.all))
    }
    
    func setUpUserAndProfile() {
        if let user = authenticationService.currentUser,
           user.profile == nil {
            let user = authenticationService.currentUser!
            user.profile = Profile(name: user.username)
            profileData = user.profile?.dataForForm
        }
    }
    
}

struct ProfileView: View {
    let user: User
    let profile: Profile
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center){
                HStack{
                    AvatarImage(imageData: profile.avatar, size: 50)
                    Text(profile.name)
                        .font(.title)
                }
                Text("About Me:")
                    .fontWeight(.bold)
                Text(profile.biography)
                    .padding(.bottom, 20)
                
                if !user.logs.isEmpty {
                    if let todayLog = todaysLog(todaysDate: Date(), currentUser: user) {
                        HStack {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(.white)
                            Text("Today's Carbon Footprint: \(Int(todayLog.footprint)) lbs/CO2")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .font(.subheadline)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.green.opacity(0.8))
                        .cornerRadius(10)
                    }
                    else {
                        Text("Log your carbon footprint for today!")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    
                    Text("Latest Achievements!")
                        .font(.headline)
                        .padding(.vertical, 3)
                    
                    AchievementsView(user: user)
                        .padding(.vertical, 3)
                }
                else {
                    Text("Log your carbon footprint for today!")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
        }
    }
}


#Preview {
    let authenticationService = FakeAuthenticationService()
    let previewContainer = ProfileModelData.preview
    authenticationService.login(email: "tejas@gmail.com", modelContext: previewContainer.mainContext)
    if let currentUser = authenticationService.currentUser {
        let profile = Profile(name: "Tejas Juware")
        currentUser.profile = profile
        return NavigationStack { ProfileView(user: authenticationService.currentUser!, profile: currentUser.profile!) }
            .environment(authenticationService)
            .modelContainer(previewContainer)
    } else {
        return Text("Failed to create User")
    }
}


struct AchievementsView: View {
    let user: User
    
    var body: some View {
        if !user.logs.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(user.logs, id: \.id) { log in
                    let footprintAchievements = Array(applyFootprintAchievements(log: log, user: user))
                    let loggingAchievements = Array(applyLoggingAchievements(user: user))
                    
                    ForEach(footprintAchievements, id: \.self) { achievement in
                        Text(achievement)
                    }
                    
                    ForEach(loggingAchievements, id: \.self) { achievement in
                        Text(achievement)
                    }
                }
                .padding()
                .background(Color.green.opacity(0.8))
                .cornerRadius(5)
            }
        }
    }
}
