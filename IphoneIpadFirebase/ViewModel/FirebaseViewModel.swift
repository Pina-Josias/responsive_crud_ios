//
//  FirebaseViewModel.swift
//  IphoneIpadFirebase
//
//  Created by Josias Piña on 12/2/24.
//

import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import Foundation

class FirebaseViewModel: ObservableObject {
    @Published var show = false
    @Published var data = [FirebaseModel]()

    func login(email: String, password: String, completation: @escaping (_ done: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if user != nil {
                print("Entro")
                completation(true)
            } else {
                if let error = error?.localizedDescription {
                    print("Error de firebase", error)
                } else {
                    print("Error en la app")
                }
            }
        }
    }

    func createUser(email: String, password: String, completation: @escaping (_ done: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if user != nil {
                print("Registro e inicio con exito")
                completation(true)
            } else {
                if let error = error?.localizedDescription {
                    print("Error de firebase", error)
                } else {
                    print("Error en la app")
                }
            }
        }
    }

    // Base de datos

    // Save
    func save(titulo: String, desc: String, platform: String, portada: Data, completation: @escaping (_ done: Bool) -> Void) {
        // Guarda la imagen
        saveImage(portada: portada) { downloadURL in
            // Guardar el texto
            let db = Firestore.firestore()
            let id = UUID().uuidString
            guard let idUser = Auth.auth().currentUser?.uid else { return }
            guard let email = Auth.auth().currentUser?.email else { return }
            let campos: [String: Any] = ["titulo": titulo, "desc": desc, "portada": String(describing: downloadURL), "idUser": idUser, "email": email]
            db.collection(platform).document(id).setData(campos) { error in
                if let error = error?.localizedDescription {
                    print("Error al guardar en Firestore", error)
                } else {
                    print("se guardo")
                    completation(true)
                }
            }
        }
    }

    // Guardar
    func saveImage(portada: Data, onUploadImage: @escaping (_ url: String) -> Void) {
        let storage = Storage.storage().reference()
        let nombrePortada = UUID().uuidString
        let directory = storage.child("images/\(nombrePortada).jpg")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"

        directory.putData(portada, metadata: metaData) { metadata, error in
            guard let _ = metadata else {
                // Handle error
                print("Error uploading image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            // Image uploaded successfully
            print("Image uploaded successfully")
            directory.downloadURL { url, error in
                guard let downloadURL = url else {
                    // Handle error
                    print("Error getting download URL: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                // You can use imageURL for further operations like sharing or displaying the uploaded image
                print("Download URL: \(downloadURL)")
                onUploadImage(String(describing: downloadURL))
                // Guardar el texto
//                let db = Firestore.firestore()
//                let id = UUID().uuidString
//                guard let idUser = Auth.auth().currentUser?.uid else { return }
//                guard let email = Auth.auth().currentUser?.email else { return }
//                let campos: [String: Any] = ["titulo": titulo, "desc": desc, "portada": String(describing: downloadURL), "idUser": idUser, "email": email]
//                db.collection(platform).document(id).setData(campos) { error in
//                    if let error = error?.localizedDescription {
//                        print("Error al guardar en Firestore", error)
//                    } else {
//                        print("se guardo")
//                        completation(true)
//                    }
//                }
                // Termino de guardar el texto
            }
        }
    }

    // Show data
    func getData(platform: String) {
        let db = Firestore.firestore()
        db.collection(platform).addSnapshotListener { snapshot, error in
            if let error = error?.localizedDescription {
                print("Error on showing data", error)
            } else {
                self.data.removeAll()
                for doc in snapshot!.documents {
                    let value = doc.data()
                    let id = doc.documentID
                    let title = value["titulo"] as? String ?? "No title"
                    let desc = value["desc"] as? String ?? "No title"
                    let portada = value["portada"] as? String ?? "No title"
                    DispatchQueue.main.async {
                        let registros = FirebaseModel(id: id, title: title, desc: desc, portada: portada)
                        self.data.append(registros)
                    }
                }
            }
        }
    }

    // Delete
    func delete(index: FirebaseModel, platform: String) {
        // delete form firestore
        let id = index.id
        let db = Firestore.firestore()
        db.collection(platform).document(id).delete()
        // delete from storage
        let imagen = index.portada
        let borrarImage = Storage.storage().reference(forURL: imagen)
        borrarImage.delete(completion: nil)
    }

    // Edit register
    func edit(title: String, desc: String, platform: String, id: String, completation: @escaping (_ done: Bool) -> Void) {
        let fields: [String: Any] = ["titulo": title, "desc": desc]
        let db = Firestore.firestore()
        db.collection(platform).document(id).updateData(fields) { error in
            if let error = error?.localizedDescription {
                print("Error on edition fields", error)
            } else {
                print("Update with success")
            }
        }
    }

    // Edit with Image
    func editWithImage(title: String, desc: String, platform: String, index: FirebaseModel, portada: Data, id: String, completation: @escaping (_ done: Bool) -> Void) {
        // delete from storage
        let imagen = index.portada
        let borrarImage = Storage.storage().reference(forURL: imagen)
        borrarImage.delete(completion: nil)

        // upload new image
        saveImage(portada: portada) { downloadURL in
            let db = Firestore.firestore()
            let fields: [String: Any] = ["titulo": title, "desc": desc, "portada": String(describing: downloadURL)]
            db.collection(platform).document(id).updateData(fields) { error in
                if let error = error?.localizedDescription {
                    print("Error al editar en Firestore", error)
                    completation(false)
                } else {
                    print("Update with success")
                    completation(true)
                }
            }
        }
    }
}
