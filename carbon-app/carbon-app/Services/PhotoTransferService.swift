import SwiftUI
import PhotosUI
import CoreTransferable

@Observable
class PhotoTransferService {

  enum ImageState {
    case empty
    case loading(Progress)
    case success((Image, Data))
    case failure(Error)
  }

  var imageState: ImageState = .empty
  var imageSelection: PhotosPickerItem? = nil {
    didSet {
      if let imageSelection {
        let progress = loadTransferable(from: imageSelection)
        imageState = .loading(progress)
      } else {
        imageState = .empty
      }
    }
  }

  func clearSelection() {
    imageState = .empty
  }

  private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
    return imageSelection.loadTransferable(type: TransferredPhoto.self) { result in
      DispatchQueue.main.async {
        guard imageSelection == self.imageSelection else {
          print("Failed to get the selected item.")
          return
        }
        switch result {
        case .success(let selectedImage?):
          self.imageState = .success((selectedImage.image, selectedImage.data))
        case .success(nil):
          self.imageState = .empty
        case .failure(let error):
          self.imageState = .failure(error)
        }
      }
    }
  }
}

struct PhotoFromLibrary: Identifiable {
  let id: UUID = UUID()
  let photo: Image
}

enum TransferError: Error {
  case importFailed
}

struct TransferredPhoto: Transferable {
  let image: Image
  let data: Data

  static var transferRepresentation: some TransferRepresentation {
    DataRepresentation(importedContentType: .image) { data in
      guard let uiImage = UIImage(data: data) else {
        throw TransferError.importFailed
      }
      let image = Image(uiImage: uiImage)
      return TransferredPhoto(image: image, data: data)
    }
  }
}
