//
//  NewsPresenter.swift
//  Push it
//
//  Created by Bart on 04/07/2021.
//

import UIKit
import RxSwift

class NewsPresenter {
    
    // View
    weak var view: NewsViewController!
    
    // Types
    private let screenType: ScreenType
    private(set) var articles: [Article] = []
    
    // Network
    private let networkLayer = PushItNetworkLayer()
    
    // Rx
    private let disposeBag = DisposeBag()
    
    init(screenType: ScreenType) {
        self.screenType = screenType
    }
    
    func getNews() {
        
        news()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] (news) in
                
                guard let self = self else {
                    return
                }
                
                self.articles = news.articles
                self.view.stopActivitiyIndicator()
                self.view.configureSnapshot()
                
            } onFailure: { [weak self] (error) in
                
                guard let self = self else {
                    return
                }
                
                self.view.showError(with: error)

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
        case .custom(let query):
            return networkLayer.custom(query: query)
        }
    }
}

// MARK: - UICollectionView
extension NewsPresenter {
    
    func didSelectItem(at indexPath: IndexPath) {
        
        guard articles.count > indexPath.item else {
            return
        }
        
        let article = articles[indexPath.item]
        let newsDetailPresenter = NewsDetailPresenter.make(with: article)
        
        guard let viewController = newsDetailPresenter.view else {
            return
        }

        view.navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - Factory
extension NewsPresenter {

    static func make(with screenType: ScreenType) -> NewsPresenter {
        
        let presenter = NewsPresenter(screenType: screenType)
        let storyboard = UIStoryboard(name: "NewsViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(
            identifier: "NewsViewController", creator: { coder in
                return NewsViewController(coder: coder, presenter: presenter)
            })
        
        presenter.view = vc
        return presenter
    }
}

