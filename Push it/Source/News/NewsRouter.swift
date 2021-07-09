//
//  PushItRouter.swift
//  Push it
//
//  Created by Bart on 08/07/2021.
//

import UIKit

class NewsRouter {
    
    // Root
    let rootViewController: UIViewController
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    func routeToDetail(with article: Article) {
        
        let presenter = NewsDetailPresenter.make(with: article)
        rootViewController.navigationController?.pushViewController(presenter.view, animated: true)
    }
}
