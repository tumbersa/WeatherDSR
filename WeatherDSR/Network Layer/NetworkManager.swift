//
//  NetworkManager.swift
//  WeatherDSR
//
//  Created by Глеб Капустин on 28.05.2024.
//

import Foundation
import Moya

protocol Networkable {
    var provider: MoyaProvider<WeatherAPI> { get }
    func fetchCurrentWeather(coordinates: Coordinates, 
                             completion: @escaping (Result<CurrentWeatherResponse, Error>) -> Void)
}

final class NetworkManager: Networkable {
    static let shared = NetworkManager()
    private init() {}
    
    var provider: MoyaProvider<WeatherAPI> = MoyaProvider<WeatherAPI>(plugins: [NetworkLoggerPlugin()])
    
    func fetchCurrentWeather(coordinates: Coordinates, 
                             completion: @escaping (Result<CurrentWeatherResponse, Error>) -> Void) {
        request(target: .current(coordinates: coordinates), completion: completion)
    }
}

private extension NetworkManager {
    func request<T: Decodable>(target: WeatherAPI, completion: @escaping (Result<T, Error>) -> Void) {
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    if let json = try? JSONSerialization.jsonObject(with: response.data, options: []) {
                        print("Error JSON: \(json)")
                    }
                    
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(results))
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

// final class NetworkManager {
//    static let shared = NetworkManager()
//    
//    private init() {}
//    
//    private let decoder = JSONDecoder()
//    
//    
//    
//    func getCurrentWeather() {
//        let url = URL(string: Constants.Weather.baseUrl)!
//        
//        let request = URLRequest(url: url)
//        
//        let task = URLSession.shared.dataTask(with: request) {[weak self] data, response, error in
//            guard let self else { return }
//            
//            if let error {
//                print(error)
//                return
//            }
//            
//            guard let response = response as? HTTPURLResponse,
//                  response.statusCode == 200 else {
//                print((response as? HTTPURLResponse)?.statusCode)
//                if let data = data {
//                    do {
//                        let decodedResponse = try decoder.decode(ErrorResponse.self, from: data)
//                        print(decodedResponse)
//                    } catch {
//                        print("Failed to decode error response: \(error)")
//                    }
//                }
//                return
//            }
//            
//            guard let data else {
//                print("")
//                return
//            }
//            
//            do {
//                let decodedResponse = try decoder.decode(CurrentWeatherResponse.self, from: data)
//                print(decodedResponse)
//            } catch {
//                print(error)
//            }
//        }
//        
//        task.resume()
//    }
// }

// struct ErrorResponse: Codable {
//    let error: ErrorStruct
// }
// struct ErrorStruct: Codable {
//    let code: Int
//    let message: String
// }
