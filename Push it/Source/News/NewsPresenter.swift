//
//  NewsPresenter.swift
//  Push it
//
//  Created by Bart on 04/07/2021.
//

import UIKit
import RxSwift

protocol NewsPresenterProtocol {
    
    var view: NewsViewProtocol! { get }
    func getNews()
    func didSelectItem(at indexPath: IndexPath)
}

class NewsPresenter: NewsPresenterProtocol {
    
    // ScreenType
    private let screenType: ScreenType
    
    // View
    weak var view: NewsViewProtocol!

    // Articles
    private var articles: [Article] = []
    
    // Network
    private let networkLayer = PushItNetworkLayer()
    
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
                self.view.stopActivityIndicator()
                self.view.configureSnapshot(with: news.articles)
                
            } onFailure: { [weak self] (error) in
                
                guard let self = self else {
                    return
                }
                
                self.view.showError(with: error)

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

// MARK: - Did Select
extension NewsPresenter {
    
    func didSelectItem(at indexPath: IndexPath) {
        
        guard articles.count > indexPath.item else {
            return
        }
   
        view.pushDetailViewController(with: articles[indexPath.item])
    }
}

