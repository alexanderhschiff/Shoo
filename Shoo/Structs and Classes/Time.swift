//
//  Time.swift
//  Shoo
//
//  Created by Benjamin Schiff on 5/23/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import Foundation

func getCountdownTime(from eventTime: Double) -> Double {
    let secondsUntilEvent = eventTime - Date().timeIntervalSince1970
    return secondsUntilEvent
}

class Time: ObservableObject {
    @Published var end: Double
    
    init(_ sliderInt: Int) {
        switch sliderInt{
        case 0:
            end = Date().timeIntervalSince1970 + 10*60 //10 minutes
        case 1:
            end = Date().timeIntervalSince1970 + 15*60 //15 minutes
        case 2:
            end = Date().timeIntervalSince1970 + 20*60 //20 minutes
        case 3:
            end = Date().timeIntervalSince1970 + 30*60 //30 minutes
        case 4:
            end = Date().timeIntervalSince1970 + 45*60 //45 minutes
        case 5:
            end = Date().timeIntervalSince1970 + 60*60//1 hour
        case 6:
            end = Date().timeIntervalSince1970 + 120*60 //2 hours
        case 7:
            end = Date().timeIntervalSince1970 + 180*60 //3 hours
        case 8:
            end = Date().timeIntervalSince1970 + 240*60 //4 hours
        case 9:
            end = Date().timeIntervalSince1970 + 360*60 //6 hours (a while)
        case 10:
            end = Date.distantFuture.timeIntervalSince1970
        default:
            end = 75
        }
    }
}
