//
//  EditView.swift
//  IphoneIpadFirebase
//
//  Created by Josias Piña on 18/5/24.
//

import SwiftUI

struct EditView: View {
    @State private var titulo: String = ""
    @State private var desc: String = ""
    var plataforma: String
    var datos: FirebaseModel
    @StateObject var guardar = FirebaseViewModel()

    @State private var imageData: Data? = .init(Data(capacity: 0))
    @State private var showMenu: Bool = false
    @State private var progress = false

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            ZStack {
                Color.yellow.ignoresSafeArea()
                VStack {
                    TextField("Titulo", text: $titulo)
                        .background(Color.white)
                        .textFieldStyle(.roundedBorder)
                        .onAppear {
                            titulo = datos.title
                        }
                    TextEditor(text: $desc)
                        .frame(height: 200)
                        .preferredColorScheme(.dark)
                        .onAppear {
                            desc = datos.desc
                        }
                    Button(action: {
                        showMenu.toggle()
                    }) {
                        Text("Cargar imagen")
                            .foregroundStyle(.black)
                            .bold()
                            .font(.title3)
                            .padding()
                    }.confirmationDialog("Escoger tipo", isPresented: $showMenu) {
                        NavigationLink("Camera", value: "Camera")
                        NavigationLink("Library", value: "Library")
                    }
                    if imageData?.count != 0 && imageData != nil {
                        Image(uiImage: UIImage(data: imageData!)!)
                            .resizable()
                            .frame(width: 250, height: 250)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                    Button(action: {
                        if imageData?.count == 0 {
                            guardar.edit(title: titulo, desc: desc, platform: plataforma, id: datos.id) { done in
                                if done {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        } else {
                            progress.toggle()
                            guardar.editWithImage(title: titulo, desc: desc, platform: plataforma, index: datos, portada: imageData!, id: datos.id) { done in
                                if done {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }

                    }) {
                        Text("Guardar")
                            .foregroundStyle(.black)
                            .bold()
                            .font(.title3)
                            .padding()
                    }
                    .background(
                        Capsule()
                            .stroke(Color.black)
                    )

                    Spacer()
                    if progress {
                        Text("Wait a moment please...")
                            .foregroundStyle(.black)
                        ProgressView()
                    }
                    Spacer()
                }
                .padding()
                .navigationDestination(for: String.self, destination: { type in
                    switch type {
                    case "Camera":
                        CameraPicker(image: $imageData)
                    case "Library":
                        ImagePicker(image: $imageData)
                    default:
                        EmptyView()
                    }
                })

            }.preferredColorScheme(.light)
        }
    }
}
