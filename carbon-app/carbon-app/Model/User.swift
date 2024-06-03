import Foundation
import SwiftData
import SwiftUI

@Model
class User {
    var username: String
    var email: String
    
    @Relationship(deleteRule: .cascade, inverse: \Profile.user)
    var profile: Profile?
    
    init(username: String, email: String, profile: Profile? = nil, following: [User]) {
        let ws = CharacterSet.whitespacesAndNewlines
        self.username = username.trimmingCharacters(in: ws).lowercased()
        self.email = email.trimmingCharacters(in: ws).lowercased()
        self.profile = profile
        self.following = following
      }
    
    @Relationship(inverse: \LogViewModel.logger)
    var logs: [LogViewModel] = []
    
    @Relationship
    var following: [User] = []
    
    func updateFollowing(user: User) {
        if (!following.contains(user)) {
                following.append(user)
        }
    }
    
    func removeFollowing(user: User) {
        if let index = following.firstIndex(where: { $0 === user }) {
            following.remove(at: index)
        }
    }
        
    struct FormData {
      var username: String = ""
      var email: String = ""
    }

    var dataForForm: FormData {
      FormData(
        username: username,
        email: email
      )
    }

    static func create(from formData: FormData, context: ModelContext, following: [User]) {
        let newUser = User(username: formData.username, email: formData.email, following: [])
      context.insert(newUser)
    }
    
    func update(from data:FormData) {
        self.username = data.username
    }
    
    func addLog(log: LogViewModel) {
        logs.insert(log, at: 0)
    }
    
    func calculateFootPrintAverage(forRecentLogs count: Int) -> Double {
        if logs.isEmpty {
            return 0.0
        }
        
        let effectiveCount = min(count, logs.count)

        let sortedLogs = logs.sorted { (logViewModel1, logViewModel2) in
                if let date1 = logViewModel1.time, let date2 = logViewModel2.time {
                    return date1 > date2
                } else {
                    return false
                }
            }

        let recentLogs = sortedLogs.prefix(effectiveCount)

        let totalFootprint = recentLogs.reduce(0.0) { (result, log) in
            return result + log.footprint
        }
        let averageFootprint = totalFootprint / Double(effectiveCount)
        return averageFootprint
    }
    

}
