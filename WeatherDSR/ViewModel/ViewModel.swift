//
//  ViewModel.swift
//  WeatherDSR
//
//  Created by Глеб Капустин on 29.05.2024.
//

import Foundation
import Combine

struct WeatherInfo {
    let pressureMB: Double
    let region: String
    let tempC: Double
    let windKph: Double
    let precipitation: Double
}

struct Coordinates {
    let latitude: Double
    let longitude: Double
}

final class ViewModel: ObservableObject {
    private var deviceLocationService = DeviceLocationService.shared
    
    private var tokens: Set<AnyCancellable> = []
    private var coordinates: (lat: Double, lon: Double)?
    
    @Published var weatherInfo = WeatherInfo(pressureMB: 0, region: "Placeholder", tempC: 0, windKph: 0, precipitation: 0)
    
    private let networkManager = NetworkManager.shared
    
    func observeCoordinateUpdates() {
        deviceLocationService.coordinatesPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { [weak self] coordinates in
                guard let self else {return}
                
                if self.coordinates == nil {
                    networkManager.fetchCurrentWeather(coordinates: Coordinates(
                        latitude: coordinates.latitude,
                        longitude: coordinates.longitude
                    )) {[weak self] result  in
                        
                        guard let self else {return}
                        switch result {
                        case .success(let body):
                            print(body)
                            weatherInfo = WeatherInfo(pressureMB: body.current.pressureMB,
                                                      region: body.location.region,
                                                      tempC: body.current.tempC,
                                                      windKph: body.current.windKph,
                                                      precipitation: body.current.precipMm)
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
    
    func requestLocationUpdates() {
        deviceLocationService.requestLocationUpdates()
    }
}
