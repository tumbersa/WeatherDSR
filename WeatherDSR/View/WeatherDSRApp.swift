//
//  WeatherDSRApp.swift
//  WeatherDSR
//
//  Created by Глеб Капустин on 28.05.2024.
//

import GoogleSignIn
import SwiftUI

@main
struct WeatherDSRApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if GIDSignIn.sharedInstance.hasPreviousSignIn() {
                    ContentView()
                } else {
                    AuthView()
                        .onOpenURL { url in
                            GIDSignIn.sharedInstance.handle(url)
                        }
                }
            }
        }
    }
}
