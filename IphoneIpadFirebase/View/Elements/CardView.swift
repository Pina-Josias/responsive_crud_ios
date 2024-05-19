//
//  CardView.swift
//  IphoneIpadFirebase
//
//  Created by Josias Piña on 4/2/24.
//

import SwiftUI

struct CardView: View {
    var title: String
    var portada: String

    var index: FirebaseModel
    var platform: String

    @StateObject var datos = FirebaseViewModel()

    var body: some View {
        VStack(spacing: 20) {
            ImageFirebase(imageUrl: portada)
            Text(title)
                .font(.title)
                .bold()
                .foregroundStyle(.black)
            Button(action: {
                datos.delete(index: index, platform: platform)
            }) {
                Text("Delete")
                    .foregroundStyle(.red)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                    .background(Capsule().stroke(Color.red))
            }
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .circular))
    }
}
