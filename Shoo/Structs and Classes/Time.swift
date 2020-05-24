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
