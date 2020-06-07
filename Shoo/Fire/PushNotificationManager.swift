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
    //let userID: String
    /*
     init(userID: String) {
     self.userID = userID
     super.init()
     }
     */
    
    /*
     init() {
     //self.userID = ""
     super.init()
     }
     */
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        // For iOS 10 data message (sent via FCM)
        Messaging.messaging().delegate = self
        
        UIApplication.shared.registerForRemoteNotifications()
        //updateFirestorePushTokenIfNeeded()
    }
    
    /* - code moved to fire
     func updateFirestorePushTokenIfNeeded(userID: String) {
     if let token = Messaging.messaging().fcmToken {
     let usersRef = Firestore.firestore().collection("profiles").document(userID)
     usersRef.setData(["pushToken": token], merge: true)
     }
     }
     */
    
    /* depreciated
     func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
     print(remoteMessage.appData) // or do whatever
     }
     */
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        // updateFirestorePushTokenIfNeeded(userID: fcmToken) - shouldn't have to do anything?
        print("fcmToken: \(fcmToken)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response)
    }
}
