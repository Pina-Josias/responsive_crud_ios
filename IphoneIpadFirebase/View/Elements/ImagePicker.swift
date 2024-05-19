//
//  ImagePicker.swift
//  IphoneIpadFirebase
//
//  Created by Josias Piña on 18/2/24.
//

import PhotosUI
import SwiftUI
import UIKit

struct ImagePickerView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct CameraPicker: UIViewControllerRepresentable {
    @Binding var image: Data?
    @Environment(\.presentationMode) var presentationMode
    let sourceType: UIImagePickerController.SourceType = .camera

    func makeUIViewController(context: Context) -> some UIImagePickerController {
        let controller = UIImagePickerController()
        controller.sourceType = sourceType
        controller.allowsEditing = true
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // Nothing to update
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraPicker

        init(_ parent: CameraPicker) {
            self.parent = parent
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            print("cancelled")
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                DispatchQueue.main.async {
                    let data = uiImage.jpegData(compressionQuality: 0.100)
                    self.parent.image = data!
                }
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: Data?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        // Nothing to update
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.image = nil
            if let result = results.first {
                result.itemProvider.loadObject(ofClass: UIImage.self) { image, _ in
                    if let image = image as? UIImage {
                        DispatchQueue.main.async {
                            let data = image.jpegData(compressionQuality: 0.100)
                            self.parent.image = data!
                        }
                    }
                }
            }
            // picker.dismiss(animated: true, completion: nil)
        }
    }
}
