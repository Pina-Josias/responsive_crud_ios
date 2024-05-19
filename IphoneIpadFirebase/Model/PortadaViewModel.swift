//
//  PortadaViewModel.swift
//  IphoneIpadFirebase
//
//  Created by Josias Piña on 3/3/24.
//

import FirebaseStorage
import Foundation

class PortadaViewModel: ObservableObject {
    @Published var data: Data? = nil

    init(imageUrl: String) {
        let storageImage = Storage.storage().reference(forURL: imageUrl)
        storageImage.getData(maxSize: 1*1024*1024) { data, error in
            if let error = error?.localizedDescription {
                print("Error al traer la image", error)
            } else {
                DispatchQueue.main.async {
                    self.data = data
                }
            }
        }
    }
}
