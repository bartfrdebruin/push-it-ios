//
//  PushItPresenter.swift
//  Push it
//
//  Created by Bart on 08/07/2021.
//

import UIKit
import RxCocoa
import RxSwift

class NewsPresenter {
    
    // View
    weak var view: NewsViewController!
    
    // Interactor
    private let interactor: NewsInteractor
    
    // Router
    lazy var router = NewsRouter(rootViewController: view)
    
    // ScreenType
    private let screenType: ScreenType
    
    // Articles
    private(set) var articles: [Article] = []
    
    // State
    private var stateRelay = BehaviorRelay<State>(value: .loading)
    
    var stateObservable: Observable<State> {
        return stateRelay.asObservable()
    }
    
    // Rx
    private let disposeBag = DisposeBag()
    
    init(screenType: ScreenType) {
        self.screenType = screenType
        self.interactor = NewsInteractor(screenType: screenType)
    }
    
    func viewDidLoad() {
        
        getNews()
    }
    
    private func getNews() {
        
        interactor.getNews()
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
}

// MARK: - Routing
extension NewsPresenter {
    
    func routeToDetail(with article: Article) {
        
        router.routeToDetail(with: article)
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
