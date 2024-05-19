//
//  NavBar.swift
//  IphoneIpadFirebase
//
//  Created by Josias Piña on 4/2/24.
//

import Firebase
import SwiftUI

struct NavBar: View {
    var device = UIDevice.current.userInterfaceIdiom
    @Binding var index: String
    @Binding var menu: Bool
    @EnvironmentObject var loginShow: FirebaseViewModel

    var body: some View {
        HStack {
            Text("My Games")
                .font(.title)
                .bold()
                .foregroundStyle(.white)
                .font(.system(size: device == .phone ? 25 : 35))
            Spacer()
            if device == .pad {
                // menu ipad
                HStack(spacing: 25) {
                    ButtonView(index: $index, menu: $menu, title: "PlayStation")
                    ButtonView(index: $index, menu: $menu, title: "Xbox")
                    ButtonView(index: $index, menu: $menu, title: "Nintendo")
                    ButtonView(index: $index, menu: $menu, title: "Agregar")
                    Button(action: {
                        try! Auth.auth().signOut()
                        UserDefaults.standard.removeObject(forKey: "session")
                        loginShow.show = false
                    }) {
                        Text("Salir")
                            .font(.title)
                            .frame(width: 200)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 10)
                    }.background(
                        Capsule()
                            .stroke(Color.white)
                    )
                }
            } else {
                // menu phone
                Button(action: {
                    withAnimation {
                        menu.toggle()
                    }
                }) {
                    Image(systemName: "line.horizontal.3")
                        .font(.system(size: 26))
                        .foregroundStyle(.white)
                }
            }
        }
        .padding(.top, 30)
        .padding()
        .background(Color.purple)
    }
}
