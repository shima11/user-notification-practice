//
//  AppDelegate.swift
//  user-notification-practice
//
//  Created by Jinsei Shima on 2018/12/18.
//  Copyright © 2018 Jinsei Shima. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.

    let center = UNUserNotificationCenter.current()

    // iOS15からのNotificationのアップデート
    //  https://qiita.com/mogmet/items/7d5c2d205acc37ded4d1#3-time-sensitive%E3%81%AF%E3%81%99%E3%81%90%E3%81%AB%E6%B3%A8%E6%84%8F%E3%82%92%E6%89%95%E3%81%86%E5%BF%85%E8%A6%81%E3%81%8C%E3%81%82%E3%82%8B%E9%80%9A%E7%9F%A5

    // システムの通知画面にアプリの設定画面を開くボタンを追加して、アプリ側でそれをハンドリングして画面遷移する方法
    // https://dev.classmethod.jp/articles/user-notifications-open-inapp-settings/
    // https://developer.apple.com/documentation/usernotifications/unauthorizationoptions

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
      
    ]) { (granted, error) in

      DispatchQueue.main.async {
        // プッシュ通知を受け取るようにAPNsに登録する
        UIApplication
          .shared
          .registerForRemoteNotifications()
      }
    }

    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}
