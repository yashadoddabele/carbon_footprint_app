
import Foundation
import SwiftData

@Observable
class FakeAuthenticationService {
  var currentUser: User?
  var errorMessage: String?
  let currentUserKey: String = "currentUserEmail"

  func login(email: String, modelContext: ModelContext) {
    let ws = CharacterSet.whitespacesAndNewlines
    if let user = try? fetchUser(email.trimmingCharacters(in: ws).lowercased(), modelContext: modelContext) {
      errorMessage = nil
      loginUser(user)
    } else {
      errorMessage = "Login Failed"
      logout()
    }
  }

  func loginUser(_ user: User) {
    currentUser = user
    UserDefaults.standard.set(user.email, forKey: currentUserKey)
    UserDefaults.standard.synchronize()
  }

  func logout() {
    currentUser = nil
    UserDefaults.standard.set(nil, forKey: currentUserKey)
    UserDefaults.standard.synchronize()
  }

  func fetchUser(_ email: String, modelContext: ModelContext) throws -> User? {
    let userPredicate = #Predicate<User> { $0.email == email }
    let userFetch = FetchDescriptor(predicate: userPredicate)
    let users = try modelContext.fetch(userFetch)
    return try modelContext.fetch(userFetch).first
  }
    
    func fetchUserFromUserName(_ username: String, modelContext: ModelContext) -> User? {
        do {
            let userPredicate = #Predicate<User> { $0.username.starts(with: username) }
            let userFetch = FetchDescriptor(predicate: userPredicate)
            if let newUser = try modelContext.fetch(userFetch).first {
                return newUser
            } else {
                errorMessage = "Login Failed"
                return nil
            }
        } catch {
            errorMessage = "Error fetching user: \(error)"
            return nil
        }
    }

  func maybeLoginSavedUser(modelContext: ModelContext) {
    let email = UserDefaults.standard.string(forKey: currentUserKey)
    if let email,
       let user = try? fetchUser(email, modelContext: modelContext) {
      loginUser(user)
    }
  }
}
