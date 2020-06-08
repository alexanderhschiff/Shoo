//
//  PushNotificationManager.swift
//  Shoo
//
//  Created by Benjamin Schiff on 5/29/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import Firebase
import FirebaseFirestore
import FirebaseMessaging
import UIKit
import UserNotifications

class PushNotificationManager: NSObject, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    //This doesn't properly register
    func registerForPushNotifications() {
        /*
         UNUserNotificationCenter.current().delegate = self
         let authOptions: UNAuthorizationOptions = [.alert, .sound]
         UNUserNotificationCenter.current().requestAuthorization(
         options: authOptions,
         completionHandler: {_, _ in })
         // For iOS 10 data message (sent via FCM)
         
         
         UIApplication.shared.registerForRemoteNotifications()
         //updateFirestorePushTokenIfNeeded()
         */
        Messaging.messaging().delegate = self
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        // updateFirestorePushTokenIfNeeded(userID: fcmToken) - shouldn't have to do anything?
        print("Updated fcmToken: \(fcmToken)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response)
    }
}
