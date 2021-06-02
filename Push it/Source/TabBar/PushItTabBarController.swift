//
//  TabbarController.swift
//  Push it
//
//  Created by Bart on 25/05/2021.
//

import UIKit

enum ScreenType: String, CaseIterable {
    case headlines = "Recent"
    case domestic = "Binnenland"
    case foreign = "Buitenland"
    case sport = "Sport"
}

class PushItTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
    
    func configure() {

        var viewControllers = ScreenType.allCases.compactMap { (type) -> UIViewController in
            let viewController = NewsViewController.make(with: type)
            viewController.title = type.rawValue
            let navigationController = UINavigationController(rootViewController: viewController)
            return navigationController
        }
        
        let localNotificationsViewControler = LocalNotificationsViewController.make()
        localNotificationsViewControler.title = "Notifications"
        
        viewControllers.append(localNotificationsViewControler)

        setViewControllers(viewControllers, animated: true)
        
        tabBar.tintColor = .black
        UINavigationBar.appearance().backItem?.title = ""
    }
}
