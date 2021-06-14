//
//  AppController.swift
//  Push it
//
//  Created by Bart on 25/05/2021.
//

import UIKit
import UserNotifications
import OSLog

class AppController: NSObject {
    
    enum PushCategories: String {
        case background
        case backgroundForground
        case localBackgroundForground
    }
    
    /// Main UI
    let tabBarController = PushItTabBarController()
    
    /// Application window
    private lazy var window = {
        UIWindow(frame: UIScreen.main.bounds)
    }()
    
    override init() {
        super.init()
        
        UNUserNotificationCenter.current().delegate = self
        
        registerNotificationCategories()
        registerForPushNotifications()
        getNotificationSettings()

        UINavigationBar.appearance().backItem?.backButtonDisplayMode = .minimal
        UINavigationBar.appearance().tintColor = .black
    }
    
    func startApp() {
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}

// MARK: - Push
extension AppController {
    
    private func registerNotificationCategories() {
        
        let newsAction = UNNotificationAction(identifier: UNNotificationDefaultActionIdentifier,
                                                  title: "Show me the news!",
                                                  options: UNNotificationActionOptions.foreground)
        
        let newsCategory = UNNotificationCategory(identifier: PushCategories.localBackgroundForground.rawValue,
                                                   actions: [newsAction],
                                                   intentIdentifiers: [],
                                                   hiddenPreviewsBodyPlaceholder: "",
                                                   options: .customDismissAction)
        
        let bearsNewsAction = UNNotificationAction(identifier: UNNotificationDefaultActionIdentifier,
                                                  title: "Show me the bears!",
                                                  options: UNNotificationActionOptions.foreground)
        
        let bearsCategory = UNNotificationCategory(identifier: PushCategories.backgroundForground.rawValue,
                                                   actions: [bearsNewsAction],
                                                   intentIdentifiers: [],
                                                   hiddenPreviewsBodyPlaceholder: "",
                                                   options: .customDismissAction)
        
        let catsNewsAction = UNNotificationAction(identifier: UNNotificationDefaultActionIdentifier,
                                                  title: "Show me the cats!",
                                                  options: UNNotificationActionOptions.foreground)
        
        let catsCategory = UNNotificationCategory(identifier: PushCategories.background.rawValue,
                                                   actions: [catsNewsAction],
                                                   intentIdentifiers: [],
                                                   hiddenPreviewsBodyPlaceholder: "",
                                                   options: .customDismissAction)
        
        UNUserNotificationCenter.current().setNotificationCategories([bearsCategory, catsCategory, newsCategory])
    }

    func registerForPushNotifications() {
        
        UNUserNotificationCenter
            .current()
            .requestAuthorization(
                options: [.alert, .sound, .badge, .announcement]) { [weak self] granted, _ in
                
                print("Permission granted: \(granted)")
                
                guard granted else {
                    return
                }
    
                self?.getNotificationSettings()
            }
    }
    
    func getNotificationSettings() {
        
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            
            print("Notification settings: \(settings)")
            
            guard settings.authorizationStatus == .authorized else {
                return
            }
            
            DispatchQueue.main.async {
                
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func didReceivePushToken(deviceToken: Data) {
        
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        
        print("PUSH: Did receive push token: \(token)")
    }
    
    func didFailToRegisterForPushNotifications(error: Error) {
        
        print("PUSH: Failed to register: \(error)")
    }
    
    func appDidReceiveMessage(_ message: [AnyHashable: Any]) {

        print("PUSH didReceiveRemoteNotification", message)

        if let query = message["newsQuery"] as? String {
            tabBarController.presentCustomNews(with: query)
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        if notification.request.content.categoryIdentifier == PushCategories.background.rawValue {
            
            completionHandler([.sound, .badge])
        }
        
        if notification.request.content.categoryIdentifier == PushCategories.backgroundForground.rawValue {
            
            completionHandler([.sound, .banner, .list, .badge])
        }
        
        if notification.request.content.categoryIdentifier == PushCategories.localBackgroundForground.rawValue {
            
            completionHandler([.sound, .banner, .list, .badge])
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
                
        appDidReceiveMessage(response.notification.request.content.userInfo)
        completionHandler()
    }
    
    private func getMediaAttachment(
        for urlString: String,
        completion: @escaping (UIImage?) -> Void
    ) {
        // 1
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let data = try? Data(contentsOf: url)
        
        guard let unwrappedData = data,
              let image = UIImage(data: unwrappedData) else {
            return
        }

        completion(image)
    }
}
