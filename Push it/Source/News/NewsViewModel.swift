//
//  NewsViewModel.swift
//  Push it
//
//  Created by Bart on 03/04/2021.
//

import Foundation
import RxSwift

enum State {
    case initial
    case loading
    case result
    case error(Error)
}

class NewsViewModel {
    
    private let screenType: ScreenType
    private(set) var articles: [Article] = []
    private let networkLayer = PushItNetworkLayer()
    private let disposeBag = DisposeBag()
    
    init(screenType: ScreenType) {
        self.screenType = screenType
    }

    private(set) var state: State = .initial {
        didSet {
            refreshState()
        }
    }
    
    var refreshState: () -> Void = {}
    
    func getNews() {
        
        news()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] (news) in
                
                guard let self = self else {
                    return
                }
                
                self.articles = news.articles
                self.state = .result
                
            } onFailure: { [weak self] (error) in
                
                guard let self = self else {
                    return
                }
                
                self.state = .error(error)
                
            }.disposed(by: disposeBag)
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
        }
    }
    
    func numberOfArticles() -> Int {
        
        return articles.count
    }
    
    func article(at indexPath: IndexPath) -> Article? {
        
        guard indexPath.item < articles.count else {
            return nil
        }
        
        return articles[indexPath.item]
    }
}
