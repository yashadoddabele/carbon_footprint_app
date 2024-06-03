import Foundation
import SwiftData
import SwiftUI

struct FollowingView: View {
    @Environment(FakeAuthenticationService.self) var authenticationService
    @Environment(\.modelContext) private var modelContext
    var user: User
    
    var body: some View {
        VStack {
            let profile = Profile(name: user.username)
            AvatarImage(imageData: profile.avatar, size: 100)
               .scaledToFit()
               .frame(width: 120, height: 120)
               .clipShape(Circle())
               .shadow(radius: 10)
        
            Text(user.username)
               .font(.largeTitle)
               .foregroundColor(.white)
               .fontWeight(.bold)
               .padding(.bottom)
           Text(profileBiography(user.profile))
               .font(.body)
               .foregroundColor(.white)
               .fontWeight(.bold)
               .padding(.bottom)
            if let todayLog = todaysLog(todaysDate: Date(), currentUser: user) {
                Text("Today's carbon footprint: \(Int(todayLog.footprint)) lbs/CO2")
                    .font(.headline)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                 
            }
            else {
                Text("This user has not logged their footprint for today yet.")
                    .font(.headline)
                    .foregroundColor(.white)
                    .fontWeight(.bold)

            }

           Spacer()
       }
       .padding()
       .navigationTitle(user.username)
       .navigationBarTitleDisplayMode(.inline)
       .background(Color.green.opacity(0.7).edgesIgnoringSafeArea(.all)) 
       .onAppear {
           ProfileModelData.startingData(modelContext: modelContext)
       }
   }
    
    private func profileBiography(_ profile: Profile?) -> String {
        guard let biography = profile?.biography, !biography.isEmpty else {
            return "This user has no biography."
        }
        return biography
    }
}
