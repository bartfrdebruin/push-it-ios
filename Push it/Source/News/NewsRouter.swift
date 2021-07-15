//
//  PushItRouter.swift
//  Push it
//
//  Created by Bart on 08/07/2021.
//

import UIKit

protocol NewsRouterProtocol {
    
    func createNewsModule(with screenType: ScreenType) -> UIViewController
    func routeToDetail(with article: Article)
}

class NewsRouter: NewsRouterProtocol {
    
    private var rootViewController: UIViewController?

    func createNewsModule(with screenType: ScreenType) -> UIViewController {
        
        let presenter = NewsPresenter(screenType: screenType)
        let viewController = NewsViewController.make(with: presenter)
        presenter.interactor = NewsInteractor(screenType: screenType)
        presenter.view = viewController
        presenter.router = self
        
        self.rootViewController = viewController
        return viewController
    }
    
    func routeToDetail(with article: Article) {
        
        let presenter = NewsDetailPresenter(article: article)
        let viewController = NewsDetailViewController.make(with: presenter)
        presenter.view = viewController
        rootViewController?.navigationController?.pushViewController(viewController, animated: true)
    }
}
