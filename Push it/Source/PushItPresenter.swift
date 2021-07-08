//
//  PushItPresenter.swift
//  Push it
//
//  Created by Bart on 08/07/2021.
//

import Foundation
import RxCocoa
import RxSwift

class PushItPresenter {
    
    // Interactor
    private let interactor: PushItInteractor
    
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
        self.interactor = PushItInteractor(screenType: screenType)
    }
    
    func getArticles() {
        
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
