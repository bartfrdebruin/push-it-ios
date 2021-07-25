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
    func getArticles() -> Single<[Article]>
}

class NewsInteractor: NewsInteractorProtocol {
        
    // ScreenType
    var screenType: ScreenType

    // Network
    private let networkLayer = PushItNetworkLayer()

    init(screenType: ScreenType) {
        self.screenType = screenType
    }
    
    func getArticles() -> Single<[Article]> {
        
        return newsForScreenType()
            .map { news in
        
                news.articles.map {
                    
                    Article(networkArticle: $0)
                }
        }
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
