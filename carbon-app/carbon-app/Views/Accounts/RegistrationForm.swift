import SwiftUI
import SwiftData

struct RegistrationForm: View {
    @Binding var data: User.FormData
    
    var body: some View {
        Form {
            TextFieldWithLabel(label: "User Name", text: $data.username)
            TextFieldWithLabel(label: "Email", text: $data.email)
        }
    }
}

//#Preview {
//    RegistrationForm()
//}
