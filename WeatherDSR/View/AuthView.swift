//
//  AuthView.swift
//  WeatherDSR
//
//  Created by Глеб Капустин on 19.06.2024.
//

import GoogleSignInSwift
import GoogleSignIn
import SwiftUI

struct AuthView: View {
    @State private var userInfo = ""
    @State private var isSignedIn = false
    
    var body: some View {
        NavigationView {
            VStack {
                GoogleSignInButton(style: .wide) {
                    self.userInfo = ""
                    guard let rootViewController = self.rootViewController else {
                        print("No root view controller")
                        return
                    }
                    GIDSignIn.sharedInstance.signIn(
                        withPresenting: rootViewController) { result, error in
                            guard let result else {
                                print("Error signing in: \(String(describing: error))")
                                return
                            }
                            print("Successfully signed in user")
                            self.userInfo = result.user.profile?.name ?? ""
                            self.isSignedIn = true
                        }
                }
                
                NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true), isActive: $isSignedIn) {
                    EmptyView()
                }.hidden()
            }
        }
    }
    
    var rootViewController: UIViewController? {
        return UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .compactMap { $0 as? UIWindowScene }
            .compactMap { $0.keyWindow }
            .first?.rootViewController
    }
    
}

#Preview {
    AuthView()
}
