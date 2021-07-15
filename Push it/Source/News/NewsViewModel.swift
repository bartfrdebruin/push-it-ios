//
//  NewsViewModel.swift
//  Push it
//
//  Created by Bart on 03/04/2021.
//

import Foundation
import RxCocoa
import RxSwift

enum State {
    case loading
    case result
    case error(Error)
}

protocol NewsViewModelProtocol {
    
    var articles: [Article] { get }
    var stateObservable: Observable<State> { get }
    
    func getNews() 
}

class NewsViewModel: NewsViewModelProtocol {
    
    // ScreenTypes
    private let screenType: ScreenType
    
    // Articles
    private(set) var articles: [Article] = []
    
    // Network
    private let networkLayer = PushItNetworkLayer()
    
    // State
    private var stateRelay = BehaviorRelay<State>(value: .loading)
    
    var stateObservable: Observable<State> {
        return stateRelay.asObservable()
    }
    
    // Rx
    private let disposeBag = DisposeBag()
    
    init(screenType: ScreenType) {
        self.screenType = screenType
    }

    func getNews() {
        
        newsForScreenType()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] (news) in
                
                guard let self = self else {
                    return
                }
                
                self.articles = news.articles
                self.stateRelay.accept(.result)
                
            } onFailure: { [weak self] (error) in
                
                guard let self = self else {
                    return
                }
                
                self.stateRelay.accept(.error(error))
                
            }.disposed(by: disposeBag)
    }
    
    private func newsForScreenType() -> Single<News> {
        
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
