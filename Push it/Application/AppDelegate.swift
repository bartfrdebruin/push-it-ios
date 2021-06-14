//
//  AppDelegate.swift
//  Push it
//
//  Created by Bart de Bruin on 17/03/2021.
//

import UIKit
import UserNotifications
import os.log
import Firebase
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let appController = AppController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()
        appController.startApp()
        
        return true
    }
}
//
//extension AppDelegate: MessagingDelegate {
//    
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        
//        let tokenDict = ["token": fcmToken ?? ""]
//        NotificationCenter.default.post(
//            name: Notification.Name("FCMToken"),
//            object: nil,
//            userInfo: tokenDict)
//        
//        print("FCMToken: ", fcmToken)
//    }
//}

// MARK: - Push
extension AppDelegate {

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        appController.didReceivePushToken(deviceToken: deviceToken)
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
    
        appController.didFailToRegisterForPushNotifications(error: error)
    }
}

// MARK: - didReceive
extension AppDelegate {
 
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler:
            @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("Push didReceiveRemoteNotification")
        OSLog.logMsg("Application didReceiveRemoteNotification", osLog: .backgroundForgroundLog)

        appController.appDidReceiveMessage(userInfo)
        completionHandler(.newData)
    }
}
