import Foundation
import SwiftData
import UIKit

class ProfileModelData {
    
    static func startingData(modelContext: ModelContext){
        let user1 = User(username: "TejasJuware", email: "tejas@gmail.com", following: [])
        modelContext.insert(user1)
        let user2 = User(username: "PhilipLee", email: "philip@gmail.com", following: [])
        modelContext.insert(user2)
        let user3 = User(username: "YashaDoddabele", email: "yasha@gmail.com", following: [])
        user3.updateFollowing(user: user1)
        user3.updateFollowing(user: user2)
        modelContext.insert(user3)

    }
    
    @MainActor
    static var preview: ModelContainer {
      let container = try! ModelContainer(for: User.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
      ProfileModelData.startingData(modelContext: container.mainContext)
      return container
    }
}
