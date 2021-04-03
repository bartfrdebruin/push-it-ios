//
//  Networking.swift
//  PlantFinder
//
//  Created by Bart de Bruin on 26/01/2020.
//  Copyright © 2020 Bart de Bruin. All rights reserved.
//

import Foundation
import Combine

protocol Networking {
    var environment: NetworkEnvironment { get set }
    var networkProvider: NetworkProvider { get set }
}

extension Networking {
    
    func requestData(for route: NetworkRoute) -> AnyPublisher<Data, Error> {
        
        var networkTask: NetworkTask?
        
        return Future<Data, Error> { promise in
            
            let task = self.networkProvider.networkTask(for: route, in: self.environment) { (result) in
                
                switch result {
                case .failure(let error):
                    return promise(.failure(error))
                case .success(let data):
                    return promise(.success(data))
                }
                
            }
            
            task?.resume()
            networkTask = task
            

        }.handleEvents(receiveCancel: {
            
            networkTask?.cancel()
            
        }).eraseToAnyPublisher()
    }
     
     func request<T:Decodable>(for route: NetworkRoute) -> AnyPublisher<T, Error> {
        return requestData(for: route)
             .decode(type: T.self, decoder: JSONDecoder()).eraseToAnyPublisher()
     }
}
