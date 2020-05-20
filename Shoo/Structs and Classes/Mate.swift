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
    var status: Int
    var end: Date
    var start: Date
}

extension Mate: DocumentSerializable {
    
    init?(documentData: [String : Any]) {
        let id = documentData[FireKeys.Mate.id] as? String ?? ""
        let name = documentData[FireKeys.Mate.name] as? String ?? ""
        let reason = documentData[FireKeys.Mate.reason] as? String ?? ""
        let status = documentData[FireKeys.Mate.status] as? Int ?? 0
        let end = documentData[FireKeys.Mate.end] as? Date ?? Date()
        let start = documentData[FireKeys.Mate.start] as? Date ?? Date()
        
        self.init(id: id, name: name, reason: reason, status: status, end: end, start: start)
    }
    
    init(document: DocumentSnapshot) {
        self.id = document.documentID
        self.name = document.get("name") as? String ?? ""
        self.reason = document.get("reason") as? String ?? ""
        self.status = document.get("status") as? Int ?? 0
        self.start = document.get("start") as? Date ?? Date()
        self.end = document.get("end") as? Date ?? Date()
    }
    
    var toJSONSnapshot: [String: Any] {
        return [
            "id": self.id,
            "name": self.name,
            "reason": self.status,
            "end": self.end,
            "start": self.start
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

