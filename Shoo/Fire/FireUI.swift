//
//  FireUI.swift
//  Shoo
//
//  Created by Benjamin Schiff on 5/17/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import Foundation
import SwiftUI

struct AlertInfo {
    var isPresented: Bool
    var title: String
    var message: String
    var actionText: String
    var actionTag: Int
}

struct ActivityIndicatorInfo {
    var isPresented: Bool
    var message: String
}

struct FireUIDefault {
    static let alertInfo = AlertInfo(isPresented: false, title: "", message: "", actionText: "", actionTag: 0)
    static let activityIndicatorInfo = ActivityIndicatorInfo(isPresented: false, message: "Working...")
}

