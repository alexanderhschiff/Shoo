//
//  AppDelegate.swift
//  Shoo
//
//  Created by Alexander Schiff on 5/14/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
        FirebaseApp.configure()
        
		return true
	}
    /*
    //MARK: - UIApplicationDelegate Methods
           @available(iOS 10.0, *)
           func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
               let userInfo = notification.request.content.userInfo
               
               
               // Print message ID.
               //    if let messageID = userInfo[gcmMessageIDKey]
               //    {
               //      print("Message ID: \(messageID)")
               //    }
               
               // Print full message.
               print(userInfo)
               
               //    let code = String.getString(message: userInfo["code"])
               guard let aps = userInfo["aps"] as? Dictionary<String, Any> else { return }
               guard let alert = aps["alert"] as? String else { return }
               //    guard let body = alert["body"] as? String else { return }
               
               completionHandler([])
           }
           
           // Handle notification messages after display notification is tapped by the user.
           
           @available(iOS 10.0, *)
           func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
               let userInfo = response.notification.request.content.userInfo
               
               print(userInfo)
               completionHandler()
           }
*/
	// MARK: UISceneSession Lifecycle

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}


}

