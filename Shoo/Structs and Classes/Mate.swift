//
//  Mate.swift
//  Shoo
//
//  Created by Benjamin Schiff on 5/19/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import Foundation
import Firebase


struct Mate: Identifiable {
    var id: String
    var name: String
    var reason: String
    var status: Status
    var end: Double
    var start: Double
    var pushToken: String
}

extension Mate: DocumentSerializable {
    
    init?(documentData: [String : Any]) {
        let id = documentData[FireKeys.Mate.id] as? String ?? ""
        let name = documentData[FireKeys.Mate.name] as? String ?? ""
        let reason = documentData[FireKeys.Mate.reason] as? String ?? ""
        let status = documentData[FireKeys.Mate.status] as? Int ?? 0
        let end = documentData[FireKeys.Mate.end] as? Double ?? Date().timeIntervalSince1970
        let start = documentData[FireKeys.Mate.start] as? Double ?? Date().timeIntervalSince1970
        let pushToken = documentData[FireKeys.Mate.pushToken] as? String ?? ""
        
        self.init(id: id, name: name, reason: reason, status: Status(rawValue: status) ?? .green, end: end, start: start, pushToken: pushToken)
    }
    
    init(document: DocumentSnapshot) {
        self.id = document.documentID
        self.name = document.get("name") as? String ?? ""
        self.reason = document.get("reason") as? String ?? ""
        let tempStatus: Int = document.get("status") as? Int ?? 2
        self.status = Status(rawValue: tempStatus) ?? .yellow
        self.start = document.get("start") as? Double ?? Date().timeIntervalSince1970
        self.end = document.get("end") as? Double ?? Date().timeIntervalSince1970
        self.pushToken = document.get("pushToken") as? String ?? ""
    }
    
    var toJSONSnapshot: [String: Any] {
        return [
            "id": self.id,
            "name": self.name,
            "reason": self.status,
            "end": self.end,
            "start": self.start,
            "pushToken": self.pushToken
        ]
    }
}

struct House: Identifiable {
    var id: String
    var name: String
    var mates: [String]
}


extension House {
    
    init(document: DocumentSnapshot) {
        self.id = document.documentID
        self.name = document.get("name") as? String ?? "Home"
        self.mates = document.get("mates") as? [String] ?? []
    }
    
    var toJSONSnapshot: [String: Any] {
        return [
            "id": self.id,
            "name": self.name,
            "mates": self.mates
        ]
    }
}

