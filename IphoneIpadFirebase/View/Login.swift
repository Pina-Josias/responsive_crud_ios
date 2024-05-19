//
//  Login.swift
//  IphoneIpadFirebase
//
//  Created by Josias Piña on 12/2/24.
//

import SwiftUI

struct Login: View {
    @State private var email: String = ""
    @State private var pass: String = ""
    @StateObject var login = FirebaseViewModel()
    @EnvironmentObject var loginShow: FirebaseViewModel
    var device = UIDevice.current.userInterfaceIdiom

    var body: some View {
        ZStack {
            Color.purple.ignoresSafeArea()
            VStack {
                Text("My Games")
                    .font(.title)
                    .foregroundStyle(.white)
                    .bold()
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .frame(width: device == .pad ? 400 : nil)
                    .padding(.bottom)
                SecureField("Pass", text: $pass)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: device == .pad ? 400 : nil)
                    .padding(.bottom, 20)
                Button(action: {
                    login.login(email: email, password: pass) { done in
                        if done {
                            UserDefaults.standard.set(true, forKey: "session")
                            loginShow.show.toggle()
                        }
                    }
                }) {
                    Text("Iniciar")
                        .font(.title3)
                        .foregroundStyle(.white)
                        .frame(width: 200)
                        .padding(.vertical, 20)
                }.background(
                    Capsule()
                        .stroke(.white)
                )
                Divider()
                Button(action: {
                    login.createUser(email: email, password: pass) { done in
                        if done {
                            UserDefaults.standard.set(true, forKey: "session")
                            loginShow.show.toggle()
                        }
                    }
                }) {
                    Text("Crear usuario")
                        .font(.title3)
                        .foregroundStyle(.white)
                        .frame(width: 200)
                        .padding(.vertical, 20)
                }.background(
                    Capsule()
                        .stroke(.white)
                )
            }.padding()
        }
    }
}

#Preview {
    Login()
}
