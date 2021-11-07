//
//  ViewController.swift
//  user-notification-practice
//
//  Created by Jinsei Shima on 2018/12/18.
//  Copyright © 2018 Jinsei Shima. All rights reserved.
//

import UIKit
import UserNotifications

// https://www.raywenderlich.com/21458686-local-notifications-getting-started

class ViewController: UIViewController {

  @IBAction func didTapButton(_ sender: Any) {

    let content = UNMutableNotificationContent()
    content.title = "Introduction to Notifications"
    content.subtitle = "hogehogheohgeohge"
    content.body = "Let's talk about notifications!"
    if #available(iOS 15.0, *) {
      content.interruptionLevel = .timeSensitive
    }

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
    
    let request = UNNotificationRequest(
      identifier: "sampleRequest",
      content: content,
      trigger: trigger
    )

    UNUserNotificationCenter.current().add(request) { (error) in
      if let error = error {
        print("error:", error)
      }
    }

    UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
      print("==========Pending Notification============")
      print(requests)
    }
    UNUserNotificationCenter.current().getDeliveredNotifications { (notifications) in
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

    // iOS15からのNotificationのアップデート
    //  https://qiita.com/mogmet/items/7d5c2d205acc37ded4d1#3-time-sensitive%E3%81%AF%E3%81%99%E3%81%90%E3%81%AB%E6%B3%A8%E6%84%8F%E3%82%92%E6%89%95%E3%81%86%E5%BF%85%E8%A6%81%E3%81%8C%E3%81%82%E3%82%8B%E9%80%9A%E7%9F%A5

    // システムの通知画面にアプリの設定画面を開くボタンを追加して、アプリ側でそれをハンドリングして画面遷移する方法
    // https://dev.classmethod.jp/articles/user-notifications-open-inapp-settings/
    // https://developer.apple.com/documentation/usernotifications/unauthorizationoptions

    // 通知の許可をリクエスト
    UNUserNotificationCenter.current().requestAuthorization(options: [
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
        print("許可")
      } else {
        print("未許可")
      }

      self?.fetchNotificationSettings()

      DispatchQueue.main.async {
        // プッシュ通知を受け取るようにAPNsに登録する
        UIApplication.shared.registerForRemoteNotifications()
      }
    }

    fetchNotificationSettings()
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

}

