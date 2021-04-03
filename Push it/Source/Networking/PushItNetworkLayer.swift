//
//  PushItNetworkLayer.swift
//  Push it
//
//  Created by Bart on 03/04/2021.
//

import Foundation
import Combine

final class PushItNetworkLayer: Networking {
    
    internal var environment: NetworkEnvironment
    internal var networkProvider: NetworkProvider
    
    init(environment: NetworkEnvironment = PushItNetworkEnvironment(),
         networkProvider: NetworkProvider = NetworkTaskProvider()) {
        self.environment = environment
        self.networkProvider = networkProvider
    }
    
    func allNews() -> AnyPublisher<News, Error> {
        
        let route = PushItNetworkRoute.everything
        return request(for: route)
    }
}
