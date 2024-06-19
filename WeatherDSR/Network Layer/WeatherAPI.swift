//
//  WeatherAPI.swift
//  WeatherDSR
//
//  Created by Глеб Капустин on 29.05.2024.
//

import Foundation
import Moya

enum WeatherAPI {
    case current(coordinates: Coordinates)
    case forecast(coordinates: Coordinates, forecastDay: Int)
}

extension WeatherAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.Weather.baseUrl) else {
            fatalError("unvalid url")
        }
        return url
    }
    
    var path: String {
        return switch self {
        case .current:
            Constants.Weather.currentPath
        case .forecast:
            Constants.Weather.forecastPath
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        switch self {
        case .current(let coordinates):
                .requestParameters(parameters: [
                    "key": Constants.Weather.apiKey,
                    "q": "\(coordinates.latitude),\(coordinates.longitude)"
                ], encoding: URLEncoding.queryString)
        case .forecast(coordinates: let coordinates, forecastDay: let forecastDay):
                .requestParameters(parameters: [
                    "key": Constants.Weather.apiKey,
                    "q": "\(coordinates.latitude),\(coordinates.longitude)",
                    "days" : forecastDay
                ], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        return nil
    }
    
}
