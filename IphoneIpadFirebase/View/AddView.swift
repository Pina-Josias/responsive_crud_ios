//
//  AddView.swift
//  IphoneIpadFirebase
//
//  Created by Josias Piña on 18/2/24.
//

import SwiftUI

struct AddView: View {
    @State private var titulo: String = ""
    @State private var desc: String = ""
    var consolas = ["playstation", "xbox", "nintendo"]
    @State private var plataforma: String = "playstation"
    @StateObject var guardar = FirebaseViewModel()

    @State private var imageData: Data? = .init(Data(capacity: 0))
    @State private var showMenu: Bool = false
    @State private var progress = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.yellow.ignoresSafeArea()
                VStack {
                    TextField("Titulo", text: $titulo)
                        .background(Color.white)
                        .textFieldStyle(.roundedBorder)
                    TextEditor(text: $desc)
                        .frame(height: 200)
                        .preferredColorScheme(.dark)
                    Picker("Consolas", selection: $plataforma) {
                        ForEach(consolas, id: \.self) { item in
                            Text(item)
                        }
                    }.tint(.black)
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
                        Button(action: {
                            progress.toggle()
                            guardar.save(titulo: titulo, desc: desc, platform: plataforma, portada: imageData!) { done in
                                if done {
                                    progress.toggle()
                                    titulo = ""
                                    desc = ""
                                    imageData = .init(Data(capacity: 0))
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
                    }
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

#Preview {
    AddView()
}
