//
//  NetworkDataFetch.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 26.11.2022.
//

import Foundation
import CoreLocation

final class NetworkDataFetch {
    
    static let shared  = NetworkDataFetch()
    private init() {}
    
    func fetchWeatherLocation(lat: CLLocationDegrees, lon: CLLocationDegrees, response: @escaping (WeatherModel?, Error?) -> Void) {
        NetworkRequest.shared.requestDataLocation(lat: lat, lon: lon) { result in
            switch result {
            case .success(let data):
                do {
                    let weather = try JSONDecoder().decode(WeatherModel.self, from: data)
                    response(weather, nil)
                } catch let jSONError {
                    print("Failed decode JSON", jSONError)
                }
            case .failure(let error):
                print(error.localizedDescription)
                response(nil, error)
            }
        }
    }
}
