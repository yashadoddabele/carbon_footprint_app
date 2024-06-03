import SwiftUI
import SwiftData

/**
    Main landing page for the program that loads the TabContainer
 */
@main
struct CarbonApp: App {
    
    let authenticationService = FakeAuthenticationService()
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            User.self,
            Profile.self,
            LogViewModel.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    

    var body: some Scene {
        WindowGroup {
            TabContainer()
                .onAppear { authenticationService.maybeLoginSavedUser(
                    modelContext: sharedModelContainer.mainContext)
            }
        }
        .modelContainer(sharedModelContainer)
        .environment(authenticationService)
    }
}
