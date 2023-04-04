//
//  NetworkRequest.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 26.11.2022.
//

import Foundation
import CoreLocation

final class NetworkRequest {
    
    static let shared = NetworkRequest()
    private init() {}
    
    func requestDataLocation(lat: CLLocationDegrees, lon: CLLocationDegrees, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        let key = "6aef5b364fed33e25944526e9472c597"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(key)"
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completionHandler(.failure(error))
                    return
                }
                guard let data = data else {return}
                completionHandler(.success(data))
            }
        }
        .resume()
    }
}
