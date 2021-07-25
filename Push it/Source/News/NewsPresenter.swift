//
//  PushItPresenter.swift
//  Push it
//
//  Created by Bart on 08/07/2021.
//

import UIKit
import RxCocoa
import RxSwift

protocol NewsPresenterProtocol {
    
    var view: NewsViewProtocol? { get set }
    var router: NewsRouterProtocol? { get set }
    var interactor: NewsInteractorProtocol? { get set }

    func getArticles()
    func routeToDetail(with article: Article)
}

class NewsPresenter: NewsPresenterProtocol {
 
    // View
    weak var view: NewsViewProtocol?
    
    // Router
    var router: NewsRouterProtocol?
    
    // Interactor
    var interactor: NewsInteractorProtocol?
    
    // ScreenType
    private let screenType: ScreenType
    
    // Articles
    private var articles: [Article] = []

    // Rx
    private let disposeBag = DisposeBag()
    
    init(screenType: ScreenType) {
        self.screenType = screenType
    }

    func getArticles() {
        
        interactor?.getNews()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] (news) in
                
                guard let self = self else {
                    return
                }
                
                self.articles = news.articles
                self.view?.stopLoadingState()
                self.view?.configureSnapShot(with: news.articles)
                
            } onFailure: { [weak self] (error) in
                
                guard let self = self else {
                    return
                }
                
                self.view?.showErrorState(with: error)
                
            }.disposed(by: disposeBag)
    }
}

// MARK: - Routing
extension NewsPresenter {
    
    func routeToDetail(with article: Article) {
        
        router?.routeToDetail(with: article)
    }
}
