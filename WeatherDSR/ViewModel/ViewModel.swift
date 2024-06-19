//
//  ViewModel.swift
//  WeatherDSR
//
//  Created by Глеб Капустин on 29.05.2024.
//

import Foundation
import Combine

struct ForecastInfo {
    let tempC: Double
    let date: String
    let precipitation: Double
}

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
    
    private let calendar = Calendar.current
    private let forecastDay = 2
    
    private lazy var dateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter
    }()
    
    private var deviceLocationService = DeviceLocationService.shared
    
    private var tokens: Set<AnyCancellable> = []
    private var coordinates: (lat: Double, lon: Double)?
    
    @Published var forecastInfo: [ForecastInfo] = []
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
                    let coord = Coordinates(
                        latitude: coordinates.latitude,
                        longitude: coordinates.longitude
                    )
                    requestCurrentWeather(coordinates: coord)
                    
                    requestForecast(coordinates: coord, forecastDay: forecastDay)
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
    
    private func requestCurrentWeather(coordinates: Coordinates) {
        networkManager.fetchCurrentWeather(coordinates: coordinates) {[weak self] result in
            guard let self else {return}
            switch result {
            case .success(let body):
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
    
    private func requestForecast(coordinates: Coordinates, forecastDay: Int) {
        networkManager.fetchForecastWeather(coordinates: coordinates, forecastDay: forecastDay) { [weak self] result in
            guard let self else {return}
            switch result {
            case .success(let body):
                print(body)
                let currentDate = Date()
                let currentHour = calendar.component(.hour, from: currentDate)
            
                appendForecastArray(body: body.forecast.forecastday[0])
                
                // Второй день
                if 18 < currentHour {
                    appendForecastArray(body: body.forecast.forecastday[1])
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func appendForecastArray(body: ForecastModel.Forecastday) {
        let currentDate = Date()
        let currentHour = calendar.component(.hour, from: currentDate)
        let currentDay = calendar.component(.day, from: currentDate)
        
        body.hour.filter {[weak self] hourForecast in
            let dateString = hourForecast.time ?? ""
            guard let self, let date = dateFormatter.date(from: dateString) else { return false}
            
            let forecastHour = calendar.component(.hour, from: date)
            let forecastDay = calendar.component(.day, from: date)
            
            if forecastDay == currentDay {
                return forecastHour > currentHour && currentHour + 5 >= forecastHour
            } else {
                return forecastHour + 4 - forecastInfo.count >= 0
            }
        }.sorted(by: {
            $0.time ?? "" > $1.time ?? ""
        })
        .forEach { [weak self] hourForecast in
            guard let self else { return }
            
            forecastInfo.append(ForecastInfo(tempC: hourForecast.tempC,
                                             date: hourForecast.time ?? "",
                                             precipitation: hourForecast.precipMm))
        }
    }
}
