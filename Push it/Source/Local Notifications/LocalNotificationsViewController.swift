//
//  LocalNotificationsViewController.swift
//  Push it
//
//  Created by Bart on 02/06/2021.
//

import UIKit
import UserNotifications

class LocalNotificationsViewController: UIViewController {

    @IBOutlet private weak var notificationButton: UIButton!
    @IBOutlet private weak var notificationDelayButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationButton.layer.borderWidth = 5
        notificationButton.layer.borderColor = UIColor.black.cgColor
        notificationButton.layer.cornerRadius = 10
        notificationDelayButton.layer.borderWidth = 5
        notificationDelayButton.layer.borderColor = UIColor.black.cgColor
        notificationDelayButton.layer.cornerRadius = 10
    }
    
    @IBAction func didPressSendLocalNotificationNow(_ sender: Any) {
        
        sendLocalNotification(timeInterval: 5)
    }
    
    @IBAction func didPressSendLocalNotifactionWithDelay(_ sender: Any) {
        
        sendLocalNotification(timeInterval: 30)
    }
    
    func sendLocalNotification(timeInterval: Double) {

        let content = UNMutableNotificationContent()
        content.title = "News!"
        content.badge = 5
        content.subtitle = "Have i got news for you!"
        content.userInfo = ["newsQuery": "dogs"]
        content.categoryIdentifier = AppController.PushCategories.localBackgroundForground.rawValue
        content.sound = UNNotificationSound.default
        
        if let url = Bundle.main.url(forResource: "giphy", withExtension: "gif") {
            let attachment = try! UNNotificationAttachment(identifier: "image", url: url, options: .none)
            content.attachments = [attachment]
        }
        
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
