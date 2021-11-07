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

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
    
    let request = UNNotificationRequest(
      identifier: "sampleRequest",
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


  private var settings: UNNotificationSettings? = nil

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "user notification practice"
    navigationItem.largeTitleDisplayMode = .always
    navigationController?.navigationBar.prefersLargeTitles = true

    let center = UNUserNotificationCenter.current()

    // iOS15からのNotificationのアップデート
    //  https://qiita.com/mogmet/items/7d5c2d205acc37ded4d1#3-time-sensitive%E3%81%AF%E3%81%99%E3%81%90%E3%81%AB%E6%B3%A8%E6%84%8F%E3%82%92%E6%89%95%E3%81%86%E5%BF%85%E8%A6%81%E3%81%8C%E3%81%82%E3%82%8B%E9%80%9A%E7%9F%A5

    // システムの通知画面にアプリの設定画面を開くボタンを追加して、アプリ側でそれをハンドリングして画面遷移する方法
    // https://dev.classmethod.jp/articles/user-notifications-open-inapp-settings/
    // https://developer.apple.com/documentation/usernotifications/unauthorizationoptions

    // 通知の許可をリクエスト
    center.requestAuthorization(options: [
      .alert,
      .sound,
      .badge,
      .providesAppNotificationSettings,
      .provisional,
      .criticalAlert,
      .carPlay,
//      .announcement,
//      .timeSensitive,

    ]) { [weak self] (granted, error) in

      if granted {
        print("許可する")
      } else {
        print("許可しない")
      }

      self?.fetchNotificationSettings()

      DispatchQueue.main.async {
        // プッシュ通知を受け取るようにAPNsに登録する
        UIApplication.shared.registerForRemoteNotifications()
      }
    }

    fetchNotificationSettings()

    center.delegate = self
  }

  func fetchNotificationSettings() {
    UNUserNotificationCenter.current().getNotificationSettings { settings in
      self.settings = settings
      print(
        "notification settings:\n",
        "authorizationStatus:", settings.authorizationStatus.rawValue, "\n",
        "soundSetting:", settings.soundSetting.rawValue, "\n",
        "badgeSetting:", settings.badgeSetting.rawValue, "\n",
        "alertSetting:", settings.alertSetting.rawValue, "\n",
        "notificationCenterSetting:", settings.notificationCenterSetting.rawValue, "\n",
        "lockScreenSetting:", settings.lockScreenSetting.rawValue, "\n",
        "carPlaySetting:", settings.carPlaySetting.rawValue, "\n",
        "alertStyle:", settings.alertStyle.rawValue, "\n",
        "showPreviewsSetting:", settings.showPreviewsSetting.rawValue, "\n",
        "criticalAlertSetting:", settings.criticalAlertSetting.rawValue, "\n",
        "providesAppNotificationSettings:", settings.providesAppNotificationSettings, "\n",
        "announcementSettin:", settings.announcementSetting.rawValue
//        settings.timeSensitiveSetting,
//        settings.scheduledDeliverySetting,
//        settings.directMessagesSetting
      )
    }
  }

  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    print("notification foreground")

    // フォアグラウンドの場合でも通知を表示する
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

