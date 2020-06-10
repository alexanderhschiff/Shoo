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
    
    func check(canSend other: NotificationStruct) -> Bool {
        if sendTime != nil {
            if status == other.status && reason == other.reason && endTime == other.endTime {
                if let sendTime = sendTime {
                    let timeDiff = (other.sendTime ?? Date().timeIntervalSince1970) - (sendTime)
                    return timeDiff > inBetweenWaitingPeriod
                } else {
                    return true
                }
            } else {
                return true
            }
        }
        return true
    }
}


