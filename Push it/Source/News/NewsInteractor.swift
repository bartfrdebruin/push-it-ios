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
                    
                    Article(sourceName: $0.source.name,
                            author: $0.author,
                            title: $0.title,
                            description: $0.description,
                            url: $0.url,
                            urlToImage: $0.urlToImage,
                            publishedAt: $0.publishedAt,
                            content: $0.content)
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
