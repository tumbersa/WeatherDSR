//
//  ContentView.swift
//  WeatherDSR
//
//  Created by Глеб Капустин on 28.05.2024.
//

import Combine
import SwiftUI

struct ContentView: View {
    // TODO: - перенести во ViewModel логику с локацией
    @StateObject var deviceLocationService = DeviceLocationService.shared
    
    @State var pressureMB: Double = 0
    @State var region: String = ""
    @State var tempC = 0.0
    @State var windKph = 0.0
    @State var precipitation = 0.0
    
    @State var tokens: Set<AnyCancellable> = []
    @State var coordinates: (lat: Double, lon: Double)?
    
    private let networkManager = NetworkManager.shared
    
    var body: some View {
        VStack {
            Text("Latitude: \(coordinates?.lat ?? 0)")
            Text("Longitude: \(coordinates?.lon ?? 0)")
            Text("Weather:")
            Text("region: \(region)")
            Text("pressureMB: \(pressureMB)")
            Text("tempC: \(tempC)")
            Text("windKph: \(windKph)")
            Text("precipitation: \(precipitation)")
            
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
                if self.coordinates == nil {
                    networkManager.fetchCurrentWeather(
                        coordinates: Coordinates(latitude: coordinates.latitude, 
                                                 longitude: coordinates.longitude)) { result  in
                            switch result {
                            case .success(let body):
                                print(body)
                                pressureMB = body.current.pressureMB
                                region = body.location.region
                                tempC = body.current.tempC
                                windKph = body.current.windKph
                                precipitation = body.current.precipMm
                            case .failure(let error):
                                print(error)
                            }
                        }
                }
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
