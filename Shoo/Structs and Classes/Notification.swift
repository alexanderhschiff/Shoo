//
//  Notification.swift
//  Shoo
//
//  Created by Benjamin Schiff on 6/7/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import Foundation

let inBetweenWaitingPeriod: Double = 30 //Can't send for 30 seconds

struct NotificationStruct {
    let status: Status?
    let reason: String?
    let endTime: Double?
    let sendTime: Double?
    
    //will return true if the other notification is different or sent more than 30 seconds later
    func check(canSend other: NotificationStruct) -> Bool {
        if let mySendTime = sendTime {
            if status == other.status && reason == other.reason && endTime == other.endTime {
                let timeDiff = (other.sendTime ?? Date().timeIntervalSince1970) - mySendTime
                print("checkSend: Time > 30: \(timeDiff > inBetweenWaitingPeriod)")
                return timeDiff > inBetweenWaitingPeriod
            } else {
                print("checkSend: different notification")
                return true
            }
        }
        print("checkSend: No first notification")
        return true
    }
}


