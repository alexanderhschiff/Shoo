//
//  PushNotificationSender.swift
//  Shoo
//
//  Created by Benjamin Schiff on 6/6/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import Foundation
import UIKit

class PushNotificationSender {
    let serverKey = "AAAAVWpgxuM:APA91bGfT1I0tCaKPY5XVnBoitNxukdfGb4pxtr4MrBd2-ItVfwx_f9Jf9m7AqOc9E93CLbtj4Dh_xD8pkJUKzNWAMn4DCRIAT4wRjO3-5pXETTgA6MjOotCnnyfK2wlEcDFr5QtiYSc"
    
    func sendPushNotification(to token: String, title: String, body: String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : token,
                                           "notification" : ["title" : title, "body" : body],
                                           "data" : ["user" : "test_id"]
        ]
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}
