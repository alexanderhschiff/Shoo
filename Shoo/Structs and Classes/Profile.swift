//
//  Profile.swift
//  SwiftUISignInWithAppleAndFirebaseDemo
//
//  Created by Alex Nagy on 08/12/2019.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import Foundation

struct Profile: Identifiable {
    
    let id = UUID()
    let uid: String
    let name: String
    let reason: String
    let status: Int
    let end: Date
    let start: Date
    var house: String
}

extension Profile: DocumentSerializable {
    
    init?(documentData: [String : Any]) {
        let uid = documentData[FireKeys.Profile.uid] as? String ?? ""
        let name = documentData[FireKeys.Profile.name] as? String ?? ""
        let reason = documentData[FireKeys.Profile.reason] as? String ?? ""
        let status = documentData[FireKeys.Profile.status] as? Int ?? 0
        let end = documentData[FireKeys.Profile.end] as? Date ?? Date()
        let start = documentData[FireKeys.Profile.end] as? Date ?? Date()
        let house = documentData[FireKeys.Profile.house] as? String ?? "testHouse"
        
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


