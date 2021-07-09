//
//  TabbarController.swift
//  Push it
//
//  Created by Bart on 25/05/2021.
//

import UIKit

enum ScreenType {
    case headlines
    case domestic
    case foreign
    case sport
    case custom(String)
    
    static var allCases: [ScreenType] {
        return [.headlines, .domestic, .foreign, .sport]
    }
    
    func title() -> String {
        switch self {
        case .headlines:
            return "Recent"
        case .domestic:
            return "Binnenland"
        case .foreign:
            return "Buitenland"
        case .sport:
            return "Sport"
        case .custom(let query):
            return query
        }
    }
}

class PushItTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
    
    func configure() {

        var viewControllers = ScreenType.allCases.compactMap { (type) -> UIViewController? in
            let presenter = NewsPresenter.make(with: type)
            let viewController = presenter.view
            viewController?.title = type.title()
            let navigationController = UINavigationController(rootViewController: viewController!)
            return navigationController
        }
        
        let localNotificationsViewControler = LocalNotificationsViewController.make()
        localNotificationsViewControler.title = "Notifications"
        
        viewControllers.append(localNotificationsViewControler)

        setViewControllers(viewControllers, animated: true)
        
        tabBar.tintColor = .black
        UINavigationBar.appearance().backItem?.title = ""
    }
    
    func presentCustomNews(with query: String) {
        
        let presenter = NewsPresenter.make(with: .custom(query))
        let viewController = presenter.view
        viewController?.title = query
        let navigationController = UINavigationController(rootViewController: viewController!)
        navigationController.modalPresentationStyle = .automatic
        present(navigationController, animated: true, completion: nil)
    }
}
