//
//  PushItInteractor.swift
//  Push it
//
//  Created by Bart on 08/07/2021.
//

import Foundation
import RxCocoa
import RxSwift

protocol NewsInteractorProtocol {
    
    var screenType: ScreenType { get set }
    func getNews() -> Single<NetworkNews>
}

class NewsInteractor: NewsInteractorProtocol {
        
    // ScreenType
    var screenType: ScreenType

    // Network
    private let networkLayer = PushItNetworkLayer()

    init(screenType: ScreenType) {
        self.screenType = screenType
    }
    
    func getNews() -> Single<NetworkNews> {
        
        return newsForScreenType()
    }
    
    private func newsForScreenType() -> Single<NetworkNews> {
        
        switch screenType {
        case .headlines:
            return networkLayer.headlines()
        case .domestic:
            return networkLayer.domesticNews()
        case .foreign:
            return networkLayer.foreignNews()
        case .sport:
            return networkLayer.headlines()
        case .custom(let query):
            return networkLayer.custom(query: query)
        }
    }
}
