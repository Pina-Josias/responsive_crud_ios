//
//  ImageFirebase.swift
//  IphoneIpadFirebase
//
//  Created by Josias Piña on 3/3/24.
//

import SwiftUI

struct ImageFirebase: View {
    let imageAlt = UIImage(systemName: "photo")
    @ObservedObject var imageLoader: PortadaViewModel

    init(imageUrl: String) {
        imageLoader = PortadaViewModel(imageUrl: imageUrl)
    }

    var image: UIImage? {
        imageLoader.data.flatMap(UIImage.init)
    }

    var body: some View {
        Image(uiImage: image ?? imageAlt!)
            .resizable()
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 5)
            .aspectRatio(contentMode: .fit)
    }
}
