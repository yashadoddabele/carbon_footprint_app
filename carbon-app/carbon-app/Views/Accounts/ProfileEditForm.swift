import SwiftUI
import PhotosUI

struct ProfileEditForm: View {
    @Environment(FakeAuthenticationService.self) var authenticationService
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @Bindable var photoService = PhotoTransferService()
    @State var profileData: Profile.FormData
    
    
    var body: some View {
        NavigationStack {
            Form {
                VStack {
                    HStack {
                        AvatarImage(imageData: profileData.avatar, size: 100)
                        Spacer()
                        VStack {
                            Text("Change Photo")
                            PhotosPicker(selection: $photoService.imageSelection,
                                         matching: .images,
                                         photoLibrary: .shared()) {
                                Image(systemName: "pencil.circle.fill")
                                    .symbolRenderingMode(.multicolor)
                                    .font(.system(size: 30))
                                    .foregroundColor(.accentColor)
                            }
                        }
                    }
                }
                if case .success(_) = photoService.imageState  {
                    HStack {
                        CurrentSelectionDisplay(imageState: photoService.imageState)
                        if case .success(let (_, data)) = photoService.imageState  {
                            Button("Apply Photo") {
                                profileData.avatar = data
                                photoService.clearSelection()
                            }
                        }
                    }
                }
                TextFieldWithLabel(label: "Name", text: $profileData.name)
                VStack {
                    Text("Biography")
                        .bold()
                        .font(.caption)
                    TextEditor(text: $profileData.biography)
                        .frame(height: 200)
                }
            }
            .navigationTitle("Edit Profile")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        if let profile = authenticationService.currentUser?.profile {
                            profile.update(from: profileData)
                        }
                        dismiss()
                    }
                }
            }
        }
    }
}

struct CurrentSelectionDisplay: View {
    let imageState: PhotoTransferService.ImageState
    
    var body: some View {
        switch imageState {
        case .success(let (image, _)):
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        case .loading:
            ProgressView()
        case .empty:
            Image(systemName: "person.fill")
                .font(.system(size: 40))
                .foregroundColor(.white)
        case .failure:
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.white)
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
        return NavigationStack { ProfileEditForm(profileData: Profile(name: "Preview Name", biography: "Preview biography", avatar: nil).dataForForm) }
            .environment(authenticationService)
            .modelContainer(previewContainer)
    } else {
        return Text("Failed to create User")
    }
    
}
