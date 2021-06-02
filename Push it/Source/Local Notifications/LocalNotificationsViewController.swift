//
//  LocalNotificationsViewController.swift
//  Push it
//
//  Created by Bart on 02/06/2021.
//

import UIKit
import UserNotifications

class LocalNotificationsViewController: UIViewController {

    @IBAction func didPressSendLocalNotificationNow(_ sender: Any) {
        
        sendLocalNotification(timeInterval: 5)
    }
    
    @IBAction func didPressSendLocalNotifactionWithDelay(_ sender: Any) {
        
        sendLocalNotification(timeInterval: 30)
    }
    
    func sendLocalNotification(timeInterval: Double) {
        
        let content = UNMutableNotificationContent()
        content.title = "Feed the cat"
        content.subtitle = "It looks hungry"
        content.sound = UNNotificationSound.default

        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
}

// MARK: - Factory
extension LocalNotificationsViewController {
    
    static func make() -> LocalNotificationsViewController {
        
        let storyboard = UIStoryboard(name: "LocationNotificationsViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(
            identifier: "LocationNotificationsViewController", creator: { coder in
                return LocalNotificationsViewController(coder: coder)
            })
        
        return vc
    }
}
