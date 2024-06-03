import SwiftUI
import AuthenticationServices

struct LoginScreen: View {
    @Environment(FakeAuthenticationService.self) var authenticationService
    @Environment(\.modelContext) private var modelContext
    @State var email: String = ""
    @State var validationStatus: Bool = false
    @State var loginError: String = ""
    
    
    @State private var isPresentingUserForm: Bool = false
    @State private var newUserFormData = User.FormData()
    
    var body: some View {
        VStack {
            Text("Log In or Create an Account!")
                .fontWeight(.bold)
                .font(.title2)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 20)
            Image(systemName: "leaf.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(height: 100)
                .padding(.bottom, 50)
            Spacer()
            WelcomeSection()
            Spacer()
            TextFieldWithLabel(label: "Email", text: $email, validationStatus: $validationStatus, validationMessage: "Valid emails only.") { email.contains("@") }
            HStack{
                Button("Sign In") { authenticationService.login(email: email, modelContext: modelContext) }
                    .buttonStyle(.borderedProminent)
            }
            if let errorMessage = authenticationService.errorMessage {
                Text(errorMessage)
                    .font(.headline)
                    .foregroundStyle(.red)
            }
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Register") {
                    isPresentingUserForm.toggle()
                }
                .foregroundColor(.white)
                .fontWeight(.bold)
            }
        }
        .sheet(isPresented: $isPresentingUserForm) {
            NavigationStack {
                RegistrationForm(data: $newUserFormData)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel") { isPresentingUserForm.toggle()
                                newUserFormData = User.FormData()
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Save") {
                                User.create(from: newUserFormData, context: modelContext, following: [])
                                newUserFormData = User.FormData()
                                isPresentingUserForm.toggle()                }
                        }
                    }
                    .navigationTitle("Account Registration")
            }
        }
        .toolbarBackground(Color.green.opacity(0.5), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .padding()
    }
    
    private struct WelcomeSection: View {
        var body: some View {
            HStack {
                Image(systemName: "quote.bubble.fill")
                    .foregroundColor(.white)
                Text("\"ZeroHero makes sustainability rewarding and achievable.\" - The Wall Street Journal")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(.subheadline)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.green.opacity(0.8))
            .cornerRadius(10)
        }
    }
    
    
    func handleFailedAppleAuthorization(_ error: Error) {
        print("Authorization Failed \(error)")
    }
}
