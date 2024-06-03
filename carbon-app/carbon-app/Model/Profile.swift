
import Foundation
import SwiftData
import SwiftUI

@Model
class Profile {
    var name: String
    var biography: String
    var avatar: Data?
    
    @Relationship
    var user: User?
    
    init(name: String = "", biography: String = "", avatar: Data? = nil) {
        self.name = name
        self.biography = biography
        self.avatar = avatar
    }
    
    var avatarImage: Image {
        if let data = avatar, let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        }
        return Image(systemName: "person.fill")
    }
    
    struct FormData: Identifiable {
        var id: UUID = UUID()
        var name: String = ""
        var biography: String = ""
        var avatar: Data?
    }
    
    var dataForForm: FormData {
        FormData(name: name, biography: biography)
    }
    
    func update(from data:FormData) {
        self.name = data.name
        self.biography = data.biography
        self.avatar = data.avatar
    }
}

extension Profile {
    struct RegistrationData: Identifiable {
        var id = UUID()
        var username: String = ""
        var email: String = ""
    }
}
