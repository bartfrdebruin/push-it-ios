//
//  AppDelegate.swift
//  Push it
//
//  Created by Bart de Bruin on 17/03/2021.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var viewController: UIViewController?
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        registerForPushNotifications()
        getNotificationSettings()
        
        UNUserNotificationCenter.current().delegate = self
        
        // Check if launched from notification
        let notificationOption = launchOptions?[.remoteNotification]
        
        if let notification = notificationOption as? [String: AnyObject],
           let aps = notification["aps"] as? [String: AnyObject] {
            
            print("APS didFinishLaunchingWithOptions:", aps)
        }
        
        UINavigationBar.appearance().backItem?.backButtonDisplayMode = .minimal
        UINavigationBar.appearance().tintColor = .black
      
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = PushItTabBarController()
        window?.makeKeyAndVisible()
        
        
        return true
    }
}

// MARK: - Push
extension AppDelegate {
    
    func registerForPushNotifications() {
        
        UNUserNotificationCenter
            .current()
            .requestAuthorization(
                options: [.alert, .sound, .badge]) { [weak self] granted, _ in
                
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
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        
        print("PUSH: Device Token: \(token)")
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("PUSH: Failed to register: \(error)")
    }
}

// MARK: - didReceive
extension AppDelegate {
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler:
            @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("PUSH: didReceiveRemoteNotification", userInfo)
        
        guard let aps = userInfo["aps"] as? [String: AnyObject] else {
            completionHandler(.failed)
            return
        }
        
        print("APS didReceiveRemoteNotification", aps)
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        print("userNotificationCenter didReceive response:", userInfo)
        
        if let aps = userInfo["aps"] as? [String: AnyObject] {
            print("APS didReceive response:", aps)
        }
        
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

