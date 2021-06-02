//
//  PushItNetworkLayer.swift
//  Push it
//
//  Created by Bart on 03/04/2021.
//

import Foundation
import RxSwift

final class PushItNetworkLayer: Networking {
    
    internal var environment: NetworkEnvironment
    internal var networkProvider: NetworkProvider
    
    init(environment: NetworkEnvironment = PushItNetworkEnvironment(),
         networkProvider: NetworkProvider = NetworkTaskProvider()) {
        self.environment = environment
        self.networkProvider = networkProvider
    }
    
    func headlines() -> Single<News> {
        
        let route = PushItNetworkRoute.headlines
        return request(for: route)
    }

    func domesticNews() -> Single<News> {
        
        let route = PushItNetworkRoute.domestic
        return request(for: route)
    }
    
    func foreignNews() -> Single<News> {
        
        let route = PushItNetworkRoute.foreign
        return request(for: route)
    }
    
    
    func sports() -> Single<News> {
        
        let route = PushItNetworkRoute.sports
        return request(for: route)
    }
}
