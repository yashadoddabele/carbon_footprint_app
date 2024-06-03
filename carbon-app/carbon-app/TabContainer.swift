import Foundation
import SwiftUI

/**
    TabContainer controls the navigation between differen't views
    Tabs are generated through creating Tab Views in a loop.
 */
struct TabContainer: View {
    private let tabs: [TabInfo] = [
        TabInfo(view: AnyView(HomeView()), label: "Home", systemImage: "house"),
        TabInfo(view: AnyView(SocialMediaView()), label: "Social", systemImage: "person"),
        TabInfo(view: AnyView(NewsView(loader: HeadlinesLoader(apiClient: NewsAPIClient()))), label: "News", systemImage: "newspaper"),
        TabInfo(view: AnyView(MapView()), label: "Map", systemImage: "map"),
        TabInfo(view: AnyView(LogView()), label: "Log", systemImage: "square.and.pencil")
    ]

    var body: some View {
        TabView {
            ForEach(tabs.indices, id: \.self) { index in
                NavigationStack {
                    tabs[index].view
                }
                .tabItem {
                    Label(tabs[index].label, systemImage: tabs[index].systemImage)
                }
            }
        }
    }
}


#Preview {
    TabContainer()
}

/**
    Struct to simplify the creation of tabs in the tab container
 */
private struct TabInfo {
    let view: AnyView
    let label: String
    let systemImage: String
}
