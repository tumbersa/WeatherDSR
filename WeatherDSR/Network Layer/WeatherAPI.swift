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
}

extension WeatherAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.Weather.baseUrl) else {
            fatalError("unvalid url")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .current:
            return Constants.Weather.path
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
        }
    }
    
    var headers: [String: String]? {
        return nil
    }
    
}
