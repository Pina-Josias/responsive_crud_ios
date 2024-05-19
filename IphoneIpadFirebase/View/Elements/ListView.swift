//
//  ListView.swift
//  IphoneIpadFirebase
//
//  Created by Josias Piña on 3/3/24.
//

import SwiftUI

struct ListView: View {
    var device = UIDevice.current.userInterfaceIdiom
    var platform: String
    @StateObject var datos = FirebaseViewModel()
    @State private var isLandscape: Bool = false
    @State private var edit: Bool = false

    func getColumns() -> Int {
        return device == .pad ? 3 : ((device == .phone && isLandscape) ? 3 : 1)
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: getColumns()), spacing: 20) {
                ForEach(datos.data) { item in
                    CardView(title: item.title, portada: item.portada, index: item, platform: platform)
                        .onTapGesture {
                            edit.toggle()
                        }.sheet(isPresented: $edit, content: {
                            EditView(plataforma: platform, datos: item)
                        })
                        .padding(.all)
                }
            }
        }.onAppear {
            datos.getData(platform: platform)
            NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main) { _ in
                let orientation = UIDevice.current.orientation
                self.isLandscape = orientation.isLandscape
            }
        }
    }
}
