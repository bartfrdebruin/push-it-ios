//
//  Networking.swift
//  PlantFinder
//
//  Created by Bart de Bruin on 26/01/2020.
//  Copyright © 2020 Bart de Bruin. All rights reserved.
//

import Foundation
import Combine
import RxSwift

protocol Networking {
    var environment: NetworkEnvironment { get set }
    var networkProvider: NetworkProvider { get set }
}


extension Networking {
    
    func request(for route: NetworkRoute) -> Single<Data> {

        return Single.create { (single) -> Disposable in
            
            let task = self.networkProvider.networkTask(for: route, in: self.environment) { (result) in
                
                switch result {
                case .failure(let error):
                    single(.failure(error))
                case .success(let response):
                    single(.success(response))
                }
            }
            
            task?.resume()
            
            return Disposables.create {
                task?.cancel()
            }
        }
    }

    func request<T: Decodable>(for route: NetworkRoute) -> Single<T> {
        
        let decoder = JSONDecoder()

        return request(for: route)
            .map { try decoder.decode(T.self, from: $0)
        }
    }
}
