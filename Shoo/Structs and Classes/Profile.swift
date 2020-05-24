//
//  Profile.swift
//  SwiftUISignInWithAppleAndFirebaseDemo
//
//  Created by Alex Nagy on 08/12/2019.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import Foundation

struct Profile: Identifiable {
    
    var id = UUID()
    var uid: String
    var name: String
    var reason: String
    var status: Int
    var end: Double
    var start: Double
    var house: String
}

extension Profile: DocumentSerializable {
    
    init?(documentData: [String : Any]) {
        let uid = documentData[FireKeys.Profile.uid] as? String ?? ""
        let name = documentData[FireKeys.Profile.name] as? String ?? ""
        let reason = documentData[FireKeys.Profile.reason] as? String ?? ""
        let status = documentData[FireKeys.Profile.status] as? Int ?? -1
        let end = documentData[FireKeys.Profile.end] as? Double ?? Date().timeIntervalSince1970
        let start = documentData[FireKeys.Profile.end] as? Double ?? Date().timeIntervalSince1970
        let house = documentData[FireKeys.Profile.house] as? String ?? ""
        
        self.init(uid: uid, name: name, reason: reason, status: status, end: end, start: start, house: house)
    }
    
    var toJSONSnapshot: [String: Any] {
        return [
            "id": self.id,
            "name": self.name,
            "reason": self.status,
            "end": self.end,
            "start": self.start,
            "house": self.house
        ]
    }
}


