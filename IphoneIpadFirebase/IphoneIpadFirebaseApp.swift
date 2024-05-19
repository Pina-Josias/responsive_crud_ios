//
//  IphoneIpadFirebaseApp.swift
//  IphoneIpadFirebase
//
//  Created by Josias Piña on 4/2/24.
//

import FirebaseCore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
    {
        FirebaseApp.configure()

        return true
    }
}

@main
struct IphoneIpadFirebaseApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        let login = FirebaseViewModel()
        WindowGroup {
            ContentView().environmentObject(login)
        }
    }
}
