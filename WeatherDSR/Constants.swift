//
//  Constants.swift
//  WeatherDSR
//
//  Created by Глеб Капустин on 29.05.2024.
//

import Foundation

struct Coordinates {
    let latitude: Double
    let longitude: Double
}

enum Constants {
    enum Weather {
        static let apiKey = "81c3719dbe7c4784aaa130204242805"
        static let baseUrl = "http://api.weatherapi.com/v1"
        static let path = "/current.json"
    }
    
    static let lonLat = "51.746699,39.343521"
    
    // current.json?key=\(apiKey)&q=\(lonLat)&aqi=yes
}
