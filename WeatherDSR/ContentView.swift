//
//  ContentView.swift
//  WeatherDSR
//
//  Created by Глеб Капустин on 28.05.2024.
//

import Combine
import SwiftUI

struct ContentView: View {
    
    @StateObject var deviceLocationService = DeviceLocationService.shared
    
    @State var tokens: Set<AnyCancellable> = []
    @State var coordinates: (lat: Double, lon: Double) = (0, 0)
    
    var body: some View {
        VStack {
            Text("Latitude: \(coordinates.lat)")
            Text("Longitude: \(coordinates.lon)")
        }
        .padding()
        .onAppear {
            observeCoordinateUpdates()
            observeLocationAccessDenied()
            deviceLocationService.requestLocationUpdates()
        }
    }
    
    func observeCoordinateUpdates() {
        deviceLocationService.coordinatesPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { coordinates in
                self.coordinates = (coordinates.latitude, coordinates.longitude)
            }
            .store(in: &tokens)
    }
    
    func observeLocationAccessDenied() {
        deviceLocationService.deniedLocationAccessPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
                print("Denied access")
            }
            .store(in: &tokens)
    }
}

#Preview {
    ContentView()
}
