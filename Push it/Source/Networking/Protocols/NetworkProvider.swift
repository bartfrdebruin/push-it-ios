//
//  NetworkRequestProvider.swift
//  PlantFinder
//
//  Created by Bart de Bruin on 23/01/2020.
//  Copyright © 2020 Bart de Bruin. All rights reserved.
//

import Foundation

protocol NetworkProvider {
    
    func networkTask(for route: NetworkRoute,
                 in environment: NetworkEnvironment,
                 completion: @escaping (Result<Data, NetworkError>) -> Void) -> NetworkTask?
    
}

class NetworkTaskProvider: NetworkProvider {
    
    /// Create a session object
    private let session = URLSession(configuration: .default)
    
    func networkTask(for route: NetworkRoute, in environment: NetworkEnvironment,
                     completion: @escaping (Result<Data, NetworkError>) -> Void) -> NetworkTask? {

        var task: NetworkTask?
        
        do {
            
            let request = try route.createURLRequest(withEnvironment: environment)
            
            if route.method == .POST, let data = route.body {
                
                return uploadTask(for: request, data: data, completion: completion)
            }

            
            let urlSessionTask = session.dataTask(with: request) { (data, response, error) in

                if let error = error {
                    
                    completion(.failure(NetworkError.unknownError(error)))
                    
                } else if let response = response, !response.validate() {
                    
                    let statusError = NetworkStatusError(code: response.getStatusCode(), data: data)
                    completion(.failure(NetworkError.unexpectedStatus(statusError)))
                    
                } else if let data = data {
                    
                    completion(.success(data))
                    
                } else {
                    
                    completion(.failure(NetworkError.invalidRequest))
                }
            }
            
            task = URLSessionNetworkTask(task: urlSessionTask)
            
        } catch let error {
            
             completion(.failure(NetworkError.unknownError(error)))
        }

        return task
    }
    
    private func uploadTask(for urlRequest: URLRequest, data: Data,
                            completion: @escaping (Result<Data, NetworkError>) -> Void) -> NetworkTask? {
        
        var task: NetworkTask?
        
        let urlSessionTask = session.uploadTask(with: urlRequest, from: data) { (data, response, error) in
               
            if let error = error {
                
                completion(.failure(NetworkError.unknownError(error)))
                
            } else if let response = response, !response.validate() {
                
                let statusError = NetworkStatusError(code: response.getStatusCode(), data: data)
                completion(.failure(NetworkError.unexpectedStatus(statusError)))
                
            } else if let data = data {
                
                completion(.success(data))
                
            } else {
                
                completion(.failure(NetworkError.invalidRequest))
            }
        }
        
        task = URLSessionNetworkTask(task: urlSessionTask)
                
        return task
    }
}
