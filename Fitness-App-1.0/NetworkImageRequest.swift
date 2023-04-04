//
//  NetworkImageRequest.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 26.11.2022.
//

import Foundation

final class NetworkImageRequest {
    
    static let shared = NetworkImageRequest()
    private init() {}
    
    func requestData(id: String, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        
        let urlString = "https://openweathermap.org/img/wn/\(id)@2x.png"
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
