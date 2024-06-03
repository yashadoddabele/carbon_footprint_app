import SwiftUI

struct AvatarImage: View {
  let imageData: Data?
  let size: CGFloat

  var body: some View {
    Group {
      if let data = imageData, let uiImage = UIImage(data: data) {
        Image(uiImage: uiImage)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .clipShape(Circle())
          .frame(width: size, height: size)
      } else {
        Image(systemName: "person.fill")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .mask(alignment: .top) { Circle() }
          .clipShape(Circle())
          .frame(width: size, height: size)
      }
    }
  }
}

//#Preview {
//  AvatarImage(imageData: UIImage(resource: .jon).pngData()!, size: 100)
//}
