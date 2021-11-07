//
//  AppDelegate.swift
//  user-notification-practice
//
//  Created by Jinsei Shima on 2018/12/18.
//  Copyright © 2018 Jinsei Shima. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.

    UNUserNotificationCenter.current().delegate = self

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

extension AppDelegate: UNUserNotificationCenterDelegate {
  
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    print("notification foreground")

    // フォアグラウンドの場合でも通知を表示する
    if #available(iOS 14.0, *) {
      completionHandler([.alert, .badge, .sound, .banner])
    } else {
      completionHandler([.alert, .badge, .sound])
    }
  }


  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {

    print("notification did recieve")

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

    // 通知の ID を取得
    print("notification.request.identifier: \(response.notification.request.identifier)")

    completionHandler()
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
    print("open settings notification:\(notification)")
    // 通知設定画面への遷移を実装

  }

}
