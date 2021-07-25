//
//  NewsViewModel.swift
//  Push it
//
//  Created by Bart on 03/04/2021.
//

import Foundation
import RxCocoa
import RxSwift

protocol NewsViewModelProtocol {
    
    var stateObservable: Observable<NewsState> { get }    
    func getArticles()
    func article(for indexPath: IndexPath) -> Article?
}

class NewsViewModel: NewsViewModelProtocol {
    
    // ScreenTypes
    private let screenType: ScreenType
    
    // Articles
    private var articles: [Article] = []
    
    // Network
    private let networkLayer = PushItNetworkLayer()
    
    // State
    private var stateRelay = BehaviorRelay<NewsState>(value: NewsState(articleState: .loading))
    
    var stateObservable: Observable<NewsState> {
        return stateRelay.asObservable()
    }
    
    // Rx
    private let disposeBag = DisposeBag()
    
    init(screenType: ScreenType) {
        self.screenType = screenType
    }

    func getArticles() {
        
        getArticles()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] articles in
                
                guard let self = self else {
                    return
                }
                
                self.articles = articles
                self.stateRelay.accept(NewsState(articleState: .result(articles)))
                
            } onFailure: { [weak self] (error) in
                
                guard let self = self else {
                    return
                }
                
                self.stateRelay.accept(NewsState(articleState: .error(error)))
                
            }.disposed(by: disposeBag)
    }
    
    private func getArticles() -> Single<[Article]> {
        
        return newsForScreenType().map { news in
            
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
    
    func article(for indexPath: IndexPath) -> Article? {
        
        guard articles.count > indexPath.item else {
            return nil
        }
        
        return articles[indexPath.item]
    }
}
