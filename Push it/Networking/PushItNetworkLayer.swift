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
    
    func headlines() -> Single<NetworkNews> {
        
        let route = PushItNetworkRoute.headlines
        return request(for: route)
    }

    func domesticNews() -> Single<NetworkNews> {
        
        let route = PushItNetworkRoute.domestic
        return request(for: route)
    }
    
    func foreignNews() -> Single<NetworkNews> {
        
        let route = PushItNetworkRoute.foreign
        return request(for: route)
    }
    
    func sports() -> Single<NetworkNews> {
        
        let route = PushItNetworkRoute.sports
        return request(for: route)
    }
    
    func custom(query: String) -> Single<NetworkNews> {
        
        let route = PushItNetworkRoute.custom(query)
        return request(for: route)
    }
}
