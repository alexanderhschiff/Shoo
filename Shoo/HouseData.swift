//
//  HouseData.swift
//  Shoo
//
//  Created by Benjamin Schiff on 5/17/20.
//  Copyright © 2020 Alexander Schiff. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase

struct Mate: Identifiable {
    var id: String
    var name: String
    var reason: String
    var status: Int
    var end: Date?
}

class HouseData: ObservableObject {
    var houseID: String
    var houseName: String = "Home"
    @Published var mates: [Mate] = []
    
    let db = Firestore.firestore()
    
    
    init(userID: String) {
        houseID = ""
        let homesRef = db.collection("Houses")
        
        //gets the id for each house - CAN LATER IMPLEMENT TO INCLUDE MULTIPLE HOUSES
        _ = homesRef.whereField("Mates", arrayContains: userID).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.houseID = document.documentID
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
        //if a house exists
        if (houseID != ""){
            db.collection("houses").document(houseID).collection("Mates")
                .addSnapshotListener { snap, err in
                    if err != nil{
                        self.createHouse(uid: userID)
                        return
                    }
                    for i in snap!.documentChanges{
                        
                        let id = i.document.documentID
                        let name = i.document.get("name") as! String
                        let reason = i.document.get("reason") as! String
                        let status = i.document.get("status") as! Int
                        let end = i.document.get("end") as? Date
                        
                        self.mates.append(Mate(id: id, name: name, reason: reason, status: status, end: end))
                    }
            }
        }
            //no house exists - create house
        else {
            createHouse(uid: userID)
        }
    }
    
    private func createHouse(uid: String) {
        //create a new house and add myself
        var ref: DocumentReference? = nil
        ref = db.collection("houses").addDocument(data: [
            "name": "house",
            "mates": [uid]
        ]){ err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        houseID = ref?.documentID ?? ""
    }
}
