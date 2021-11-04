//
//  ViewController.swift
//  user-notification-practice
//
//  Created by Jinsei Shima on 2018/12/18.
//  Copyright © 2018 Jinsei Shima. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

  @IBAction func didTapButton(_ sender: Any) {

    let content = UNMutableNotificationContent()
    content.title = "Introduction to Notifications"
    content.subtitle = "hogehogheohgeohge"
    content.body = "Let's talk about notifications!"

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 4, repeats: false)

    let requestIdentifier = "sampleRequest"
    let request = UNNotificationRequest(
      identifier: requestIdentifier,
      content: content,
      trigger: trigger
    )

    let center = UNUserNotificationCenter.current()

    center.add(request) { (error) in
      if let error = error {
        print("error:", error)
      }
    }

    center.getPendingNotificationRequests { (requests) in
      print("==========Pending Notification============")
      print(requests)
    }
    center.getDeliveredNotifications { (notifications) in
      print("==========Delivered Notifications============")
      print(notifications)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    UNUserNotificationCenter.current().delegate = self
  }

  // フォアグラウンドの場合でも通知を表示する
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    print("notification foreground")
    completionHandler([.alert, .badge, .sound])
  }


  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    
    print("notification background")

    let trigger = response.notification.request.trigger

    switch trigger {
    case is UNPushNotificationTrigger:
      print("UNPushNotificationTrigger")
    case is UNTimeIntervalNotificationTrigger:
      print("UNTimeIntervalNotificationTrigger")
    case is UNCalendarNotificationTrigger:
      print("UNCalendarNotificationTrigger")
    case is UNLocationNotificationTrigger:
      print("UNLocationNotificationTrigger")
    default:
      break
    }

    completionHandler()
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
    print("open settings notification:\(notification)")
    // 通知設定画面への遷移を実装

  }

}

