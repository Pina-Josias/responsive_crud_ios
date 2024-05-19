//
//  ContentView.swift
//  IphoneIpadFirebase
//
//  Created by Josias Piña on 4/2/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var loginShow: FirebaseViewModel

    var body: some View {
        Group {
            if !loginShow.show {
                Login()
            } else {
                Home()
                    .ignoresSafeArea()
                    .preferredColorScheme(.dark)
            }
        }.onAppear {
            if UserDefaults.standard.object(forKey: "session") != nil {
                loginShow.show = true
            }
        }
    }
}

#Preview {
    ContentView()
}
