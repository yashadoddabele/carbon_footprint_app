
import Foundation
import SwiftUI
import SwiftData

struct SocialMediaView: View {
    @Environment(FakeAuthenticationService.self) var authenticationService
    @Environment(\.modelContext) private var modelContext
    
    @State private var friendUser: String = ""
    @State private var success: String = ""
    
    var body: some View {
        VStack {
            Text("Feed")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 8)
            
            Image(systemName: "person.line.dotted.person.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(height: 60)
                .padding(.bottom, 20)
            
            if let currentUser = authenticationService.currentUser {
                Text("Search by Username")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 8)
            }
            
            FollowUsersView(query: $friendUser, onSearch: performSearch)
            
            Text(success)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 8)
            ShowFollowing()
        }
        .background(Color.green.edgesIgnoringSafeArea(.all))
        .toolbarBackground(Color.green.opacity(0.7), for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .onAppear {
            friendUser = ""
            success = ""
            ProfileModelData.startingData(modelContext: modelContext)
        }
    }
    
    private func performSearch() {
        let ws = CharacterSet.whitespacesAndNewlines
        if !friendUser.isEmpty {
            if let currentUser = authenticationService.currentUser {
                if let friend = authenticationService.fetchUserFromUserName(friendUser.trimmingCharacters(in: ws).lowercased(), modelContext: modelContext)  {
                    if (friend.username.lowercased() == currentUser.username.lowercased()) {
                        success = "You cannot follow yourself, sorry!"
                    }
                    else {
                        currentUser.updateFollowing(user: friend)
                        success = "User successfully followed"
                    }
                    
                }
                else {
                    success = "Could not find user"
                }
            }
        }
    }
    
}


#Preview {
    let authenticationService = FakeAuthenticationService()
    let previewContainer = ProfileModelData.preview
    authenticationService.login(email: "yasha@gmail.com", modelContext: previewContainer.mainContext)
    if let currentUser = authenticationService.currentUser {
        return NavigationStack { SocialMediaView() }
            .environment(authenticationService)
            .modelContainer(previewContainer)
    } else {
        return Text("Failed to create Social Media page")
    }
}

struct FollowUsersView: View {
    @Environment(FakeAuthenticationService.self) var authenticationService
    @Binding var query: String
    var onSearch: () -> Void
    
    var body: some View {
        if let currentUser = authenticationService.currentUser {
            TextField("Search for friends", text: $query)
                .padding(7)
                .padding(.horizontal, 10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .onSubmit(onSearch)
        }
        else {
            Text("Login to add friends!")
                .font(.headline)
                .foregroundColor(Color.white)
        }
    }
}


struct ShowFollowing: View {
    @Environment(FakeAuthenticationService.self) var authenticationService
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationView {
            List {
                if let currentUser = authenticationService.currentUser {
                    ForEach(currentUser.following) { follow in
                        NavigationLink(destination: FollowingView(user: follow)) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(follow.username)
                                    .font(.headline)
                                    .foregroundColor(Color.white)
                                if let biography = follow.profile?.biography {
                                    Text(biography)
                                        .font(.subheadline)
                                        .foregroundColor(Color.white)
                                } else {
                                    Text("No bio yet")
                                        .font(.subheadline)
                                        .foregroundColor(Color.white)
                                }
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                currentUser.removeFollowing(user: follow)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.green.opacity(1))
                        .cornerRadius(10)
                    }
                    .listRowBackground(Color.green.opacity(0.8))
                }
                else {
                    Text("Login to add friends!")
                        .font(.headline)
                        .foregroundColor(Color.white)
                }
            }
        }
        .background(Color.green.opacity(0.8))
        .frame(maxWidth: .infinity, alignment: .leading)
        .listStyle(.inset)
        .onAppear {
            ProfileModelData.startingData(modelContext: modelContext)
        }
    }
}

