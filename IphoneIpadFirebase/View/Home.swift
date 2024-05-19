//
//  Home.swift
//  IphoneIpadFirebase
//
//  Created by Josias Piña on 4/2/24.
//

import SwiftUI

struct Home: View {
    @Environment(\.horizontalSizeClass) private var widthClass
    @State private var index = "PlayStation"
    @State private var menu = false
    @State private var widthMenu = UIScreen.main.bounds.width

    var body: some View {
        ZStack {
            VStack {
                NavBar(index: $index, menu: $menu)
                ZStack {
                    switch index {
                    case "PlayStation":
                        ListView(platform: "playstation")
                    case "Xbox":
                        ListView(platform: "xbox")
                    case "Nintendo":
                        ListView(platform: "nintendo")
                    default:
                        AddView()
                    }
                }
            }
            if menu {
                HStack {
                    Spacer()
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                withAnimation {
                                    menu.toggle()
                                }
                            }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundStyle(.white)
                            }
                        }
                        .padding()
                        .padding(.top, 50)
                        VStack(alignment: .trailing) {
                            ButtonView(index: $index, menu: $menu, title: "PlayStation")
                            ButtonView(index: $index, menu: $menu, title: "Xbox")
                            ButtonView(index: $index, menu: $menu, title: "Nintendo")
                            ButtonView(index: $index, menu: $menu, title: "Agregar")
                            ButtonView(index: $index, menu: $menu, title: "Salir")
                        }
                        Spacer()
                    }
                    .frame(width: widthMenu - 150)
                    .background(Color.purple)
                }
            }
        }.background(Color.white.opacity(0.9))
    }
}

#Preview {
    Home()
}
