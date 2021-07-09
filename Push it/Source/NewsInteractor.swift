//
//  PushItInteractor.swift
//  Push it
//
//  Created by Bart on 08/07/2021.
//

import Foundation
import RxCocoa
import RxSwift

enum State {
    case initial
    case loading
    case result
    case error(Error)
}

class NewsInteractor {
        
    // ScreenType
    private let screenType: ScreenType

    // Network
    private let networkLayer = PushItNetworkLayer()

    init(screenType: ScreenType) {
        self.screenType = screenType
    }
    
    func getNews() -> Single<News> {
        
        return news()
    }
    
    private func news() -> Single<News> {
        
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
